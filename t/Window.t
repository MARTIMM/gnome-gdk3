use v6;
use NativeCall;
use Test;
#use lib '../perl6-gnome-native/lib';
#use lib '../perl6-gnome-gobject/lib';

use Gnome::Gdk3::Window;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::Window $w .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gdk3::Window $w .= new(:empty);
  isa-ok $w, Gnome::Gdk3::Window;

  my Int $wtype = $w.get-window-type;
  is GdkWindowType($wtype), GDK_WINDOW_TOPLEVEL, 'toplevel window type';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  $w.gdk-window-move( 500, 600);
  my Int ( $x, $y) = $w.get-position;
  is $x, 0, 'x is still 0';
  is $y, 0, 'y is still 0';

  $w.gdk-window-resize( 200, 300);
  is $w.get-width, 1, 'width is still 1';
  is $w.get-height, 1, 'height is still 1';
}


#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
