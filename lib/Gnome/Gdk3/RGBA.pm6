use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gdk3::Rgba

=SUBTITLE RGBA colors

=head1 Description

C<Gnome::Gdk3::RGBA> is a convenient way to pass rgba colors around.
It’s based on cairo’s way to deal with colors and mirrors its behavior.
All values are in the range from 0.0 to 1.0 inclusive. So the color
(0.0, 0.0, 0.0, 0.0) represents transparent black and
(1.0, 1.0, 1.0, 1.0) is opaque white. Other values will be clamped
to this range when drawing.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::RGBA;

=head2 Example

  my GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );

=end pod
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
#use Gnome::GObject::Object;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkrgba.h
unit class Gnome::Gdk3::RGBA:auth<github:MARTIMM>;
#-------------------------------------------------------------------------------
#`{{
=begin pod
=head2 GdkRGBA

GdkRGBA is a convenient way to pass rgba colors around. It’s based on cairo’s way to deal with colors and mirrors its behavior. All values are in the range from 0.0 to 1.0 inclusive. So the color (0.0, 0.0, 0.0, 0.0) represents transparent black and (1.0, 1.0, 1.0, 1.0) is opaque white. Other values will be clamped to this range when drawing.

=item $.red; The intensity of the red channel from 0.0 to 1.0 inclusive
=item $.green; The intensity of the green channel from 0.0 to 1.0 inclusive
=item $.blue; The intensity of the blue channel from 0.0 to 1.0 inclusive
=item $.alpha; The opacity of the color from 0.0 for completely translucent to 1.0 for opaque

=end pod
}}
class GdkRGBA is repr('CStruct') is export {
  HAS num64 $.red;
  HAS num64 $.green;
  HAS num64 $.blue;
  HAS num64 $.alpha;
}

#`[[[
#-------------------------------------------------------------------------------
my Bool $signals-added = False;
my GdkRGBA $n-rgba;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

...
  multi method new ( Bool :$empty! )

Create a new object.

  multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    ... :type<signame>
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk3::Rgba';

  # process all named arguments
  if ? %options<empty> {
    self.native-gobject(gtk__new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::GTK::V3.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.

#`{{
=begin pod
=head2 CALL-ME

  method CALL-ME ( N-GObject $widget? --> N-GObject )

This method is designed to set and retrieve the gtk object from a perl6 widget object. This is indirectly called by C<new> when the :widget option is used. On many occasions this is done automatically or indirect like explained above, that it is hardly used by the user directly.

  # Example only to show how things can be tranported between objects. Not
  # something you need to remember!
  my N-GObject $button = Gnome::Gtk3::Button.new(:label('Exit'))();
  my Gnome::Gtk3::Button $b .= new(:empty);
  $b($button);

See also L<native-gobject>.
=end pod
}}
#TODO destroy when overwritten? g_object_unref?
method CALL-ME ( N-GObject $widget? --> N-GObject ) {

  if ?$widget {
    # if native object exists it will be overwritten. unref object first.
    if ?$!g-object {
      #TODO self.g_object_unref();
    }
    $!g-object = $widget;
    #TODO self.g_object_ref();
  }

  $!g-object
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
#
# Fallback method to find the native subs which then can be called as if it
# were a method. Each class must provide their own 'fallback' method which,
# when nothing found, must call the parents fallback with 'callsame'.
# The subs in some class all start with some prefix which can be left out too
# provided that the fallback functions must also test with an added prefix.
# So e.g. a sub 'gtk_label_get_text' defined in class GtlLabel can be called
# like '$label.gtk_label_get_text()' or '$label.get_text()'. As an extra
# feature dashes can be used instead of underscores, so '$label.get-text()'
# works too.
method FALLBACK ( $native-sub is copy, |c ) {

  CATCH { test-catch-exception( $_, $native-sub); }

  # convert all dashes to underscores if there are any. then check if
  # name is not too short.
  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-').defined;
#`{{
  die X::Gnome.new(:message(
      "Native sub name '$native-sub' made too short." ~
      " Keep at least one '-' or '_'."
    )
  ) unless $native-sub.index('_') // -1 >= 0;
}}

  # check if there are underscores in the name. then the name is not too short.
  my Callable $s;

  # call the fallback functions of this classes children starting
  # at the bottom
  $s = self.fallback($native-sub);

  die X::Gnome.new(:message("Native sub '$native-sub' not found"))
      unless $s.defined;

  # User convenience substitutions to get a native object instead of
  # a GtkSomeThing or GlibSomeThing object
  my Array $params = [];
  for c.list -> $p {
    if $p.^name ~~ m/^ 'Gnome::' [ Gtk3 || Gdk3 || Glib || GObject ] '::' / {
      $params.push($p());
    }

    else {
      $params.push($p);
    }
  }

  test-call( $s, $!g-object, |$params)
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gdk_rgba_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
=begin pod
=head2 gdk_rgba_copy

Makes a copy of a C<Gnome::Gdk3::RGBA>. The result must be freed through gdk_rgba_free().

  method gdk_rgba_copy ( N-GObject $rgba --> N-GObject )

=item GdkRGBA $rgba;  a C<Gnome::Gdk3::RGBA>

Returns N-GObject; A newly allocated C<Gnome::Gdk3::RGBA>, with the same contents as @rgba
=end pod

sub gdk_rgba_copy (  N-GObject $rgba )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gdk_rgba_free


Frees a C<Gnome::Gdk3::RGBA> created with gdk_rgba_copy()



  method gdk_rgba_free ( N-GObject $rgba)

=item N-GObject $rgba;  a C<Gnome::Gdk3::RGBA>

=end pod

sub gdk_rgba_free (  N-GObject $rgba )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gdk_rgba_hash


A hash function suitable for using for a hash
table that stores C<Gnome::Gdk3::RGBAs>.




  method gdk_rgba_hash ( gpointer $p --> UInt )

=item gpointer $p;  (type C<Gnome::Gdk3::RGBA>): a C<Gnome::Gdk3::RGBA> pointer

Returns uint32; The hash value for @p
=end pod

sub gdk_rgba_hash (  gpointer $p )
  returns uint32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gdk_rgba_equal


Compares two RGBA colors.




  method gdk_rgba_equal ( gpointer $p1, gpointer $p2 --> Int )

=item gpointer $p1;  (type C<Gnome::Gdk3::RGBA>): a C<Gnome::Gdk3::RGBA> pointer
=item gpointer $p2;  (type C<Gnome::Gdk3::RGBA>): another C<Gnome::Gdk3::RGBA> pointer

Returns int32; 1 if the two colors compare equal
=end pod

sub gdk_rgba_equal (  gpointer $p1,  gpointer $p2 )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gdk_rgba_parse


Parses a textual representation of a color, filling in
the @red, @green, @blue and @alpha fields of the @rgba C<Gnome::Gdk3::RGBA>.

The string can be either one of:
- A standard name (Taken from the X11 rgb.txt file).
- A hexadecimal value in the form “\C<rgb>”, “\C<rrggbb>”,
  “\C<rrrgggbbb>” or ”\C<rrrrggggbbbb>”
- A RGB color in the form “rgb(r,g,b)” (In this case the color will
  have full opacity)
- A RGBA color in the form “rgba(r,g,b,a)”

Where “r”, “g”, “b” and “a” are respectively the red, green, blue and
alpha color values. In the last two cases, r g and b are either integers
in the range 0 to 255 or precentage values in the range 0% to 100%, and
a is a floating point value in the range 0 to 1.




  method gdk_rgba_parse ( N-GObject $rgba, Str $spec --> Int )

=item N-GObject $rgba;  the C<Gnome::Gdk3::RGBA> to fill in
=item Str $spec;  the string specifying the color

Returns int32; 1 if the parsing succeeded
=end pod

sub gdk_rgba_parse (  N-GObject $rgba,  str $spec )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gdk_rgba_] to_string


Returns a textual specification of @rgba in the form
`rgb (r, g, b)` or
`rgba (r, g, b, a)`,
where “r”, “g”, “b” and “a” represent the red, green,
blue and alpha values respectively. r, g, and b are
represented as integers in the range 0 to 255, and a
is represented as floating point value in the range 0 to 1.

These string forms are string forms those supported by
the CSS3 colors module, and can be parsed by gdk_rgba_parse().

Note that this string representation may lose some
precision, since r, g and b are represented as 8-bit
integers. If this is a concern, you should use a
different representation.




  method gdk_rgba_to_string ( N-GObject $rgba --> Str )

=item N-GObject $rgba;  a C<Gnome::Gdk3::RGBA>

Returns str; A newly allocated text string
=end pod

sub gdk_rgba_to_string (  N-GObject $rgba )
  returns str
  is native(&gdk-lib)
  { * }


#-------------------------------------------------------------------------------
=end pod


#`{{
#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2

=item

=end pod
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also C<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., $user-optionN
  )

=begin comment

=head2 Supported signals

=head2 Unsupported signals

=end comment


=head2 Not yet supported signals




=begin comment

=head4 Signal Handler Signature

  method handler (
    Gnome::GObject::Object :$widget, :$user-option1, ..., $user-optionN
  )

=head4 Event Handler Signature

  method handler (
    Gnome::GObject::Object :$widget, GdkEvent :$event,
    :$user-option1, ..., $user-optionN
  )

=head4 Native Object Handler Signature

  method handler (
    Gnome::GObject::Object :$widget, N-GObject :$nativewidget,
    :$user-option1, ..., :$user-optionN
  )

=end comment


=begin comment

=head4 Handler Method Arguments
=item $widget; This can be any perl6 widget with C<Gnome::GObject::Object> as the top parent class e.g. C<Gnome::Gtk3::Button>.
=item $event; A structure defined in C<Gnome::Gdk3::EventTypes>.
=item $nativewidget; A native widget (a C<N-GObject>) which can be turned into a perl6 widget using C<.new(:widget())> on the appropriate class.
=item $user-option*; Any extra options given by the user when registering the signal.

=end comment

=end pod
]]]
