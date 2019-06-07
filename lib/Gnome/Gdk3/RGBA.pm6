use v6;
use NativeCall;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gdktypes.h
unit class Gnome::Gdk3::RGBA:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkRGBA

GdkRGBA is a convenient way to pass rgba colors around. It’s based on cairo’s way to deal with colors and mirrors its behavior. All values are in the range from 0.0 to 1.0 inclusive. So the color (0.0, 0.0, 0.0, 0.0) represents transparent black and (1.0, 1.0, 1.0, 1.0) is opaque white. Other values will be clamped to this range when drawing.

=item $.red; The intensity of the red channel from 0.0 to 1.0 inclusive
=item $.green; The intensity of the green channel from 0.0 to 1.0 inclusive
=item $.blue; The intensity of the blue channel from 0.0 to 1.0 inclusive
=item $.alpha; The opacity of the color from 0.0 for completely translucent to 1.0 for opaque

=end pod
class GdkRGBA is repr('CStruct') is export {
  has num64 $.red;
  has num64 $.green;
  has num64 $.blue;
  has num64 $.alpha;
}
