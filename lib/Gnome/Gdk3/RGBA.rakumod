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

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::GObject::Boxed:api<1>;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkrgba.h
unit class Gnome::Gdk3::RGBA:auth<github:MARTIMM>:api<1>;
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
#TT:1:N-GdkRGBA:
class N-GdkRGBA is repr('CStruct') is export {
  has gdouble $.red;
  has gdouble $.green;
  has gdouble $.blue;
  has gdouble $.alpha;

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
=head3 :red, :green, :blue, :alpha

Create a new object using colors and transparency values. Their ranges are from 0 to 1. All values are optional and are set to 1e0 by default.

  multi method new (
    Num() :$red, Num() :$green, Num() :$blue, Num() :$alpha
  )

=item $.red; The intensity of the red channel from 0.0 to 1.0 inclusive
=item $.green; The intensity of the green channel from 0.0 to 1.0 inclusive
=item $.blue; The intensity of the blue channel from 0.0 to 1.0 inclusive
=item $.alpha; The opacity of the color from 0.0 for completely translucent to 1.0 for opaque


=head3 :rgba

Create an object using a string which is parsed with C<parse()>. If parsing fails, the color is set to opaque white.

  multi method new ( Str :$rgba! )


=head3 :native-object

Create an object using a native object from elsewhere. See also B<Gnome::N::TopLevelSupportClass>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:1:new(:red,:green,:blue,:alpha):
#TM:1:new(:native-object(Gnome::Gdk3::RGBA)):
#TM:1:new(:native-object(N-GdkRGBA)):
#TM:1:new(:rgba(Str)):
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  if self.^name eq 'Gnome::Gdk3::RGBA' {

    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my N-GdkRGBA $n-rgba;

      # process all named arguments
      if ? %options<red> or ? %options<green> or
         ? %options<blue> or ? %options<alpha> {

        my Num $red = (%options<red> // 1.0e1).Num;
        my Num $green = (%options<green> // 1.0e1).Num;
        my Num $blue = (%options<blue> // 1.0e1).Num;
        my Num $alpha = (%options<alpha> // 1.0e1).Num;

        $n-rgba = N-GdkRGBA.new( :$red, :$green, :$blue, :$alpha);
      }

      elsif %options<rgba> ~~ Str {
        my N-GdkRGBA $c .= new(
          :red(1.0e0), :green(1.0e0), :blue(1.0e0), :alpha(1.0e0)
        );
        $n-rgba = $c;
        my Int $ok = _gdk_rgba_parse( $c, %options<rgba>);
        $n-rgba = $c if $ok;
      }

      elsif %options.keys.elems {
        die X::Gnome.new(
          :message('Unsupported options for ' ~ self.^name ~
                   ': ' ~ %options.keys.join(', ')
                  )
        );
      }

      else {
        $n-rgba .= new(
          :red(1.0e0), :green(1.0e0), :blue(1.0e0), :alpha(1.0e0)
        );
      }

      self._set-native-object(nativecast( N-GObject, $n-rgba));
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GdkRgba');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gdk_rgba_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gdk_rgba_$native-sub", $new-patt, '0.19.11', '0.21.0'
    );
  }

  else {
    try { $s = &::("gdk_$native-sub"); }
    if ?$s {
      Gnome::N::deprecate(
        "gdk_$native-sub", $new-patt.subst('gdk-'), '0.19.11', '0.21.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if $native-sub ~~ m/^ 'gdk_' /;
      if ?$s {
        Gnome::N::deprecate(
          $native-sub, $new-patt.subst('gdk-rgba-'), '0.19.11', '0.21.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GdkRgba');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
# no ref/unref
method native-object-ref ( $n-native-object --> Any ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) { }

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

    my N-GdkRGBA $o = nativecast( N-GdkRGBA, self._get-native-object);
    my N-GdkRGBA $clr .= new(
      :red($o.red), :green($o.green), :blue($o.blue), :alpha($c)
    );
    self._set-native-object(nativecast( N-GObject, $clr));
  }

  nativecast( N-GdkRGBA, self._get-native-object).alpha
}

#-------------------------------------------------------------------------------
=begin pod
=head2 blue

Set the blue color to a new value if provided. Returns original or newly set color value.

  method blue ( Num $c? --> Num )

=end pod

#TM:1:blue
method blue ( Num $c? is copy --> Num ) {
  if $c.defined {
    $c = 0e0 if $c < 0e0;
    $c = 1e0 if $c > 1e0;

    my N-GdkRGBA $o = nativecast( N-GdkRGBA, self._get-native-object);
    my N-GdkRGBA $clr .= new(
      :red($o.red), :green($o.green), :blue($c), :alpha($o.alpha)
    );
    self._set-native-object(nativecast( N-GObject, $clr));
  }

  nativecast( N-GdkRGBA, self._get-native-object).blue
}

#-------------------------------------------------------------------------------
#TM:1:copy:
=begin pod
=head2 copy

Makes a copy of a B<Gnome::Gdk3::RGBA>.

=comment The result must be freed through C<gdk_rgba_free()>.

Returns: A newly allocated B<Gnome::Gdk3::RGBA>, with the same contents as this I<rgba> object

  method copy ( --> N-GObject )

=item N-GdkRGBA $rgba; a B<Gnome::Gdk3::RGBA>

=end pod

# make my own version of copy...
sub gdk_rgba_copy ( N-GObject() $c --> N-GObject ) {
  my N-GdkRGBA $rgba = nativecast( N-GdkRGBA, $c);

  my N-GdkRGBA $clone .= new(
    :red($rgba.red), :green($rgba.green),
    :blue($rgba.blue), :alpha($rgba.alpha)
  );

  nativecast( N-GObject, $clone)
}

method copy ( --> N-GObject ) {
  my N-GdkRGBA $rgba = nativecast(
    N-GdkRGBA, self._get-native-object-no-reffing
  );

  my N-GdkRGBA $clone .= new(
    :red($rgba.red), :green($rgba.green),
    :blue($rgba.blue), :alpha($rgba.alpha)
  );

  nativecast( N-GObject, $clone)
}

#`{{ Not needed because of simulated copy
#-------------------------------------------------------------------------------
# TM:FF:gdk_rgba_free:
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
#TM:1:gequal:
=begin pod
=head2 equal

Compare native RGBA color with a given one.

Returns: C<True> if the two colors compare equal

  method equal ( N-GObject() $compare-with --> Bool )

=item $compare-with; another B<Gnome::Gdk3::RGBA> object

=end pod

method equal ( N-GObject() $compare-with --> Bool ) {
  my N-GdkRGBA $o1 = nativecast( N-GdkRGBA, self._get-native-object);
  my N-GdkRGBA $o2 = nativecast( N-GdkRGBA, $compare-with);
  _gdk_rgba_equal( $o1, $o2).Bool
}

sub gdk_rgba_equal ( N-GObject() $p1, N-GObject() $p2 --> gboolean ) {
  my N-GdkRGBA $o1 = nativecast( N-GdkRGBA, $p1);
  my N-GdkRGBA $o2 = nativecast( N-GdkRGBA, $p2);
  _gdk_rgba_equal( $o1, $o2).Bool
}

sub _gdk_rgba_equal ( N-GdkRGBA $p1, N-GdkRGBA $p2 --> gboolean )
  is native(&gdk-lib)
  is symbol('gdk_rgba_equal')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 green

Set the green color to a new value if provided. Returns original or newly set color value.

  method green ( Num $c? --> Num )

=end pod

#TM:1:green
method green ( Num $c? is copy --> Num ) {
  if $c.defined {
    $c = 0e0 if $c < 0e0;
    $c = 1e0 if $c > 1e0;

    my N-GdkRGBA $o = nativecast( N-GdkRGBA, self._get-native-object);
    my N-GdkRGBA $clr .= new(
      :red($o.red), :green($c), :blue($o.blue), :alpha($o.alpha)
    );
    self._set-native-object(nativecast( N-GObject, $clr));
  }

  nativecast( N-GdkRGBA, self._get-native-object).green
}

#-------------------------------------------------------------------------------
#TM:1:hash(N-GObject):
#TM:1:hash(UInt):
=begin pod
=head2 hash

A method that stores B<Gnome::Gdk3::RGBA> objects in a hash or to return a value. Note that the original GTK function only returns a C<UInt> value and does not provide a hash table storage facility.

  multi method hash ( N-GObject() $p --> UInt )

  multi method hash ( UInt $key --> N-GObject )

=item $p; a B<Gnome::Gdk3::RGBA> value to store
=item $key; a key to return a previously stored B<N-GdkRGBA> value

=end pod

# use $rgba-hash
proto sub gdk_rgba_hash ( N-GObject, | ) { * }
multi sub gdk_rgba_hash ( N-GObject $p --> UInt ) {
  my N-GdkRGBA $o = nativecast( N-GdkRGBA, $p);
  %rgba-hash{my UInt $key = _gdk_rgba_hash($o)} = $o;
  $key
}

multi sub gdk_rgba_hash ( N-GObject $p, UInt $key --> N-GObject ) {
  nativecast( N-GObject, %rgba-hash{$key})
}


multi method hash ( --> UInt ) {
  my N-GdkRGBA $o = nativecast( N-GdkRGBA, self._get-native-object);
  %rgba-hash{my UInt $key = _gdk_rgba_hash($o)} = $o;
  $key
}

multi method hash ( UInt $key --> N-GObject ) {
  nativecast( N-GObject, %rgba-hash{$key})
}

# generate a key only!
sub _gdk_rgba_hash ( N-GdkRGBA $p --> guint32 )
  is native(&gdk-lib)
  is symbol('gdk_rgba_hash')
  { * }

#-------------------------------------------------------------------------------
#TM:1:parse:
=begin pod
=head2 parse

Parses a textual representation of a color and set / overwrite the values in the I<red>, I<green>, I<blue> and I<alpha> fields in this B<Gnome::Gdk3::RGBA> object.

The string can be either one of:
=item A standard name (Taken from the X11 rgb.txt file).
=item A hexadecimal value in the form B<#rgb>, B<#rrggbb>, B<#rrrgggbbb> or B<#rrrrggggbbbb>.
=item A RGB color in the form B<rgb(r,g,b)> (In this case the color will have full opacity).
=item A RGBA color in the form B<rgba(r,g,b,a)>.

Where “r”, “g”, “b” and “a” are respectively the red, green, blue and alpha color values. In the last two cases, r g and b are either integers in the range 0 to 255 or precentage values in the range 0% to 100%, and a is a floating point value in the range 0 to 1.

Returns: C<True> if the parsing succeeded

  method parse ( Str $spec --> Bool )

=item Str $spec; the string specifying the color

=end pod

method parse( Str $spec --> Bool ) {
  my N-GdkRGBA $rgba .= new;
  my Bool $r = _gdk_rgba_parse( $rgba, $spec).Bool;
  self._set-native-object(nativecast( N-GObject, $rgba)) if $r;
  $r
}

sub gdk_rgba_parse ( N-GObject $rgba is rw, Str $spec --> Bool ) {
  my N-GdkRGBA $o = nativecast( N-GdkRGBA, $rgba);
  my Bool $r = _gdk_rgba_parse( $o, $spec).Bool;
  $rgba = nativecast( N-GObject, $o);
  $r
}

sub _gdk_rgba_parse ( N-GdkRGBA $rgba is rw, Str $spec --> gboolean )
  is native(&gdk-lib)
  is symbol('gdk_rgba_parse')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 red

Set the red color to a new value if provided. Returns original or newly set color value.

  method red ( Num() $c? --> Num )

=end pod

#TM:1:red
method red ( Num() $c? is copy --> Num ) {
  if $c.defined {
    $c = 0e0 if $c < 0e0;
    $c = 1e0 if $c > 1e0;

    my N-GdkRGBA $o = nativecast( N-GdkRGBA, self._get-native-object);
    my N-GdkRGBA $clr .= new(
      :red($c), :green($o.green), :blue($o.blue), :alpha($o.alpha)
    );
    self._set-native-object(nativecast( N-GObject, $clr));
  }

  nativecast( N-GdkRGBA, self._get-native-object).red
}

#-------------------------------------------------------------------------------
#TM:1:to-string:
=begin pod
=head2 to-string

Returns a textual specification of this rgba object in the form B<rgb(r,g,b)> or B<rgba(r,g,b,a)>, where C<r>, C<g>, C<b> and C<a> represent the red, green, blue and alpha values respectively. r, g, and b are represented as integers in the range 0 to 255, and a is represented as floating point value in the range 0 to 1.

These string forms are string forms those supported by the CSS3 colors module, and can be parsed by C<parse()>.

Note that this string representation may lose some precision, since r, g and b are represented as 8-bit integers. If this is a concern, you should use a different representation.

Returns: A newly allocated text string

  method to-string ( --> Str )

=item N-GObject $rgba; a native B<Gnome::Gdk3::RGBA>

=end pod

method to-string ( --> Str ) {
  gdk_rgba_to_string(nativecast( N-GdkRGBA, self._get-native-object-no-reffing))
}

sub gdk_rgba_to_string ( N-GdkRGBA $rgba --> Str )
  is native(&gdk-lib)
  { * }
