#TL:1:Gnome::Gdk3::Atom:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Atom

Functions to manipulate properties on windows

=comment ![](images/X.png)

=head1 Description

Each window under X can have any number of associated “properties” attached to it. Properties are arbitrary chunks of data identified by “atom”s. (An “atom” is a numeric index into a string table on the X server. They are used to transfer strings efficiently between clients without having to transfer the entire string.) A property has an associated type, which is also identified using an atom.

A property has an associated “format”, an integer describing how many bits are in each unit of data inside the property. It must be 8, 16, or 32. When data is transferred between the server and client, if they are of different endianesses it will be byteswapped as necessary according to the format of the property. Note that on the client side, properties of format 32 will be stored with one unit per long, even if a long integer has more than 32 bits on the platform. (This decision was apparently made for Xlib to maintain compatibility with programs that assumed longs were 32 bits, at the expense of programs that knew better.)

The functions in this section are used to add, remove and change properties on windows, to convert atoms to and from strings and to manipulate some types of data commonly stored in X window properties.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::Atom;
  also is Gnome::N::TopLevelClassSupport;

=comment head2 Uml Diagram

=comment ![](plantuml/.svg)


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::N::TopLevelClassSupport;

#-------------------------------------------------------------------------------
unit class Gnome::Gdk3::Atom:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::N::TopLevelClassSupport;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkPropMode

Describes how existing data is combined with new data when using C<gdk-property-change()>.

=item GDK-PROP-MODE-REPLACE: the new data replaces the existing data.
=item GDK-PROP-MODE-PREPEND: the new data is prepended to the existing data.
=item GDK-PROP-MODE-APPEND: the new data is appended to the existing data.

=end pod

#TE:0:GdkPropMode:
enum GdkPropMode is export (
  'GDK_PROP_MODE_REPLACE',
  'GDK_PROP_MODE_PREPEND',
  'GDK_PROP_MODE_APPEND'
);

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 new

=head3 :intern

Finds or creates an atom corresponding to a given string.

  multi method new ( Str :$intern! )

=item Str $intern; a string, the name of the atom.

=begin comment
=item Bool $only_if_exists; if C<True>, GDK is allowed to not create a new atom, but just return C<GDK-NONE> if the requested atom doesn’t already exists. Currently, the flag is ignored, since checking the existance of an atom is as expensive as creating it.
=end comment

=head3 :native-object

Create a Drag object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:0:new(:intern)
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gdk3::Atom' #`{{ or %options<N-GObject> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<intern> {
        $no = _gdk_atom_intern( %options<intern>, False);
      }

      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }

      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GdkAtom');
  }
}

#-------------------------------------------------------------------------------
method native-object-ref ( $n-native-object ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
#TM:1:property-change:
=begin pod
=head2 property-change

Changes the contents of a property on a window.

  method property-change (
    N-GObject $window, N-GObject $property, N-GObject $type,
    Int() $format where * ~~ any( 8, 16, 32),
    GdkPropMode $mode, Str $data
  )

=item N-GObject $window; A Gnome::Gdk3::Window
=item N-GObject $property; A Gnome::Gdk3::Atom, the property to change
=item N-GObject $type; A Gnome::Gdk3::Atom, the new type for the property. If mode is GDK_PROP_MODE_PREPEND or GDK_PROP_MODE_APPEND, then this must match the existing type or an error will occur.
=item Int() $format; the new format for the property. If mode is GDK_PROP_MODE_PREPEND or GDK_PROP_MODE_APPEND, then this must match the existing format or an error will occur.
=item GdkPropMode $mode; a value describing how the new data is to be combined with the current data.
=item Str $data; the data.
=comment item Int() $nelements; the number of elements of size determined by the format, contained in data .

=end pod

method property-change (
  $window is copy, $property is copy, $type is copy,
  Int() $format where * ~~ any( 8, 16, 32), GdkPropMode $mode,
  Str $data
) {
  $window .= _get-native-object-no-reffing unless $window ~~ N-GObject;
  $property .= _get-native-object-no-reffing unless $property ~~ N-GObject;
  $type .= _get-native-object-no-reffing unless $type ~~ N-GObject;

  my $str-item = CArray[uint8].new($data.encode);
  $str-item[$data.encode.elems] = 0;
  my $length = 0;
  while $str-item[$length++] { };

  gdk_property_change(
    $window, $property, $type, $format, $mode, $str-item, $length
  );
}

sub gdk_property_change (
  N-GObject $window, N-GObject $property, N-GObject $type, gint $format, GEnum $mode, CArray[uint8] $data, gint $nelements
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:property-delete:
=begin pod
=head2 property-delete

Deletes a property from a window.

  method property-delete ( N-GObject $window, N-GObject $property )

=item N-GObject $window; A Gnome::Gdk3::Window
=item N-GObject $property; A Gnome::Gdk3::Atom, the property to delete
=end pod

method property-delete ( $window is copy, $property is copy ) {
  $window .= _get-native-object-no-reffing unless $window ~~ N-GObject;
  $property .= _get-native-object-no-reffing unless $property ~~ N-GObject;

  gdk_property_delete( $window, $property);
}

sub gdk_property_delete (
  N-GObject $window, N-GObject $property
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:property-get:
=begin pod
=head2 property-get

  method property-get (
    N-GObject $window, N-GObject $property, N-GObject $type,
    UInt $offset, UInt $length, Bool $pdelete = False,
    --> List
  )

=item N-GObject $window; A Gnome::Gdk3::Window
=item N-GObject $property; A Gnome::Gdk3::Atom, the property to retrieve
=item N-GObject $type; A Gnome::Gdk3::Atom, the desired property type, or GDK_NONE, if any type of data is acceptable. If this does not match the actual type, then actual_format and actual_length will be filled in, a warning will be printed to stderr and no data will be returned.
=item UInt $offset; the offset into the property at which to begin retrieving data, in 4 byte units.
=item UInt $length; the length of the data to retrieve in bytes. Data is considered to be retrieved in 4 byte chunks, so length will be rounded up to the next highest 4 byte boundary (so be careful not to pass a value that might overflow when rounded up).
=item Bool $pdelete; if TRUE, delete the property after retrieving the data.

Returned List holds
=item Bool result; TRUE if data was successfully received and stored in data, otherwise FALSE.
=item N-GObject $actual_property_type; actual type
=item Int $actual_format; the actual format of the data; either 8, 16 or 32 bits
=item Int $actual_length; Data returned in the 32 bit format is stored in a long variable, so the actual number of 32 bit elements should be be calculated via actual_length / sizeof(glong) to ensure portability to 64 bit systems.
=item Str $data;
=end pod

method property-get (
  $window is copy, $property is copy, $type is copy, UInt $offset,
  UInt $length, Bool $pdelete = False
  --> List
) {
  $window .= _get-native-object-no-reffing unless $window ~~ N-GObject;
  $property .= _get-native-object-no-reffing unless $property ~~ N-GObject;
  $type .= _get-native-object-no-reffing unless $type ~~ N-GObject;

  my N-GObject $apt;
  my CArray[uint8] $d;
  my gint $actual_format;
  my gint $actual_length;

  my Bool $r = gdk_property_get(
    $window, $property, $type, $offset, $length, $pdelete,
    $apt, $actual_format, $actual_length, $d
  ).Bool;

  my Buf $b .= new;
  my Int $i = 0;
  while $d[$i] {
    $b.push: $d[$i++];
  }

  ( $r, Gnome::Gdk3::Atom.new(:native-object($apt)), $actual_format,
    $actual_length, $b.decode
  )
}

sub gdk_property_get (
  N-GObject $window, N-GObject $property, N-GObject $type, gulong $offset,
  gulong $length, gint $pdelete, N-GObject $actual_property_type,
  gint $actual_format is rw, gint $actual_length is rw,
  CArray[uint8] $data
  --> gboolean
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk-text-property-to-utf8-list-for-display:
=begin pod
=head2 gdk-text-property-to-utf8-list-for-display

Converts a text property in the given encoding to a list of UTF-8 strings.

  method gdk-text-property-to-utf8-list-for-display (
    N-GObject $display, N-GObject $encoding,
    Int() $format where * ~~ any( 8, 16, 32), Str $text
    --> List
  )

=item N-GObject $display; A Gnome::Gdk3::Display
=item N-GObject $encoding; A Gnome::Gdk3::Atom, an atom representing the encoding of the text
=item Int() $format; the format of the property
=item Str $text; the text to convert.
=comment item Int() $length; the length of text in bytes

Returns a List of UTF-8 strings

=end pod

method gdk-text-property-to-utf8-list-for-display (
  $display is copy, $encoding is copy,
  Int() $format where * ~~ any( 8, 16, 32), Str $text,
#  Int() $length
  --> List
) {
  $display .= _get-native-object-no-reffing unless $display ~~ N-GObject;
  $encoding .= _get-native-object-no-reffing unless $encoding ~~ N-GObject;
  my $s = CArray[Str].new($text);

  gdk_text_property_to_utf8_list_for_display(
    $display, $encoding, $format, $text, $length, $s
  );

  $s[0]
}

sub gdk_text_property_to_utf8_list_for_display (
  N-GObject $display, N-GObject $encoding, gint $format, Str $text, gint $length, gchar-ppptr $list --> gint
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:utf8-to-string-target:
=begin pod
=head2 utf8-to-string-target

  method utf8-to-string-target ( Str $str --> Buf )

=item Str $str; a UTF-8 string
=end pod

method utf8-to-string-target ( Str $str --> Buf ) {
  my Int $i;
#`{{
  my $s = CArray[uint8].new;
  for $str.encode -> $si {
    $s[$i++] = $si;
  }
  $s[$i] = 0;
}}
  my CArray[uint8] $ca = gdk_utf8_to_string_target($str);

  $i = 0;
  my Buf $b .= new;
  while $ca[$i] {
    $b.push: $ca[$i++];
  }

  $b
}

sub gdk_utf8_to_string_target (
  gchar-ptr $str --> CArray[uint8]
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gdk_atom_intern:
#`{{
=begin pod
=head2 intern

Finds or creates an atom corresponding to a given string.

Returns: the atom corresponding to I<atom-name>.

  method intern ( Str $atom_name, Bool $only_if_exists --> N-GObject )

=item Str $atom_name; a string.
=item Bool $only_if_exists; if C<True>, GDK is allowed to not create a new atom, but just return C<GDK-NONE> if the requested atom doesn’t already exists. Currently, the flag is ignored, since checking the existance of an atom is as expensive as creating it.
=end pod

method intern ( Str $atom_name, Bool $only_if_exists --> Gnome::Gdk3::Atom ) {
  Gnome::Gdk3::Atom.new(
    :native-object(
      gdk_atom_intern( $atom_name, $only_if_exists)
    )
  )
}
}}

sub _gdk_atom_intern (
  gchar-ptr $atom_name, gboolean $only_if_exists --> N-GObject
) is native(&gdk-lib)
  is symbol('gdk_atom_intern')
  { * }

#`{{ cannot be used! GC
#-------------------------------------------------------------------------------
# TM:0:intern-static-string:
=begin pod
=head2 intern-static-string

Finds or creates an atom corresponding to a given string.

Note that this function is identical to C<intern()> except that if a new B<Gnome::Gdk3::Atom> is created the string itself is used rather than a copy. This saves memory, but can only be used if the string will always exist. It can be used with statically allocated strings in the main program, but not with statically allocated memory in dynamically loaded modules, if you expect to ever unload the module again (e.g. do not use this function in GTK+ theme engines).

Returns: the atom corresponding to I<atom-name>

  method intern-static-string ( Str $atom_name --> N-GObject )

=item Str $atom_name; a static string
=end pod

method intern-static-string ( Str $atom_name --> N-GObject ) {

  gdk_atom_intern_static_string(
    $atom_name
  )
}

sub gdk_atom_intern_static_string (
  gchar-ptr $atom_name --> N-GObject
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:name:
=begin pod
=head2 name

Determines the string corresponding to an atom.

Returns: a newly-allocated string containing the string corresponding to I<atom>.

  method name ( --> Str )

=end pod

method name ( --> Str ) {
  gdk_atom_name(self._get-native-object-no-reffing)
}

sub gdk_atom_name (
  N-GObject $atom --> gchar-ptr
) is native(&gdk-lib)
  { * }
