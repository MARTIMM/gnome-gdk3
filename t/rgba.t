use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;

#-------------------------------------------------------------------------------
subtest 'rgba set', {
  my Gnome::Gdk3::RGBA::GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );

  is $color.green, 0.5, 'green ok';
}

#-------------------------------------------------------------------------------
done-testing;