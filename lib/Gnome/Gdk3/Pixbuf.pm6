#TL:1:Gnome::Gdk3::Pixbuf:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Pixbuf

Creating a pixbuf from image data that is already in memory.

=comment ![](images/X.png)

=head1 Description


The most basic way to create a pixbuf is to wrap an existing pixel buffer with a B<Gnome::Gdk3::Pixbuf> structure.  You can use the C<gdk_pixbuf_new_from_data()> function to do this You need to specify the destroy notification function that will be called when the data buffer needs to be freed; this will happen when a B<Gnome::Gdk3::Pixbuf> is finalized by the reference counting functions If you have a chunk of static data compiled into your application, you can pass in C<Any> as the destroy notification function so that the data will not be freed.

The C<gdk_pixbuf_new()> function can be used as a convenience to create a pixbuf with an empty buffer.  This is equivalent to allocating a data buffer using C<malloc()> and then wrapping it with C<gdk_pixbuf_new_from_data()>. The C<gdk_pixbuf_new()> function will compute an optimal rowstride so that rendering can be performed with an efficient algorithm.

As a special case, you can use the C<gdk_pixbuf_new_from_xpm_data()> function to create a pixbuf from inline XPM image data.

You can also copy an existing pixbuf with the C<gdk_pixbuf_copy()> function.  This is not the same as just doing a C<g_object_ref()> on the old pixbuf; the copy function will actually duplicate the pixel data in memory and create a new B<Gnome::Gdk3::Pixbuf> structure for it.



=begin comment
=head2 Implemented Interfaces

Gnome::Gdk3::Pixbuf implements
=comment ?? item Gnome::Gio::GIcon
=comment ?? item Gnome::Gio::GLoadableIcon

=end comment

=head2 See Also

C<gdk_pixbuf_finalize()>.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::Pixbuf;
  also is Gnome::GObject::Object;

=comment  ?? also does Gnome::GIcon;
=comment  ?? also does Gnome::GLoadableIcon;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Object;
use Gnome::Glib::Error;

#use Gnome::Gtk3::Orientable;
#use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gdk3::Pixbuf:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#also does Gnome::Gtk3::Buildable;
#also does Gnome::Gtk3::Orientable;


#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkPixbufAlphaMode

These values can be passed to C<gdk_pixbuf_xlib_render_to_drawable_alpha()> to control how the alpha channel of an image should be handled.  This function can create a bilevel clipping mask (black and white) and use it while painting the image.  In the future, when the X Window System gets an alpha channel extension, it will be possible to do full alpha compositing onto arbitrary drawables.  For now both cases fall back to a bilevel clipping mask.


=item GDK_PIXBUF_ALPHA_BILEVEL: A bilevel clipping mask (black and white) will be created and used to draw the image.  Pixels below 0.5 opacity will be considered fully transparent, and all others will be considered fully opaque.
=item GDK_PIXBUF_ALPHA_FULL: For now falls back to B<GDK_PIXBUF_ALPHA_BILEVEL>. In the future it will do full alpha compositing.


=end pod

#TE:0:GdkPixbufAlphaMode:
enum GdkPixbufAlphaMode is export (
  'GDK_PIXBUF_ALPHA_BILEVEL',
  'GDK_PIXBUF_ALPHA_FULL'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkColorspace

This enumeration defines the color spaces that are supported by the gdk-pixbuf library.  Currently only RGB is supported.


=item GDK_COLORSPACE_RGB: Indicates a red/green/blue additive color space.


=end pod

#TE:1:GdkColorspace:
enum GdkColorspace is export (
  'GDK_COLORSPACE_RGB'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkPixbufError

An error code in the B<GDK_PIXBUF_ERROR> domain. Many gdk-pixbuf
operations can cause errors in this domain, or in the B<G_FILE_ERROR>
domain.


=item GDK_PIXBUF_ERROR_CORRUPT_IMAGE: An image file was broken somehow.
=item GDK_PIXBUF_ERROR_INSUFFICIENT_MEMORY: Not enough memory.
=item GDK_PIXBUF_ERROR_BAD_OPTION: A bad option was passed to a pixbuf save module.
=item GDK_PIXBUF_ERROR_UNKNOWN_TYPE: Unknown image type.
=item GDK_PIXBUF_ERROR_UNSUPPORTED_OPERATION: Don't know how to perform the given operation on the type of image at hand.
=item GDK_PIXBUF_ERROR_FAILED: Generic failure code, something went wrong.
=item GDK_PIXBUF_ERROR_INCOMPLETE_ANIMATION: Only part of the animation was loaded.


=end pod

#TE:1:GdkPixbufError:
enum GdkPixbufError is export (
  'GDK_PIXBUF_ERROR_CORRUPT_IMAGE',
  'GDK_PIXBUF_ERROR_INSUFFICIENT_MEMORY',
  'GDK_PIXBUF_ERROR_BAD_OPTION',
  'GDK_PIXBUF_ERROR_UNKNOWN_TYPE',
  'GDK_PIXBUF_ERROR_UNSUPPORTED_OPERATION',
  'GDK_PIXBUF_ERROR_FAILED',
  'GDK_PIXBUF_ERROR_INCOMPLETE_ANIMATION'
);

#-------------------------------------------------------------------------------
has Gnome::Glib::Error $.last-error .= new(:gerror(N-GError));
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object and load pixbuf from file.

  multi method new ( Str :$file!, Bool :$throw = True )

=end pod

#TM:1:new(:file):
submethod BUILD ( *%options is copy ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk3::Pixbuf';

  # process all named arguments
  %options<throw> //= True;
  if ? %options<file> {
    my N-GObject $o;
    my Gnome::Glib::Error $e;
    ( $o, $e) = gdk_pixbuf_new_from_file(%options<file>);
    if $e.error-is-valid {
      $!last-error = $e;

      die X::Gnome.new(
        :message(
          "Error creating a Pixbuf from file %options<file>, message: " ~
          $e.message
        )
      ) if %options<throw>;
    }

    else {
      self.set-native-object($o);
    }
  }

  elsif ? %options<pixbuf> {
    self.set-native-object(%options<pixbuf>);
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GdkPixbuf');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gdk_pixbuf_$native-sub"); };
  try { $s = &::("gdk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gdk_' /;
#  $s = self._buildable_interface($native-sub) unless ?$s;
#  $s = self._orientable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GdkPixbuf');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_error_quark:
=begin pod
=head2 [gdk_pixbuf_] error_quark

  method gdk_pixbuf_error_quark ( --> Int  )

=end pod

sub gdk_pixbuf_error_quark (  )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_get_colorspace:
=begin pod
=head2 [gdk_pixbuf_] get_colorspace

Queries the color space of a pixbuf.

Return value: Color space enum value.

  method gdk_pixbuf_get_colorspace ( --> GdkColorspace  )


=end pod

sub gdk_pixbuf_get_colorspace ( N-GObject $pixbuf )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_get_n_channels:
=begin pod
=head2 [gdk_pixbuf_] get_n_channels

Queries the number of channels of a pixbuf.

  method gdk_pixbuf_get_n_channels ( --> Int  )

=end pod

sub gdk_pixbuf_get_n_channels ( N-GObject $pixbuf )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_get_has_alpha:
=begin pod
=head2 [gdk_pixbuf_] get_has_alpha

Queries whether a pixbuf has an alpha channel (opacity information). C<1> if it has an alpha channel, C<0> otherwise.

  method gdk_pixbuf_get_has_alpha ( --> Int  )

=end pod

sub gdk_pixbuf_get_has_alpha ( N-GObject $pixbuf )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_get_bits_per_sample:
=begin pod
=head2 [gdk_pixbuf_] get_bits_per_sample

Queries the number of bits per color sample in a pixbuf.

  method gdk_pixbuf_get_bits_per_sample ( --> Int  )


=end pod

sub gdk_pixbuf_get_bits_per_sample ( N-GObject $pixbuf )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_get_pixels:
=begin pod
=head2 [gdk_pixbuf_] get_pixels

Queries a pointer to the pixel data of a pixbuf.

Return value: (array): A pointer to the pixbuf's pixel data. Please see the section on [image data][image-data] for information about how the pixel data is stored in memory.

This function will cause an implicit copy of the pixbuf data if the pixbuf was created from read-only data.

  method gdk_pixbuf_get_pixels ( --> Array[byte] )


=end pod

sub gdk_pixbuf_get_pixels ( N-GObject $pixbuf --> Array ) {
  my CArray[uint8] $pb = _gdk_pixbuf_get_pixels($pixbuf);
  my $pbl = gdk_pixbuf_get_byte_length($pixbuf);
  note "pl: $pbl, ", $pb[0].WHAT;
  my Array[UInt] $a .= new();
  for ^$pbl -> $i {
    $a[$i] = $pb[$i];
  }

  $a
}

sub _gdk_pixbuf_get_pixels ( N-GObject $pixbuf )
  returns Pointer
  is native(&gdk-pixbuf-lib)
  is symbol('gdk_pixbuf_get_pixels')
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_get_width:
=begin pod
=head2 [gdk_pixbuf_] get_width

Queries the width of a pixbuf.

  method gdk_pixbuf_get_width ( --> Int  )

=end pod

sub gdk_pixbuf_get_width ( N-GObject $pixbuf )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_get_height:
=begin pod
=head2 [gdk_pixbuf_] get_height

Queries the height of a pixbuf.

  method gdk_pixbuf_get_height ( --> Int  )

=end pod

sub gdk_pixbuf_get_height ( N-GObject $pixbuf )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_get_rowstride:
=begin pod
=head2 [gdk_pixbuf_] get_rowstride

Queries the rowstride of a pixbuf, which is the number of bytes between the start of a row and the start of the next row.

Return value: Distance between row starts.

  method gdk_pixbuf_get_rowstride ( --> Int  )


=end pod

sub gdk_pixbuf_get_rowstride ( N-GObject $pixbuf )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_get_byte_length:
=begin pod
=head2 [gdk_pixbuf_] get_byte_length

Returns the length of the pixel data, in bytes.

Since: 2.26

  method gdk_pixbuf_get_byte_length ( --> UInt  )


=end pod

sub gdk_pixbuf_get_byte_length ( N-GObject $pixbuf )
  returns uint64
  is native(&gdk-pixbuf-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_get_pixels_with_length:
=begin pod
=head2 [gdk_pixbuf_] get_pixels_with_length

Queries a pointer to the pixel data of a pixbuf.

Return value: (array length=length): A pointer to the pixbuf's
pixel data.  Please see the section on [image data][image-data]
for information about how the pixel data is stored in memory.

This function will cause an implicit copy of the pixbuf data if the
pixbuf was created from read-only data.

Since: 2.26

  method gdk_pixbuf_get_pixels_with_length ( UInt $length --> CArray[byte]  )

=item UInt $length; (out): The length of the binary data.

=end pod

sub gdk_pixbuf_get_pixels_with_length ( N-GObject $pixbuf, uint32 $length )
  returns CArray[byte]
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_read_pixels:
=begin pod
=head2 [gdk_pixbuf_] read_pixels

Provides a read-only pointer to the raw pixel data; must not be
modified.  This function allows skipping the implicit copy that
must be made if C<gdk_pixbuf_get_pixels()> is called on a read-only
pixbuf.

Returns: a read-only pointer to the raw pixel data

Since: 2.32

  method gdk_pixbuf_read_pixels ( --> UInt  )


=end pod

sub gdk_pixbuf_read_pixels ( N-GObject $pixbuf )
  returns byte
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_read_pixel_bytes:
=begin pod
=head2 [gdk_pixbuf_] read_pixel_bytes

Provides a B<GBytes> buffer containing the raw pixel data; the data
must not be modified.  This function allows skipping the implicit
copy that must be made if C<gdk_pixbuf_get_pixels()> is called on a
read-only pixbuf.

Returns: (transfer full): A new reference to a read-only copy of
the pixel data.  Note that for mutable pixbufs, this function will
incur a one-time copy of the pixel data for conversion into the
returned B<GBytes>.

Since: 2.32

  method gdk_pixbuf_read_pixel_bytes ( --> N-GObject  )


=end pod

sub gdk_pixbuf_read_pixel_bytes ( N-GObject $pixbuf )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new:
=begin pod
=head2 gdk_pixbuf_new

Creates a new B<Gnome::Gdk3::Pixbuf> structure and allocates a buffer for it.  The buffer has an optimal rowstride.  Note that the buffer is not cleared; you will have to fill it completely yourself.

Return value: (nullable): A newly-created B<Gnome::Gdk3::Pixbuf> with a reference count of 1, or C<Any> if not enough memory could be allocated for the image buffer.

  method gdk_pixbuf_new (
    GdkColorspace $colorspace, Int $has_alpha, Int $bits_per_sample,
    Int $width, Int $height
    --> N-GObject
  )

=item GdkColorspace $colorspace; Color space for image
=item Int $has_alpha; Whether the image should have transparency information
=item Int $bits_per_sample; Number of bits per color sample
=item Int $width; Width of image in pixels, must be > 0
=item Int $height; Height of image in pixels, must be > 0

=end pod

sub gdk_pixbuf_new ( int32 $colorspace, int32 $has_alpha, int32 $bits_per_sample, int32 $width, int32 $height )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_calculate_rowstride:
=begin pod
=head2 [gdk_pixbuf_] calculate_rowstride

Calculates the rowstride that an image created with those values would have. This is useful for front-ends and backends that want to sanity check image values without needing to create them.

Return value: the rowstride for the given values, or -1 in case of error.

Since: 2.36.8

  method gdk_pixbuf_calculate_rowstride (
    GdkColorspace $colorspace, Int $has_alpha, Int $bits_per_sample,
    Int $width, Int $height
    --> Int
  )

=item GdkColorspace $colorspace; Color space for image
=item Int $has_alpha; Whether the image should have transparency information
=item Int $bits_per_sample; Number of bits per color sample
=item Int $width; Width of image in pixels, must be > 0
=item Int $height; Height of image in pixels, must be > 0

=end pod

sub gdk_pixbuf_calculate_rowstride ( int32 $colorspace, int32 $has_alpha, int32 $bits_per_sample, int32 $width, int32 $height )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_copy:
=begin pod
=head2 gdk_pixbuf_copy

Creates a new B<Gnome::Gdk3::Pixbuf> with a copy of the information in the specified I<pixbuf>. Note that this does not copy the options set on the original B<Gnome::Gdk3::Pixbuf>, use C<gdk_pixbuf_copy_options()> for this.

Return value: (nullable) (transfer full): A newly-created pixbuf with a reference count of 1, or C<Any> if not enough memory could be allocated.

  method gdk_pixbuf_copy ( --> N-GObject  )


=end pod

sub gdk_pixbuf_copy ( N-GObject $pixbuf )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_pixbuf_new_subpixbuf:
=begin pod
=head2 [gdk_pixbuf_] new_subpixbuf

Creates a new pixbuf which represents a sub-region this pixel buffer. The new pixbuf shares its pixels with the original pixbuf, so writing to one affects both.  The new pixbuf holds a reference to this buffer, so this buffer will not be finalized until the new pixbuf is finalized.

Note that if this buffer is read-only, this function will force it to be mutable.

Return value: a new pixbuf

  method gdk_pixbuf_new_subpixbuf (
    Int $src_x, Int $src_y, Int $width, Int $height
    --> N-GObject
  )

=item Int $src_x; X coord in this pixel buffer
=item Int $src_y; Y coord in this pixel buffer
=item Int $width; width of region in this pixel buffer
=item Int $height; height of region in this pixel buffer

=end pod

sub gdk_pixbuf_new_subpixbuf (
  N-GObject $src_pixbuf, int32 $src_x, int32 $src_y,
  int32 $width, int32 $height
) returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new_from_file_utf8:
=begin pod
=head2 [gdk_pixbuf_] new_from_file_utf8



  method gdk_pixbuf_new_from_file_utf8 ( Str $filename, N-GError $error --> N-GObject  )

=item Str $filename;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_file_utf8 ( Str $filename, N-GError $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new_from_file_at_size_utf8:
=begin pod
=head2 [gdk_pixbuf_] new_from_file_at_size_utf8



  method gdk_pixbuf_new_from_file_at_size_utf8 ( Str $filename, Int $width, Int $height, N-GError $error --> N-GObject  )

=item Str $filename;
=item Int $width;
=item Int $height;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_file_at_size_utf8 ( Str $filename, int32 $width, int32 $height, N-GError $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new_from_file_at_scale_utf8:
=begin pod
=head2 [gdk_pixbuf_] new_from_file_at_scale_utf8



  method gdk_pixbuf_new_from_file_at_scale_utf8 ( Str $filename, Int $width, Int $height, Int $preserve_aspect_ratio, N-GError $error --> N-GObject  )

=item Str $filename;
=item Int $width;
=item Int $height;
=item Int $preserve_aspect_ratio;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_file_at_scale_utf8 ( Str $filename, int32 $width, int32 $height, int32 $preserve_aspect_ratio, N-GError $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:2:gdk_pixbuf_new_from_file:new(:file)
=begin pod
=head2 [gdk_pixbuf_] new_from_file

Creates a new pixbuf by loading an image from a file. The file format is detected automatically. If NULL is returned, then error will be set. Possible errors are in the GDK_PIXBUF_ERROR and G_FILE_ERROR domains.

  method gdk_pixbuf_new_from_file ( Str $filename, N-GError $error --> N-GObject  )

=item Str $filename;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_file ( Str $filename --> List ) {
  my N-GError $e;
  my CArray[N-GError] $ga .= new(N-GError);
  my N-GObject $o = _gdk_pixbuf_new_from_file( $filename, $ga);

  ( $o, Gnome::Glib::Error.new(:gerror($ga[0])))
}

sub _gdk_pixbuf_new_from_file ( Str $filename, CArray[N-GError] $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  is symbol('gdk_pixbuf_new_from_file')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new_from_file_at_size:
=begin pod
=head2 [gdk_pixbuf_] new_from_file_at_size

Creates a new pixbuf by loading an image from a file. The file format is detected automatically. If NULL is returned, then error will be set. Possible errors are in the GDK_PIXBUF_ERROR and G_FILE_ERROR domains.

The image will be scaled to fit in the requested size, preserving the image's aspect ratio. Note that the returned pixbuf may be smaller than width x height , if the aspect ratio requires it. To load and image at the requested size, regardless of aspect ratio, use gdk_pixbuf_new_from_file_at_scale().

  method gdk_pixbuf_new_from_file_at_size ( Str $filename, Int $width, Int $height, N-GError $error --> N-GObject  )

=item Str $filename;
=item Int $width;
=item Int $height;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_file_at_size ( Str $filename, int32 $width, int32 $height, N-GError $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new_from_file_at_scale:
=begin pod
=head2 [gdk_pixbuf_] new_from_file_at_scale

Creates a new pixbuf by loading an image from a file. The file format is detected automatically. If NULL is returned, then error will be set. Possible errors are in the GDK_PIXBUF_ERROR and G_FILE_ERROR domains. The image will be scaled to fit in the requested size, optionally preserving the image's aspect ratio.

When preserving the aspect ratio, a width of -1 will cause the image to be scaled to the exact given height, and a height of -1 will cause the image to be scaled to the exact given width. When not preserving aspect ratio, a width or height of -1 means to not scale the image at all in that dimension. Negative values for width and height are allowed since 2.8.

  method gdk_pixbuf_new_from_file_at_scale ( Str $filename, Int $width, Int $height, Int $preserve_aspect_ratio, N-GError $error --> N-GObject  )

=item Str $filename;
=item Int $width;
=item Int $height;
=item Int $preserve_aspect_ratio;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_file_at_scale ( Str $filename, int32 $width, int32 $height, int32 $preserve_aspect_ratio, N-GError $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new_from_resource:
=begin pod
=head2 [gdk_pixbuf_] new_from_resource



  method gdk_pixbuf_new_from_resource ( Str $resource_path, N-GError $error --> N-GObject  )

=item Str $resource_path;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_resource ( Str $resource_path, N-GError $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new_from_resource_at_scale:
=begin pod
=head2 [gdk_pixbuf_] new_from_resource_at_scale

Creates a new pixbuf by loading an image from an resource.

The file format is detected automatically. If NULL is returned, then error will be set.

  method gdk_pixbuf_new_from_resource_at_scale ( Str $resource_path, Int $width, Int $height, Int $preserve_aspect_ratio, N-GError $error --> N-GObject  )

=item Str $resource_path;
=item Int $width;
=item Int $height;
=item Int $preserve_aspect_ratio;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_resource_at_scale ( Str $resource_path, int32 $width, int32 $height, int32 $preserve_aspect_ratio, N-GError $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new_from_data:
=begin pod
=head2 [gdk_pixbuf_] new_from_data



  method gdk_pixbuf_new_from_data ( CArray[byte] $data, GdkColorspace $colorspace, Int $has_alpha, Int $bits_per_sample, Int $width, Int $height, Int $rowstride, GdkPixbufDestroyNotify $destroy_fn, Pointer $destroy_fn_data --> N-GObject  )

=item CArray[byte] $data;
=item GdkColorspace $colorspace;
=item Int $has_alpha;
=item Int $bits_per_sample;
=item Int $width;
=item Int $height;
=item Int $rowstride;
=item GdkPixbufDestroyNotify $destroy_fn;
=item Pointer $destroy_fn_data;

=end pod

sub gdk_pixbuf_new_from_data ( CArray[byte] $data, int32 $colorspace, int32 $has_alpha, int32 $bits_per_sample, int32 $width, int32 $height, int32 $rowstride, GdkPixbufDestroyNotify $destroy_fn, Pointer $destroy_fn_data )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new_from_bytes:
=begin pod
=head2 [gdk_pixbuf_] new_from_bytes



  method gdk_pixbuf_new_from_bytes ( N-GObject $data, GdkColorspace $colorspace, Int $has_alpha, Int $bits_per_sample, Int $width, Int $height, Int $rowstride --> N-GObject  )

=item N-GObject $data;
=item GdkColorspace $colorspace;
=item Int $has_alpha;
=item Int $bits_per_sample;
=item Int $width;
=item Int $height;
=item Int $rowstride;

=end pod

sub gdk_pixbuf_new_from_bytes ( N-GObject $data, int32 $colorspace, int32 $has_alpha, int32 $bits_per_sample, int32 $width, int32 $height, int32 $rowstride )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_new_from_xpm_data:
=begin pod
=head2 [gdk_pixbuf_] new_from_xpm_data



  method gdk_pixbuf_new_from_xpm_data ( CArray[Str] $data --> N-GObject  )

=item CArray[Str] $data;

=end pod

sub gdk_pixbuf_new_from_xpm_data ( CArray[Str] $data )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_fill:
=begin pod
=head2 gdk_pixbuf_fill

Clears a pixbuf to the given RGBA value, converting the RGBA value into
the pixbuf's pixel format. The alpha will be ignored if the pixbuf
doesn't have an alpha channel.


  method gdk_pixbuf_fill ( UInt $pixel )

=item UInt $pixel; RGBA pixel to clear to (0xffffffff is opaque white, 0x00000000 transparent black)

=end pod

sub gdk_pixbuf_fill ( N-GObject $pixbuf, uint32 $pixel )
  is native(&gdk-pixbuf-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_save:
=begin pod
=head2 gdk_pixbuf_save



  method gdk_pixbuf_save ( Str $filename, Str $type, N-GError $error --> Int  )

=item Str $filename;
=item Str $type;
=item N-GError $error;

=end pod

sub gdk_pixbuf_save ( N-GObject $pixbuf, Str $filename, Str $type, N-GError $error, Any $any = Any )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_savev:
=begin pod
=head2 gdk_pixbuf_savev



  method gdk_pixbuf_savev ( Str $filename, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error --> Int  )

=item Str $filename;
=item Str $type;
=item CArray[Str] $option_keys;
=item CArray[Str] $option_values;
=item N-GError $error;

=end pod

sub gdk_pixbuf_savev ( N-GObject $pixbuf, Str $filename, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_savev_utf8:
=begin pod
=head2 [gdk_pixbuf_] savev_utf8



  method gdk_pixbuf_savev_utf8 ( Str $filename, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error --> Int  )

=item Str $filename;
=item Str $type;
=item CArray[Str] $option_keys;
=item CArray[Str] $option_values;
=item N-GError $error;

=end pod

sub gdk_pixbuf_savev_utf8 ( N-GObject $pixbuf, Str $filename, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_save_to_callback:
=begin pod
=head2 [gdk_pixbuf_] save_to_callback



  method gdk_pixbuf_save_to_callback ( GdkPixbufSaveFunc $save_func, Pointer $user_data, Str $type, N-GError $error --> Int  )

=item GdkPixbufSaveFunc $save_func;
=item Pointer $user_data;
=item Str $type;
=item N-GError $error;

=end pod

sub gdk_pixbuf_save_to_callback ( N-GObject $pixbuf, GdkPixbufSaveFunc $save_func, Pointer $user_data, Str $type, N-GError $error, Any $any = Any )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_save_to_callbackv:
=begin pod
=head2 [gdk_pixbuf_] save_to_callbackv



  method gdk_pixbuf_save_to_callbackv ( GdkPixbufSaveFunc $save_func, Pointer $user_data, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error --> Int  )

=item GdkPixbufSaveFunc $save_func;
=item Pointer $user_data;
=item Str $type;
=item CArray[Str] $option_keys;
=item CArray[Str] $option_values;
=item N-GError $error;

=end pod

sub gdk_pixbuf_save_to_callbackv ( N-GObject $pixbuf, GdkPixbufSaveFunc $save_func, Pointer $user_data, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_save_to_buffer:
=begin pod
=head2 [gdk_pixbuf_] save_to_buffer



  method gdk_pixbuf_save_to_buffer ( CArray[Str] $buffer, UInt $buffer_size, Str $type, N-GError $error --> Int  )

=item CArray[Str] $buffer;
=item UInt $buffer_size;
=item Str $type;
=item N-GError $error;

=end pod

sub gdk_pixbuf_save_to_buffer ( N-GObject $pixbuf, CArray[Str] $buffer, uint64 $buffer_size, Str $type, N-GError $error, Any $any = Any )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_save_to_bufferv:
=begin pod
=head2 [gdk_pixbuf_] save_to_bufferv



  method gdk_pixbuf_save_to_bufferv ( CArray[Str] $buffer, UInt $buffer_size, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error --> Int  )

=item CArray[Str] $buffer;
=item UInt $buffer_size;
=item Str $type;
=item CArray[Str] $option_keys;
=item CArray[Str] $option_values;
=item N-GError $error;

=end pod

sub gdk_pixbuf_save_to_bufferv ( N-GObject $pixbuf, CArray[Str] $buffer, uint64 $buffer_size, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:FF:gdk_pixbuf_new_from_stream:
=begin pod
=head2 [gdk_pixbuf_] new_from_stream



  method gdk_pixbuf_new_from_stream ( GInputStream $stream, GCancellable $cancellable, N-GError $error --> N-GObject  )

=item GInputStream $stream;
=item GCancellable $cancellable;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_stream ( GInputStream $stream, GCancellable $cancellable, N-GError $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:FF:gdk_pixbuf_new_from_stream_async:
=begin pod
=head2 [gdk_pixbuf_] new_from_stream_async



  method gdk_pixbuf_new_from_stream_async ( GInputStream $stream, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item GInputStream $stream;
=item GCancellable $cancellable;
=item GAsyncReadyCallback $callback;
=item Pointer $user_data;

=end pod

sub gdk_pixbuf_new_from_stream_async ( GInputStream $stream, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )
  is native(&gdk-pixbuf-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:FF:gdk_pixbuf_new_from_stream_finish:
=begin pod
=head2 [gdk_pixbuf_] new_from_stream_finish



  method gdk_pixbuf_new_from_stream_finish ( GAsyncResult $async_result, N-GError $error --> N-GObject  )

=item GAsyncResult $async_result;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_stream_finish ( GAsyncResult $async_result, N-GError $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:FF:gdk_pixbuf_new_from_stream_at_scale:
=begin pod
=head2 [gdk_pixbuf_] new_from_stream_at_scale



  method gdk_pixbuf_new_from_stream_at_scale ( GInputStream $stream, Int $width, Int $height, Int $preserve_aspect_ratio, GCancellable $cancellable, N-GError $error --> N-GObject  )

=item GInputStream $stream;
=item Int $width;
=item Int $height;
=item Int $preserve_aspect_ratio;
=item GCancellable $cancellable;
=item N-GError $error;

=end pod

sub gdk_pixbuf_new_from_stream_at_scale ( GInputStream $stream, int32 $width, int32 $height, int32 $preserve_aspect_ratio, GCancellable $cancellable, N-GError $error )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:FF:gdk_pixbuf_new_from_stream_at_scale_async:
=begin pod
=head2 [gdk_pixbuf_] new_from_stream_at_scale_async



  method gdk_pixbuf_new_from_stream_at_scale_async ( GInputStream $stream, Int $width, Int $height, Int $preserve_aspect_ratio, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item GInputStream $stream;
=item Int $width;
=item Int $height;
=item Int $preserve_aspect_ratio;
=item GCancellable $cancellable;
=item GAsyncReadyCallback $callback;
=item Pointer $user_data;

=end pod

sub gdk_pixbuf_new_from_stream_at_scale_async ( GInputStream $stream, int32 $width, int32 $height, int32 $preserve_aspect_ratio, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )
  is native(&gdk-pixbuf-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:FF:gdk_pixbuf_save_to_stream:
=begin pod
=head2 [gdk_pixbuf_] save_to_stream



  method gdk_pixbuf_save_to_stream ( GOutputStream $stream, Str $type, GCancellable $cancellable, N-GError $error --> Int  )

=item GOutputStream $stream;
=item Str $type;
=item GCancellable $cancellable;
=item N-GError $error;

=end pod

sub gdk_pixbuf_save_to_stream ( N-GObject $pixbuf, GOutputStream $stream, Str $type, GCancellable $cancellable, N-GError $error, Any $any = Any )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:FF:gdk_pixbuf_save_to_stream_async:
=begin pod
=head2 [gdk_pixbuf_] save_to_stream_async



  method gdk_pixbuf_save_to_stream_async ( GOutputStream $stream, Str $type, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item GOutputStream $stream;
=item Str $type;
=item GCancellable $cancellable;
=item GAsyncReadyCallback $callback;
=item Pointer $user_data;

=end pod

sub gdk_pixbuf_save_to_stream_async ( N-GObject $pixbuf, GOutputStream $stream, Str $type, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data, Any $any = Any )
  is native(&gdk-pixbuf-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:FF:gdk_pixbuf_save_to_stream_finish:
=begin pod
=head2 [gdk_pixbuf_] save_to_stream_finish



  method gdk_pixbuf_save_to_stream_finish ( GAsyncResult $async_result, N-GError $error --> Int  )

=item GAsyncResult $async_result;
=item N-GError $error;

=end pod

sub gdk_pixbuf_save_to_stream_finish ( GAsyncResult $async_result, N-GError $error )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:FF:gdk_pixbuf_save_to_streamv_async:
=begin pod
=head2 [gdk_pixbuf_] save_to_streamv_async



  method gdk_pixbuf_save_to_streamv_async ( GOutputStream $stream, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item GOutputStream $stream;
=item Str $type;
=item CArray[Str] $option_keys;
=item CArray[Str] $option_values;
=item GCancellable $cancellable;
=item GAsyncReadyCallback $callback;
=item Pointer $user_data;

=end pod

sub gdk_pixbuf_save_to_streamv_async ( N-GObject $pixbuf, GOutputStream $stream, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:FF:gdk_pixbuf_save_to_streamv:
=begin pod
=head2 [gdk_pixbuf_] save_to_streamv



  method gdk_pixbuf_save_to_streamv ( GOutputStream $stream, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, GCancellable $cancellable, N-GError $error --> Int  )

=item GOutputStream $stream;
=item Str $type;
=item CArray[Str] $option_keys;
=item CArray[Str] $option_values;
=item GCancellable $cancellable;
=item N-GError $error;

=end pod

sub gdk_pixbuf_save_to_streamv ( N-GObject $pixbuf, GOutputStream $stream, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, GCancellable $cancellable, N-GError $error )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_add_alpha:
=begin pod
=head2 [gdk_pixbuf_] add_alpha



  method gdk_pixbuf_add_alpha ( Int $substitute_color, UInt $r, UInt $g, UInt $b --> N-GObject  )

=item Int $substitute_color;
=item UInt $r;
=item UInt $g;
=item UInt $b;

=end pod

sub gdk_pixbuf_add_alpha ( N-GObject $pixbuf, int32 $substitute_color, byte $r, byte $g, byte $b )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_copy_area:
=begin pod
=head2 [gdk_pixbuf_] copy_area



  method gdk_pixbuf_copy_area ( Int $src_x, Int $src_y, Int $width, Int $height, N-GObject $dest_pixbuf, Int $dest_x, Int $dest_y )

=item Int $src_x;
=item Int $src_y;
=item Int $width;
=item Int $height;
=item N-GObject $dest_pixbuf;
=item Int $dest_x;
=item Int $dest_y;

=end pod

sub gdk_pixbuf_copy_area ( N-GObject $src_pixbuf, int32 $src_x, int32 $src_y, int32 $width, int32 $height, N-GObject $dest_pixbuf, int32 $dest_x, int32 $dest_y )
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_saturate_and_pixelate:
=begin pod
=head2 [gdk_pixbuf_] saturate_and_pixelate



  method gdk_pixbuf_saturate_and_pixelate ( N-GObject $dest, Num $saturation, Int $pixelate )

=item N-GObject $dest;
=item Num $saturation;
=item Int $pixelate;

=end pod

sub gdk_pixbuf_saturate_and_pixelate ( N-GObject $src, N-GObject $dest, num32 $saturation, int32 $pixelate )
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_apply_embedded_orientation:
=begin pod
=head2 [gdk_pixbuf_] apply_embedded_orientation



  method gdk_pixbuf_apply_embedded_orientation ( --> N-GObject  )


=end pod

sub gdk_pixbuf_apply_embedded_orientation ( N-GObject $src )
  returns N-GObject
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_set_option:
=begin pod
=head2 [gdk_pixbuf_] set_option

Attaches a key/value pair as an option to a B<Gnome::Gdk3::Pixbuf>. If I<key> already
exists in the list of options attached to I<pixbuf>, the new value is
ignored and C<0> is returned.

Return value: C<1> on success.

Since: 2.2

  method gdk_pixbuf_set_option ( Str $key, Str $value --> Int  )

=item Str $key; a nul-terminated string.
=item Str $value; a nul-terminated string.

=end pod

sub gdk_pixbuf_set_option ( N-GObject $pixbuf, Str $key, Str $value )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_get_option:
=begin pod
=head2 [gdk_pixbuf_] get_option

Looks up I<key> in the list of options that may have been attached to the
I<pixbuf> when it was loaded, or that may have been attached by another
function using C<gdk_pixbuf_set_option()>.

For instance, the ANI loader provides "Title" and "Artist" options.
The ICO, XBM, and XPM loaders provide "x_hot" and "y_hot" hot-spot
options for cursor definitions. The PNG loader provides the tEXt ancillary
chunk key/value pairs as options. Since 2.12, the TIFF and JPEG loaders
return an "orientation" option string that corresponds to the embedded
TIFF/Exif orientation tag (if present). Since 2.32, the TIFF loader sets
the "multipage" option string to "yes" when a multi-page TIFF is loaded.
Since 2.32 the JPEG and PNG loaders set "x-dpi" and "y-dpi" if the file
contains image density information in dots per inch.
Since 2.36.6, the JPEG loader sets the "comment" option with the comment
EXIF tag.

Return value: the value associated with I<key>. This is a nul-terminated
string that should not be freed or C<Any> if I<key> was not found.

  method gdk_pixbuf_get_option ( Str $key --> Str  )

=item Str $key; a nul-terminated string.

=end pod

sub gdk_pixbuf_get_option ( N-GObject $pixbuf, Str $key )
  returns Str
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_remove_option:
=begin pod
=head2 [gdk_pixbuf_] remove_option

Remove the key/value pair option attached to a B<Gnome::Gdk3::Pixbuf>.

Return value: C<1> if an option was removed, C<0> if not.

Since: 2.36

  method gdk_pixbuf_remove_option ( Str $key --> Int  )

=item Str $key; a nul-terminated string representing the key to remove.

=end pod

sub gdk_pixbuf_remove_option ( N-GObject $pixbuf, Str $key )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_get_options:
=begin pod
=head2 [gdk_pixbuf_] get_options

Returns a B<GHashTable> with a list of all the options that may have been
attached to the I<pixbuf> when it was loaded, or that may have been
attached by another function using C<gdk_pixbuf_set_option()>.

See C<gdk_pixbuf_get_option()> for more details.

Return value: (transfer container) (element-type utf8 utf8): a B<GHashTable> of key/values

Since: 2.32

  method gdk_pixbuf_get_options ( --> GHashTable  )


=end pod

sub gdk_pixbuf_get_options ( N-GObject $pixbuf )
  returns GHashTable
  is native(&gdk-pixbuf-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_pixbuf_copy_options:
=begin pod
=head2 [gdk_pixbuf_] copy_options

Copy the key/value pair options attached to a B<Gnome::Gdk3::Pixbuf> to another.
This is useful to keep original metadata after having manipulated
a file. However be careful to remove metadata which you've already
applied, such as the "orientation" option after rotating the image.

Return value: C<1> on success.

Since: 2.36

  method gdk_pixbuf_copy_options ( N-GObject $dest_pixbuf --> Int  )

=item N-GObject $dest_pixbuf; the B<Gnome::Gdk3::Pixbuf> to copy options to

=end pod

sub gdk_pixbuf_copy_options ( N-GObject $src_pixbuf, N-GObject $dest_pixbuf )
  returns int32
  is native(&gdk-pixbuf-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:n-channels:
=head3 _(Number of Channels


The number of samples per pixel.
Currently, only 3 or 4 samples per pixel are supported.

The B<Gnome::GObject::Value> type of property I<n-channels> is C<G_TYPE_INT>.

=comment #TP:0:colorspace:
=head3 _(Colorspace

_(The colorspace in which the samples are interpreted
Default value: False


The B<Gnome::GObject::Value> type of property I<colorspace> is C<G_TYPE_ENUM>.

=comment #TP:0:has-alpha:
=head3 _(Has Alpha

_(Whether the pixbuf has an alpha channel
Default value: False


The B<Gnome::GObject::Value> type of property I<has-alpha> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:bits-per-sample:
=head3 _(Bits per Sample


The number of bits per sample.
Currently only 8 bit per sample are supported.

The B<Gnome::GObject::Value> type of property I<bits-per-sample> is C<G_TYPE_INT>.

=comment #TP:0:width:
=head3 _(Width



The B<Gnome::GObject::Value> type of property I<width> is C<G_TYPE_INT>.

=comment #TP:0:height:
=head3 _(Height



The B<Gnome::GObject::Value> type of property I<height> is C<G_TYPE_INT>.

=comment #TP:0:rowstride:
=head3 _(Rowstride


The number of bytes between the start of a row and
the start of the next row. This number must (obviously)
be at least as large as the width of the pixbuf.

The B<Gnome::GObject::Value> type of property I<rowstride> is C<G_TYPE_INT>.

=comment #TP:0:pixels:
=head3 _(Pixels



The B<Gnome::GObject::Value> type of property I<pixels> is C<G_TYPE_POINTER>.

=comment #TP:0:pixel-bytes:
=head3 _(Pixel Bytes



The B<Gnome::GObject::Value> type of property I<pixel-bytes> is C<G_TYPE_BOXED>.
=end pod
