use v6;
use NativeCall;
use Test;
#use lib '../gnome-gtk3/lib';

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;

use Gnome::Gdk3::Display;
use Gnome::Gdk3::Window;

use Gnome::Gdk3::Events;
ok 1, 'load module ok';

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::Events $e;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
#  $e .= new(:type(GDK_KEY_PRESS));
  $e .= new(:type(GDK_BUTTON_PRESS));
  isa-ok $e, Gnome::Gdk3::Events, '.new(:type)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  my Gnome::Gtk3::Button $b .= new(:label<Start>);
  with my Gnome::Gtk3::Window $gtk-window .= new {
    .set-title('test events');
    .add($b);
    .show-all;
  }

  my Gnome::Gdk3::Display $display = $gtk-window.get-display-rk;
  my Gnome::Gdk3::Window $gdk-window .= new(
    :native-object($gtk-window.get-window)
  );
#note "display: $display.is-valid(), $display.get-name()";
#note "gdk window: $gdk-window.is-valid()";

#  my N-GdkEventButton $event .= new(
  my Gnome::Gdk3::Events $event .= new(
    :type(GDK_BUTTON_PRESS), :x(20e0), :y(20e0), :time(time),
    :window($gdk-window)
  );

#`{{
    N-GdkEventButton.new(
      :type(GDK_BUTTON_PRESS),
      :window($gdk-window),
      :send_event(1),
      :time(time),
      :x(20), :y(20), # :axes(Num),
      #:state(0),
      #:button(1),
#            Gnome::Gdk3::Events.new.get-source-device($event),
#            :x_root(20), :y_root(20)
    )
  );
}}

note "event: $event.gist()";
}


#-------------------------------------------------------------------------------
done-testing;

=finish





use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::Events;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'Events ISA test', {
  my Gnome::Gdk3::Events $be .= new;
  isa-ok $be, Gnome::Gdk3::Events;
}

#-------------------------------------------------------------------------------
done-testing;
