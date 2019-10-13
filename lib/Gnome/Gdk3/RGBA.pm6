#TL:1:Gnome::Gdk3::Rgba:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Rgba

RGBA colors

=head1 Description

B<Gnome::Gdk3::RGBA> is a convenient way to pass rgba colors around.
It’s based on cairo’s way to deal with colors and mirrors its behavior.
All values are in the range from 0.0 to 1.0 inclusive. So the color
(0.0, 0.0, 0.0, 0.0) represents transparent black and
(1.0, 1.0, 1.0, 1.0) is opaque white. Other values will be clamped
to this range when drawing.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::RGBA;
  also is Gnome::GObject::Boxed;

=head2 Example

  my GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );

=end pod
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkrgba.h
unit class Gnome::Gdk3::RGBA:auth<github:MARTIMM>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkRGBA

GdkRGBA is a convenient way to pass rgba colors around. It’s based on cairo’s way to deal with colors and mirrors its behavior. All values are in the range from 0.0 to 1.0 inclusive. So the color (0.0, 0.0, 0.0, 0.0) represents transparent black and (1.0, 1.0, 1.0, 1.0) is opaque white. Other values will be clamped to this range when drawing.

=item $.red; The intensity of the red channel from 0.0 to 1.0 inclusive
=item $.green; The intensity of the green channel from 0.0 to 1.0 inclusive
=item $.blue; The intensity of the blue channel from 0.0 to 1.0 inclusive
=item $.alpha; The opacity of the color from 0.0 for completely translucent to 1.0 for opaque

=end pod
#TT:1:GdkRGBA
class GdkRGBA is repr('CStruct') is export is DEPRECATED('N-GdkRGBA') {
  has num64 $.red;
  has num64 $.green;
  has num64 $.blue;
  has num64 $.alpha;
}

class N-GdkRGBA is repr('CStruct') is export {
  has num64 $.red;
  has num64 $.green;
  has num64 $.blue;
  has num64 $.alpha;
}

#-------------------------------------------------------------------------------
# keys come from gdk_rgba_hash and are Int;
my %rgba-hash{UInt} = %();
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new object using colors and transparency values. Their ranges are from 0 to 1

  multi method new ( Num :$red!, Num :$green!, Num :$blue!, Num :$alpha! )

Create an object using a string which is parsed with C<gdk_rgba_parse()>. If parsing fails, the color is set to opaque white.

  multi method new ( Str :$rgba! )

Create an object using a native object from elsewhere.

  multi method new ( Gnome::GObject::Object :$rgba! )

=end pod

#TM:1:new(:red,:green,:blue,:alpha):
#TM:1:new(:rgba(Gnome::Gdk3::RGBA)):
#TM:1:new(:rgba(N-GdkRGBA)):
#TM:1:new(:rgba(Str)):

submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk3::RGBA';

  # process all named arguments
  if ? %options<red> or ? %options<green> or
     ? %options<blue> or ? %options<alpha> {

    my Num $red = %options<red> // 1.0e1;
    my Num $green = %options<green> // 1.0e1;
    my Num $blue = %options<blue> // 1.0e1;
    my Num $alpha = %options<alpha> // 1.0e1;

    self.native-gboxed(N-GdkRGBA.new( :$red, :$green, :$blue, :$alpha));
  }

  elsif ? %options<rgba> {
    if %options<rgba> ~~ N-GdkRGBA {
      self.native-gboxed(%options<rgba>);
    }

    elsif %options<rgba> ~~ Gnome::Gdk3::RGBA {
      self.native-gboxed(%options<rgba>.get-native-gboxed);
    }

    elsif %options<rgba> ~~ Str {
      my N-GdkRGBA $c .= new(
        :red(1.0e0), :green(1.0e0), :blue(1.0e0), :alpha(1.0e0)
      );
      self.native-gboxed($c);
      my Int $ok = gdk_rgba_parse( $c, %options<rgba>);
      self.native-gboxed($c) if $ok;
    }

    else {
      die X::Gnome.new(:message('Improper type for :rgba option'));
    }
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GdkRgba');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gdk_rgba_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:gdk_rgba_copy:
=begin pod
=head2 gdk_rgba_copy

Makes a copy of a B<Gnome::Gdk3::RGBA>.

=comment The result must be freed through C<gdk_rgba_free()>.

Returns: A newly allocated B<Gnome::Gdk3::RGBA>, with the same contents as I<rgba>

Since: 3.0

  method gdk_rgba_copy ( N-GObject $rgba --> N-GObject  )

=item N-GdkRGBA $rgba; a B<Gnome::Gdk3::RGBA>

=end pod

# make my own version of copy...
sub gdk_rgba_copy ( N-GdkRGBA $rgba ) {
  my N-GdkRGBA $clone .= new(
    :red($rgba.red), :green($rgba.green),
    :blue($rgba.blue), :alpha($rgba.alpha)
  );

  $clone
}

#`[[ Not needed because of simulated copy
#-------------------------------------------------------------------------------
# TM:0:gdk_rgba_free:
=begin pod
=head2 gdk_rgba_free

Frees a B<Gnome::Gdk3::RGBA> created with C<gdk_rgba_copy()>

Since: 3.0

  method gdk_rgba_free ( N-GObject $rgba )

=item N-GObject $rgba; a B<Gnome::Gdk3::RGBA>

=end pod

sub gdk_rgba_free ( N-GObject $rgba )
  is native(&gdk-lib)
  { * }
]]

#-------------------------------------------------------------------------------
#TM:1:gdk_rgba_hash(UInt):
#TM:1:gdk_rgba_hash(N-GdkRGBA):
=begin pod
=head2 gdk_rgba_hash

A method that stores B<Gnome::Gdk3::RGBAs> values in a hash or to return a value. Note that the original GTK function only returns a uint32 value and does not provide a hash table storage facility

  multi method gdk_rgba_hash ( N-GdkRGBA $p --> UInt )

  multi method gdk_rgba_hash ( UInt $hash-int --> N-GdkRGBA )

=item N-GdkRGBA $p; a B<Gnome::Gdk3::RGBA> value to store
=item UInt $hash-int; a key to return a previously stored B<N-GdkRGBA> value

=end pod

# use $rgba-hash
proto gdk_rgba_hash ( N-GdkRGBA $p, | ) { * }
multi sub gdk_rgba_hash ( N-GdkRGBA $p --> UInt ) {
  %rgba-hash{my UInt $hash-int = _gdk_rgba_hash($p)} = $p;
  $hash-int
}

multi sub gdk_rgba_hash ( N-GdkRGBA $p, UInt $hash-int --> N-GdkRGBA ) {
  %rgba-hash{$hash-int}
}

sub _gdk_rgba_hash ( N-GdkRGBA $p )
  returns uint32
  is native(&gdk-lib)
  is symbol('gdk_rgba_hash')
  { * }


#-------------------------------------------------------------------------------
#TM:1:gdk_rgba_equal:
=begin pod
=head2 gdk_rgba_equal

Compare native RGBA color with a given one.

Returns: C<1> if the two colors compare equal

Since: 3.0

  method gdk_rgba_equal ( N-GdkRGBA $compare-with --> Int )

=item N-GdkRGBA $compare-with; another B<Gnome::Gdk3::RGBA> pointer

=end pod

sub gdk_rgba_equal ( N-GdkRGBA $p1, N-GdkRGBA $p2 )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_rgba_parse:
=begin pod
=head2 gdk_rgba_parse

Parses a textual representation of a color and set / overwrite the values in
the I<red>, I<green>, I<blue> and I<alpha> fields in this B<Gnome::Gdk3::RGBA>.

The string can be either one of:
- A standard name (Taken from the X11 rgb.txt file).
- A hexadecimal value in the form “\B<rgb>”, “\B<rrggbb>”,
“\B<rrrgggbbb>” or ”\B<rrrrggggbbbb>”
- A RGB color in the form “rgb(r,g,b)” (In this case the color will
have full opacity)
- A RGBA color in the form “rgba(r,g,b,a)”

Where “r”, “g”, “b” and “a” are respectively the red, green, blue and
alpha color values. In the last two cases, r g and b are either integers
in the range 0 to 255 or precentage values in the range 0% to 100%, and
a is a floating point value in the range 0 to 1.

Returns: C<1> if the parsing succeeded

Since: 3.0

  method gdk_rgba_parse ( Str $spec --> Int )

=item N-GObject $rgba; the B<Gnome::Gdk3::RGBA> to fill in
=item Str $spec; the string specifying the color

=end pod

sub gdk_rgba_parse ( N-GdkRGBA $rgba is rw, Str $spec )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_rgba_to_string:
=begin pod
=head2 [gdk_rgba_] to_string

Returns a textual specification of I<rgba> in the form
`rgb (r, g, b)` or
`rgba (r, g, b, a)`,
where “r”, “g”, “b” and “a” represent the red, green,
blue and alpha values respectively. r, g, and b are
represented as integers in the range 0 to 255, and a
is represented as floating point value in the range 0 to 1.

These string forms are string forms those supported by
the CSS3 colors module, and can be parsed by C<gdk_rgba_parse()>.

Note that this string representation may lose some
precision, since r, g and b are represented as 8-bit
integers. If this is a concern, you should use a
different representation.

Returns: A newly allocated text string

Since: 3.0

  method gdk_rgba_to_string ( N-GdkRGBA $rgba --> Str  )

=item N-GObject $rgba; a native B<Gnome::Gdk3::RGBA>

=end pod

sub gdk_rgba_to_string ( N-GdkRGBA $rgba )
  returns Str
  is native(&gdk-lib)
  { * }
