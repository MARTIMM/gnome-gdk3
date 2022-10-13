use v6;
#use lib '../gnome-native/lib';
#use NativeCall;
use Test;

use Gnome::Gdk3::Visual;
use Gnome::Gdk3::Screen;
ok 1, 'nome::Gdk3::Visual loads ok';

# this line removes an error: No such symbol 'Gnome::Gdk3::Screen'
#use Gnome::N::N-GObject;
#Gnome::Gdk3::Screen.new(:native-object(N-GObject));


#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::Visual $v;
my Gnome::Gdk3::Screen $s;
#-------------------------------------------------------------------------------
#subtest 'ISA test', {
#  $v .= new;
#  isa-ok $v, Gnome::Gdk3::Visual, '.new()';
#}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $s .= new;
  $v = $s.get-rgba-visual.();
  lives-ok { diag 'rgb: ' ~ $v.get-depth; }, '.get-rgba-visual()';
  lives-ok { diag 'blue pix: ' ~ $v.get-blue-pixel-details; },
    '.get-blue-pixel-details()';
  lives-ok { diag 'green pix: ' ~ $v.get-green-pixel-details; },
    '.get-green-pixel-details()';
  lives-ok { diag 'red pix: ' ~ $v.get-red-pixel-details; },
    '.get-red-pixel-details()';

  my Gnome::Gdk3::Screen $s2 .= new(:native-object($v.get-screen));
  lives-ok { diag 'display name: ' ~ $s2.get-display.().get-name;},
    '.get-screen()';

# TODO Error in Visual?; No such symbol 'Gnome::Gdk3::Screen' error
#note $?LINE, ', ', $v.get-screen.().gist;
#  $s2 = $v.get-screen.(Gnome::Gdk3::Screen);
#note $?LINE;
  lives-ok { diag 'display name: ' ~ $s2.get-display.().get-name;},
    '.get-screen()';
  lives-ok { diag 'visual type: ' ~ $v.get-visual-type;}, '.get-visual-type()';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gdk3::Visual', {
  class MyClass is Gnome::Gdk3::Visual {
    method new ( |c ) {
      self.bless( :GdkVisual, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gdk3::Visual, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gdk3::Visual $v .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $v.get-property( $prop, $gv);
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
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
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
      Gnome::Gdk3::Visual() :$_native-object, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gdk3::Visual;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gdk3::Visual :$widget --> Str ) {

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

  my Gnome::Gdk3::Visual $v .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $v.register-signal( $sh, 'method', 'signal');

  my Promise $p = $v.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
