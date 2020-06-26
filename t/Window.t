use v6;
use NativeCall;
use Test;
#use lib '../gnome-native/lib';
#use lib '../gnome-gobject/lib';

#use Gnome::Cairo::Types;
use Gnome::Cairo::Enums;
use Gnome::Cairo::Surface;

use Gnome::Gdk3::Window;

use Gnome::N::X;
Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::Window $w .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gdk3::Window $w .= new;
  isa-ok $w, Gnome::Gdk3::Window;

  my Int $wtype = $w.get-window-type;
  is GdkWindowType($wtype), GDK_WINDOW_TOPLEVEL, '.get-window-type()';
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

  my Gnome::Cairo::Surface $surface .= new(
    :native-object($w.create-similar-surface( CAIRO_CONTENT_COLOR, 1, 1))
  );
  ok $surface.is-valid, '.create-similar-surface()';
  $surface.clear-object;

  $surface .= new(
    :native-object(
      $w.create-similar-image-surface( CAIRO_FORMAT_ARGB32, 1, 1, 0)
    )
  );
  ok $surface.is-valid, '.create-similar-image-surface()';
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
