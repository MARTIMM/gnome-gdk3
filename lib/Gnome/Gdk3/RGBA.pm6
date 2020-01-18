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

  my Gnome::Gdk3::RGBA $color .= new(
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
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 N-GdkRGBA

N-GdkRGBA is a convenient way to pass rgba colors around. It’s based on cairo’s way to deal with colors and mirrors its behavior. All values are in the range from 0.0 to 1.0 inclusive. So the color (0.0, 0.0, 0.0, 0.0) represents transparent black and (1.0, 1.0, 1.0, 1.0) is opaque white. Other values will be clamped to this range when drawing.

The colors originally where B<Num> type but they can now also be B<Int>, B<Rat>, B<Str> or B<Num> as long as they represent a number between 0 and 1.

=item $.red; The intensity of the red channel from 0.0 to 1.0 inclusive
=item $.green; The intensity of the green channel from 0.0 to 1.0 inclusive
=item $.blue; The intensity of the blue channel from 0.0 to 1.0 inclusive
=item $.alpha; The opacity of the color from 0.0 for completely translucent to 1.0 for opaque

  my N-GdkRGBA $c .= new( :red(1), :green(1), :blue(0.5), :alpha(0.99));

=end pod
# TT:1:GdkRGBA:Obsolete
class GdkRGBA is repr('CStruct') is export is DEPRECATED('N-GdkRGBA') {
  has num64 $.red;
  has num64 $.green;
  has num64 $.blue;
  has num64 $.alpha;
}

#TT:1:N-GdkRGBA:
class N-GdkRGBA is repr('CStruct') is export {
  has num64 $.red;
  has num64 $.green;
  has num64 $.blue;
  has num64 $.alpha;

  submethod BUILD ( :$red = 1, :$green = 1, :$blue = 1, :$alpha = 1 ) {
    $!red = $red.Num;
    $!green = $green.Num;
    $!blue = $blue.Num;
    $!alpha = $alpha.Num;
  }
}

#-------------------------------------------------------------------------------
# keys come from gdk_rgba_hash and are Int;
my %rgba-hash{UInt} = %();
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new object using colors and transparency values. Their ranges are from 0 to 1

  multi method new ( :$red!, :$green!, :$blue!, :$alpha! )

Create an object using a string which is parsed with C<gdk_rgba_parse()>. If parsing fails, the color is set to opaque white. The colors originally where B<Num> type but they can now also be B<Int>, B<Rat>, B<Str> or B<Num> as long as they represent a number between 0 and 1.

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

    my Num $red = %options<red>.Num // 1.0e1;
    my Num $green = %options<green>.Num // 1.0e1;
    my Num $blue = %options<blue>.Num // 1.0e1;
    my Num $alpha = %options<alpha>.Num // 1.0e1;

    self.set-native-object(N-GdkRGBA.new( :$red, :$green, :$blue, :$alpha));
  }

  elsif ? %options<rgba> {
    if %options<rgba> ~~ N-GdkRGBA {
      self.set-native-object(%options<rgba>);
    }

    elsif %options<rgba> ~~ Gnome::Gdk3::RGBA {
      self.set-native-object(%options<rgba>.get-native-object);
    }

    elsif %options<rgba> ~~ Str {
      my N-GdkRGBA $c .= new(
        :red(1.0e0), :green(1.0e0), :blue(1.0e0), :alpha(1.0e0)
      );
      self.set-native-object($c);
      my Int $ok = gdk_rgba_parse( $c, %options<rgba>);
      self.set-native-object($c) if $ok;
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
  try { $s = &::("gdk_rgba_$native-sub"); };
  try { $s = &::("gdk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gdk_' /;

  self.set-class-name-of-sub('GdkRgba');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 red

Set the red color to a new value if provided. Returns original or newly set color value.

  method red ( Num $c? --> Num )

=end pod

#TM:1:red
method red ( Num $c? is copy --> Num ) {
  if $c.defined {
    $c = 0e0 if $c < 0e0;
    $c = 1e0 if $c > 1e0;

    my N-GdkRGBA $o = self.get-native-object;
    my N-GdkRGBA $clr .= new(
      :red($c), :green($o.green), :blue($o.blue), :alpha($o.alpha)
    );
    self.set-native-object($clr);
  }

  self.get-native-object.red
}

#-------------------------------------------------------------------------------
=begin pod
=head2 red

Set the green color to a new value if provided. Returns original or newly set color value.

  method green ( Num $c? --> Num )

=end pod

#TM:1:green
method green ( Num $c? is copy --> Num ) {
  if $c.defined {
    $c = 0e0 if $c < 0e0;
    $c = 1e0 if $c > 1e0;

    my N-GdkRGBA $o = self.get-native-object;
    my N-GdkRGBA $clr .= new(
      :red($o.red), :green($c), :blue($o.blue), :alpha($o.alpha)
    );
    self.set-native-object($clr);
  }

  self.get-native-object.green
}

#-------------------------------------------------------------------------------
=begin pod
=head2 red

Set the blue color to a new value if provided. Returns original or newly set color value.

  method blue ( Num $c? --> Num )

=end pod

#TM:1:blue
method blue ( Num $c? is copy --> Num ) {
  if $c.defined {
    $c = 0e0 if $c < 0e0;
    $c = 1e0 if $c > 1e0;

    my N-GdkRGBA $o = self.get-native-object;
    my N-GdkRGBA $clr .= new(
      :red($o.red), :green($o.green), :blue($c), :alpha($o.alpha)
    );
    self.set-native-object($clr);
  }

  self.get-native-object.blue
}

#-------------------------------------------------------------------------------
=begin pod
=head2 alpha

Set the alpha transparency to a new value if provided. Returns original or newly set value.

  method alpha ( Num $c? --> Num )

=end pod

#TM:1:alpha
method alpha ( Num $c? is copy --> Num ) {
  if $c.defined {
    $c = 0e0 if $c < 0e0;
    $c = 1e0 if $c > 1e0;

    my N-GdkRGBA $o = self.get-native-object;
    my N-GdkRGBA $clr .= new(
      :red($o.red), :green($o.green), :blue($o.blue), :alpha($c)
    );
    self.set-native-object($clr);
  }

  self.get-native-object.alpha
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

#`{{ Not needed because of simulated copy
#-------------------------------------------------------------------------------
#TM:FF:gdk_rgba_free:
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
}}

#-------------------------------------------------------------------------------
#TM:1:gdk_rgba_hash(UInt):
#TM:1:gdk_rgba_hash(N-GdkRGBA):
=begin pod
=head2 gdk_rgba_hash

A method that stores B<Gnome::Gdk3::RGBA> objects in a hash or to return a value. Note that the original GTK function only returns a uint32 value and does not provide a hash table storage facility

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

Parses a textual representation of a color and set / overwrite the values in the I<red>, I<green>, I<blue> and I<alpha> fields in this B<Gnome::Gdk3::RGBA>.

The string can be either one of:
=item A standard name (Taken from the X11 rgb.txt file).
=item A hexadecimal value in the form B<#rgb>, B<#rrggbb>, B<#rrrgggbbb> or B<#rrrrggggbbbb>.
=item A RGB color in the form B<rgb(r,g,b)> (In this case the color will have full opacity).
=item A RGBA color in the form B<rgba(r,g,b,a)>.

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
=head2 [[gdk_] rgba_] to_string

Returns a textual specification of this rgba object in the form B<rgb(r,g,b)> or B<rgba(r,g,b,a)>, where C<r>, C<g>, C<b> and C<a> represent the red, green, blue and alpha values respectively. r, g, and b are represented as integers in the range 0 to 255, and a is represented as floating point value in the range 0 to 1.

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
