#TL:1:Gnome::Gdk3::Visual:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Visual

Low-level display hardware information

=comment ![](images/X.png)

=head1 Description

A B<Gnome::Gdk3::Visual> describes a particular video hardware display format. It includes information about the number of bits used for each color, the way the bits are translated into an RGB value for display, and the way the bits are stored in memory. For example, a piece of display hardware might support 24-bit color, 16-bit color, or 8-bit color; meaning 24/16/8-bit pixel sizes. For a given pixel size, pixels can be in different formats; for example the “red” element of an RGB pixel may be in the top 8 bits of the pixel, or may be in the lower 4 bits.

There are several standard visuals. The visual returned by C<gdk-screen-get-system-visual()> is the system’s default visual, and the visual returned by C<gdk-screen-get-rgba-visual()> should be used for creating windows with an alpha channel.

A number of functions are provided for determining the “best” available visual. For the purposes of making this determination, higher bit depths are considered better, and for visuals of the same bit depth, C<GDK-VISUAL-PSEUDO-COLOR> is preferred at 8bpp, otherwise, the visual types are ranked in the order of(highest to lowest) C<GDK-VISUAL-DIRECT-COLOR>, C<GDK-VISUAL-TRUE-COLOR>, C<GDK-VISUAL-PSEUDO-COLOR>, C<GDK-VISUAL-STATIC-COLOR>, C<GDK-VISUAL-GRAYSCALE>, then C<GDK-VISUAL-STATIC-GRAY>.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::Visual;
  also is Gnome::GObject::Object;



=comment head2 Uml Diagram

=comment ![](plantuml/.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gdk3::Visual;

  unit class MyGuiClass;
  also is Gnome::Gdk3::Visual;

  submethod new ( |c ) {
    # let the Gnome::Gdk3::Visual class process the options
    self.bless( :GdkVisual, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::GObject::Object;

#-------------------------------------------------------------------------------
unit class Gnome::Gdk3::Visual:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkVisualType

A set of values that describe the manner in which the pixel values for a visual are converted into RGB values for display.

=item GDK-VISUAL-STATIC-GRAY: Each pixel value indexes a grayscale value directly.
=item GDK-VISUAL-GRAYSCALE: Each pixel is an index into a color map that maps pixel values into grayscale values. The color map can be changed by an application.
=item GDK-VISUAL-STATIC-COLOR: Each pixel value is an index into a predefined, unmodifiable color map that maps pixel values into RGB values.
=item GDK-VISUAL-PSEUDO-COLOR: Each pixel is an index into a color map that maps pixel values into rgb values. The color map can be changed by an application.
=item GDK-VISUAL-TRUE-COLOR: Each pixel value directly contains red, green, and blue components. Use C<get-red-pixel-details()>, etc, to obtain information about how the components are assembled into a pixel value.
=item GDK-VISUAL-DIRECT-COLOR: Each pixel value contains red, green, and blue components as for C<GDK-VISUAL-TRUE-COLOR>, but the components are mapped via a color table into the final output table instead of being converted directly.

=end pod

#TE:0:GdkVisualType:
enum GdkVisualType is export (
  'GDK_VISUAL_STATIC_GRAY',
  'GDK_VISUAL_GRAYSCALE',
  'GDK_VISUAL_STATIC_COLOR',
  'GDK_VISUAL_PSEUDO_COLOR',
  'GDK_VISUAL_TRUE_COLOR',
  'GDK_VISUAL_DIRECT_COLOR'
);

#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=begin comment
=head3 default, no options

Create a new Visual object.

  multi method new ( )
=end comment

=head3 :native-object

Create a Visual object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gdk3::Visual' #`{{ or %options<GdkVisual> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gdk_visual_new___x___($no);
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gdk_visual_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GdkVisual');
  }
}

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-blue-pixel-details:
=begin pod
=head2 get-blue-pixel-details

Obtains values that are needed to calculate blue pixel values in TrueColor and DirectColor. The “mask” is the significant bits within the pixel. The “shift” is the number of bits left we must shift a primary for it to be in position (according to the "mask"). Finally, "precision" refers to how much precision the pixel value contains for a particular primary.

  method get-blue-pixel-details ( UInt $mask )

=item UInt $mask; A pointer to a B<guint32> to be filled in, or C<undefined>
=item Int $shift; A pointer to a B<gint> to be filled in, or C<undefined>
=item Int $precision; A pointer to a B<gint> to be filled in, or C<undefined>
=end pod

method get-blue-pixel-details ( UInt $mask ) {

  gdk_visual_get_blue_pixel_details(
    self.get-native-object-no-reffing, $mask, my gint $shift, my gint $precision
  );
}

sub gdk_visual_get_blue_pixel_details (
  N-GObject $visual, guint32 $mask, gint $shift is rw, gint $precision is rw
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:2:get-depth:
=begin pod
=head2 get-depth

Returns the bit depth of this visual.

  method get-depth ( --> Int )

=end pod

method get-depth ( --> Int ) {
  gdk_visual_get_depth(self.get-native-object-no-reffing)
}

sub gdk_visual_get_depth (
  N-GObject $visual --> gint
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-green-pixel-details:
=begin pod
=head2 get-green-pixel-details

Obtains values that are needed to calculate green pixel values in TrueColor and DirectColor. The “mask” is the significant bits within the pixel. The “shift” is the number of bits left we must shift a primary for it to be in position (according to the "mask"). Finally, "precision" refers to how much precision the pixel value contains for a particular primary.

  method get-green-pixel-details ( UInt $mask )

=item UInt $mask; A pointer to a B<guint32> to be filled in, or C<undefined>
=item Int $shift; A pointer to a B<gint> to be filled in, or C<undefined>
=item Int $precision; A pointer to a B<gint> to be filled in, or C<undefined>
=end pod

method get-green-pixel-details ( UInt $mask ) {

  gdk_visual_get_green_pixel_details(
    self.get-native-object-no-reffing, $mask, my gint $shift, my gint $precision
  );
}

sub gdk_visual_get_green_pixel_details (
  N-GObject $visual, guint32 $mask, gint $shift is rw, gint $precision is rw
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-red-pixel-details:
=begin pod
=head2 get-red-pixel-details

Obtains values that are needed to calculate red pixel values in TrueColor and DirectColor. The “mask” is the significant bits within the pixel. The “shift” is the number of bits left we must shift a primary for it to be in position (according to the "mask"). Finally, "precision" refers to how much precision the pixel value contains for a particular primary.

  method get-red-pixel-details ( UInt $mask )

=item UInt $mask; A pointer to a B<guint32> to be filled in, or C<undefined>
=item Int $shift; A pointer to a B<gint> to be filled in, or C<undefined>
=item Int $precision; A pointer to a B<gint> to be filled in, or C<undefined>
=end pod

method get-red-pixel-details ( UInt $mask ) {

  gdk_visual_get_red_pixel_details(
    self.get-native-object-no-reffing, $mask, my gint $shift, my gint $precision
  );
}

sub gdk_visual_get_red_pixel_details (
  N-GObject $visual, guint32 $mask, gint $shift is rw, gint $precision is rw
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:get-screen:
=begin pod
=head2 get-screen

Gets the screen to which this visual belongs

Returns: the screen to which this visual belongs.

  method get-screen ( --> N-GObject )

=end pod

method get-screen ( --> N-GObject ) {

  gdk_visual_get_screen(
    self.get-native-object-no-reffing,
  )
}

sub gdk_visual_get_screen (
  N-GObject $visual --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-visual-type:
=begin pod
=head2 get-visual-type

Returns the type of visual this is (PseudoColor, TrueColor, etc).

Returns: A B<Gnome::Gdk3::VisualType> stating the type of I<visual>.

  method get-visual-type ( --> GdkVisualType )

=end pod

method get-visual-type ( --> GdkVisualType ) {
  GdkVisualType(gdk_visual_get_visual_type(self.get-native-object-no-reffing))
}

sub gdk_visual_get_visual_type (
  N-GObject $visual --> GEnum
) is native(&gdk-lib)
  { * }
