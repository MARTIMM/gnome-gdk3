use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::Window;
use Gnome::Gdk3::Device;
use Gnome::Gdk3::Keysyms;

use Gnome::Gdk3::Events;
ok 1, 'load module ok';

use Gnome::N::N-GObject;
#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::Events $e;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $e .= new(:type(GDK_BUTTON_PRESS));
  isa-ok $e, Gnome::Gdk3::Events, '.new(:type)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gdk3::Window $gdk-window .= new;

  $e .= new(
    :type(GDK_BUTTON_PRESS), :window($gdk-window), :x(10), :y(20),
    :x_root(0), :y_root(0)
  );

  nok $e.get-device.(Gnome::Gdk3::Device).is-valid, '.get-device()';
  ok $e.get-window.(Gnome::Gdk3::Window).is-valid, '.get-window()';



  $e .= new(
    :type(GDK_KEY_RELEASE), :window($gdk-window), :keyval(GDK_KEY_Shift_L),
    :hardware_keycode('a'.ord)
  );

  ok $e.get-window.(Gnome::Gdk3::Window).is-valid, '.get-window()';


  $e .= new(
    :type(GDK_MOTION_NOTIFY), :window($gdk-window)
  );

  nok $e.get-device.(Gnome::Gdk3::Device).is-valid, '.get-device()';
  ok $e.get-window.(Gnome::Gdk3::Window).is-valid, '.get-window()';
}

#-------------------------------------------------------------------------------
done-testing;

=finish
