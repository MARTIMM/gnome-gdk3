use v6;
use NativeCall;
use Test;
#use lib '../perl6-gnome-native/lib';
#use lib '../perl6-gnome-gobject/lib';

use Gnome::Gdk3::Window;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gdk3::Window $window .= new(:empty);
  isa-ok $window, Gnome::Gdk3::Window;

  my Int $wtype = $window.get-window-type;
  is GdkWindowType($wtype), GDK_WINDOW_TOPLEVEL, 'toplevel window type';

  $window.gdk-window-move( 500, 600);
  my Int ( $x, $y) = $window.get-position;
  is $x, 0, 'x is still 0';
  is $y, 0, 'y is still 0';

  $window.gdk-window-resize( 200, 300);
  is $window.get-width, 1, 'width is still 1';
  is $window.get-height, 1, 'height is still 1';
}

#-------------------------------------------------------------------------------
done-testing;
