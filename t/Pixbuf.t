use v6;
#use lib '../gnome-native/lib';
use NativeCall;
use Test;

use Gnome::Glib::Error;
use Gnome::Glib::Quark;
use Gnome::Gdk3::Pixbuf;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::Pixbuf $p;
my Gnome::Glib::Quark $quark .= new;
my Gnome::Glib::Error $e;
#-------------------------------------------------------------------------------
subtest 'ISA test', {

  $p .= new( :file<t/Data/unknown-image.png>);
  $e = $p.last-error;
  if $e.is-valid {
    is $quark.to-string($e.domain), 'g-file-error-quark',
       'domain text is g-file-error-quark';

    # 4 is value of G_FILE_ERROR_NOENT in enum GFileError (not defined yet)
    # See also https://developer.gnome.org/glib/stable/glib-File-Utilities.html
    is $e.code, 4, 'error code for this error is 4';
  }

  $p .= new(:file<t/Data/some-test-file.xyz>);
  $e = $p.last-error;
  if $e.is-valid {
    is $quark.to-string($e.domain), 'gdk-pixbuf-error-quark',
       'domain text is gdk-pixbuf-error-quark';
    is $e.domain, $p.error-quark, '.error-quark()';
    is GdkPixbufError($e.code), GDK_PIXBUF_ERROR_UNKNOWN_TYPE,
       'error code for this error is ' ~ GDK_PIXBUF_ERROR_UNKNOWN_TYPE;
  }

  $p .= new(:file<t/Data/gtk-raku.png>);
  isa-ok $p, Gnome::Gdk3::Pixbuf, '.new(:file)';

  $p .= new( :file<t/Data/gtk-raku.png>, :100width, :100height);
  isa-ok $p, Gnome::Gdk3::Pixbuf, '.new(:file, :width, :height)';

  $p .= new(
    :file<t/Data/gtk-raku.png>, :100width, :100height,
    :!preserve_aspect_ratio
  );
  isa-ok $p, Gnome::Gdk3::Pixbuf,
         '.new(:file, :width, :height, :preserve_aspect_ratio)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $p .= new(:file<t/Data/gtk-raku.png>);

  is GdkColorspace($p.get-colorspace), GDK_COLORSPACE_RGB, '.get-colorspace()';
  is $p.get-n-channels, 4, '.get-n-channels()';           # rgb + alpha
  ok $p.get-has-alpha, '.get-has-alpha()';                # yes
  is $p.get-bits-per-sample, 8, '.get-bits-per-sample()'; # 8 bits per color
  is $p.get-width, 192, '.get-width()';
  is $p.get-height, 197, '.get-height()';
  is $p.get-rowstride, 192 * 4, '.get-rowstride()';       # width * 4 bytes
  is $p.get-byte-length, 192 * 197 * 4, '.get-byte-length()';

  if %*ENV<travis_ci_tests> {
    skip '.calculate-rowstride() not known';
  }

  else {
    is $p.calculate-rowstride( GDK_COLORSPACE_RGB, True, 8, 10, 2), 40,
       '.calculate-rowstride()';                            # 10 * 4
  }

#note "GDK_TYPE_PIXBUF: ", $p.get-type;

#`{{
Gnome::N::debug(:on);
  my Array[UInt] $pb = $p.get-pixels;
  is $pb.elems, $p.get-byte-length, '.get-pixels(): ' ~ $pb.elems;

  # on x, y = 111, 8 color = rgba( 0, 0, 252, 255)
  my Int $rs = $p.get-rowstride;
  my Int $color-location = 8 * $rs + 111 * 4;
  is $pb[ $color-location + 0], 0, 'pixel at ( 111, 7): red = 0';
  is $pb[ $color-location + 1], 0, 'pixel at ( 111, 7): green = 0';
  is $pb[ $color-location + 2], 252, 'pixel at ( 111, 7): blue = 252';
  is $pb[ $color-location + 3], 255, 'pixel at ( 111, 7): alpha = 255';
}}

#Gnome::N::debug(:on);
  my Gnome::Gdk3::Pixbuf $p-part .= new(
    :native-object($p.new-subpixbuf( 80, 100, 10, 10))
  );
#  is $p-part.get-rowstride, 40, '.new-subpixbuf()';
  is $p-part.get-width, 10, '.new-subpixbuf()';
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
