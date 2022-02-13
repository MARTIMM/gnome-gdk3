use v6;
#use lib '../gnome-gobject/lib', '../gnome-native/lib';
#use lib '../gnome-native/lib';
use Test;


use Gnome::N::N-GObject;

use Gnome::GObject::Object;
use Gnome::GObject::Type;

use Gnome::Gdk3::Display;
use Gnome::Gdk3::Screen;


#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::Screen $s;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $s .= new;
  isa-ok $s, Gnome::Gdk3::Screen, '.new()';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  lives-ok {
    diag 'display name: ' ~ Gnome::Gdk3::Display.new(
      :native-object($s.get-display)
    ).get-name;
  }, '.get-display()';

  lives-ok { diag 'display name: ' ~ (my Gnome::Gdk3::Display() $d = $s.get-display).get-name;},
    '.get-display()';

  lives-ok { diag 'resolution: ' ~ $s.get-resolution; }, '.get-resolution()';
  lives-ok { diag 'rgb: ' ~ $s.get-rgba-visual.().get-depth; },
    '.get-rgba-visual()';

  lives-ok { $s.get-root-window.().beep; }, '.get-root-window()';
  lives-ok { diag 'sys: ' ~ $s.get-system-visual.().get-depth; },
    '.get-system-visual()';
  lives-ok { diag 'toplevels: ' ~ $s.get-toplevel-windows-rk.length; },
    '.get-toplevel-windows()';
  lives-ok { diag 'win stack: ' ~ $s.get-window-stack-rk.length; },
    '.get-window-stack()';
  ok 1, '.is-composited(): ' ~ $s.is-composited;
  lives-ok { diag 'list visuals: ' ~ $s.list-visuals-rk.length; },
    '.list-visuals()';

  lives-ok {$s.set-resolution('96.0');}, '.set-resolution()';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

# nice to remember

with $s.get-rgba-visual {
  note .defined;
  note .^name;
  note .gist;
  note .().get-depth;
  note .('Gnome::Gdk3::Visual').get-depth;
}




# Some props are tests but still not on travis tests because devices may return
# different values and therefore fail.
#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gdk3::Screen $s .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $s.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    if $approx {
      is-approx $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }

    # dependency on local settings might result in different values
    elsif $is-local {
      if $gv-value ~~ /$value/ {
        like $gv-value, /$value/, "property $prop, value: " ~ $gv-value;
      }

      else {
        ok 1, "property $prop, value: " ~ $gv-value;
      }
    }

    else {
      is $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }
    $gv.clear-object;
  }

  # example calls
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  test-property( G_TYPE_FLOAT, 'resolution', 'get-float', 96e0, :approx);
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gdk3::Screen', {
  class MyClass is Gnome::Gdk3::Screen {
    method new ( |c ) {
      self.bless( :GdkScreen, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gdk3::Screen, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method ... (
      'any-args',
      Gnome::Gdk3::Screen :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gdk3::Screen;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gdk3::Screen :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $widget.emit-by-name(
        'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      );
      is $!signal-processed, True, '\'...\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      #$!signal-processed = False;
      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'...\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }
      sleep(0.4);
      $main.gtk-main-quit;

      'done'
    }
  }

  my Gnome::Gdk3::Screen $s .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $s.register-signal( $sh, 'method', 'signal');

  my Promise $p = $s.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
