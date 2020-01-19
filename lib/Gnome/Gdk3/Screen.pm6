#TL:1:Gnome::Gdk3::Screen:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Screen

Object representing a physical screen

=head1 Description


B<Gnome::Gdk3::Screen> objects are the GDK representation of the screen on
which windows can be displayed and on which the pointer moves.
X originally identified screens with physical screens, but
nowadays it is more common to have a single B<Gnome::Gdk3::Screen> which
combines several physical monitors (see C<gdk_screen_get_n_monitors()>).

B<Gnome::Gdk3::Screen> is used throughout GDK and GTK+ to specify which screen
the top level windows are to be displayed on. it is also used to
query the screen specification and default settings such as
the default visual (C<gdk_screen_get_system_visual()>), the dimensions
of the physical monitors (C<gdk_screen_get_monitor_geometry()>), etc.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::Screen;
  also is Gnome::GObject::Object;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Glib::List;
use Gnome::GObject::Object;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkscreen.h
# https://developer.gnome.org/gdk3/stable/GdkScreen.html
unit class Gnome::Gdk3::Screen:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new plain object with the default screen.

  multi method new ( )

Create an object using a native screen object from elsewhere.

  multi method new ( N-GObject :$screen! )

=end pod

#TM:1:new():
#TM:0:new(:screen):

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<size-changed composited-changed monitors-changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk3::Screen';

  if ? %options<default> {
    Gnome::N::deprecate( '.new(:default)', '.new()', '0.15.3', '0.18.0');
    self.set-native-object(gdk_screen_get_default());
  }

  elsif ? %options<screen> {
    self.set-native-object(%options<screen>);
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else {
    self.set-native-object(gdk_screen_get_default());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GdkScreen');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gdk_screen_$native-sub"); };
  try { $s = &::("gdk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gdk_' /;

  self.set-class-name-of-sub('GdkScreen');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_get_system_visual:
=begin pod
=head2 [[gdk_] screen_] get_system_visual

Get the system’s default visual for this screen. This is the visual for the root window of the display. The return value should not be freed.

Returns: the system visual. A native B<Gnome::Gdk3::Visual>

Since: 2.2

  method gdk_screen_get_system_visual ( --> N-GObject  )


=end pod

sub gdk_screen_get_system_visual ( N-GObject $screen )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_get_rgba_visual:
=begin pod
=head2 [[gdk_] screen_] get_rgba_visual

Gets a visual to use for creating windows with an alpha channel. The windowing system on which GTK+ is running may not support this capability, in which case C<Any> will be returned. Even if a non-C<Any> value is returned, its possible that the window’s alpha channel won’t be honored when displaying the window on the screen: in particular, for X an appropriate windowing manager and compositing manager must be running to provide appropriate display.

This functionality is not implemented in the Windows backend.

For setting an overall opacity for a top-level window, see C<gdk_window_set_opacity()>.

Returns: a visual to use for windows with an alpha channel or C<Any> if the capability is not available.

Since: 2.8

  method gdk_screen_get_rgba_visual ( --> N-GObject  )


=end pod

sub gdk_screen_get_rgba_visual ( N-GObject $screen )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_is_composited:
=begin pod
=head2 [[gdk_] screen_] is_composited

Returns whether windows with an RGBA visual can reasonably
be expected to have their alpha channel drawn correctly on
the screen.

On X11 this function returns whether a compositing manager is
compositing this screen.

Returns: Whether windows with RGBA visuals can reasonably be
expected to have their alpha channels drawn correctly on the screen.

Since: 2.10

  method gdk_screen_is_composited ( --> Int  )


=end pod

sub gdk_screen_is_composited ( N-GObject $screen )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_get_root_window:
=begin pod
=head2 [[gdk_] screen_] get_root_window

Gets the root window of this screen.

Returns: the root window, a native B<Gnome::Gdk3::Window>.

Since: 2.2

  method gdk_screen_get_root_window ( --> N-GObject  )


=end pod

sub gdk_screen_get_root_window ( N-GObject $screen )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_screen_get_display:
=begin pod
=head2 [[gdk_] screen_] get_display

Gets the display to which the I<screen> belongs.

Returns: the display to which screen belongs, a native B<Gnome::Gdk3::Display>.

Since: 2.2

  method gdk_screen_get_display ( --> N-GObject  )

=end pod

sub gdk_screen_get_display ( N-GObject $screen )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_list_visuals:
=begin pod
=head2 [[gdk_] screen_] list_visuals

Lists the available visuals for this screen. A visual describes a hardware image data format. For example, a visual might support 24-bit color, or 8-bit color, and might expect pixels to be in a certain format.

Call C<g_list_free()> on the return value when you’re finished with it.

Returns: a list of native B<Gnome::Gdk3::Visual>, the list must be freed, but not its contents.

Since: 2.2

  method gdk_screen_list_visuals ( --> N-GList )

=end pod

sub gdk_screen_list_visuals ( N-GObject $screen )
  returns N-GList
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_get_toplevel_windows:
=begin pod
=head2 [[gdk_] screen_] get_toplevel_windows

Obtains a list of all toplevel windows known to GDK on the screen screen . A toplevel window is a child of the root window (see gdk_get_default_root_window()).

The returned list should be freed with g_list_free(), but its elements need not be freed. It's a list of native B<Gnome::Gdk3::Window> elements.

  method gdk_screen_get_toplevel_windows ( --> N-GList  )

=end pod

sub gdk_screen_get_toplevel_windows ( N-GObject $screen )
  returns N-GList
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gdk_screen_get_default:new(:default)
=begin pod
=head2 [[gdk_] screen_] get_default

Gets the default screen for the default display. (See gdk_display_get_default()).

  method gdk_screen_get_default ( --> N-GObject  )

Returns a native B<Gnome::Gdk3::Screen>.

=end pod

sub gdk_screen_get_default (  )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_get_setting:
=begin pod
=head2 [[gdk_] screen_] get_setting

Retrieves a desktop-wide setting such as double-click time
for this screen.

FIXME needs a list of valid settings here, or a link to
more information.

Returns: C<1> if the setting existed and a value was stored
in I<value>, C<0> otherwise.

Since: 2.2

  method gdk_screen_get_setting ( Str $name, N-GObject $value --> Int  )

=item Str $name; the name of the setting
=item N-GObject $value; location to store the value of the setting

=end pod

sub gdk_screen_get_setting ( N-GObject $screen, Str $name, N-GObject $value )
  returns int32
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_screen_set_font_options:
=begin pod
=head2 [[gdk_] screen_] set_font_options

Sets the default font options for the screen. These
options will be set on any B<PangoContext>’s newly created
with C<gdk_pango_context_get_for_screen()>. Changing the
default set of font options does not affect contexts that
have already been created.

Since: 2.10

  method gdk_screen_set_font_options ( cairo_font_options_t $options )

=item cairo_font_options_t $options; (allow-none): a B<cairo_font_options_t>, or C<Any> to unset any previously set default font options.

=end pod

sub gdk_screen_set_font_options ( N-GObject $screen, cairo_font_options_t $options )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_get_font_options:
=begin pod
=head2 [[gdk_] screen_] get_font_options

Gets any options previously set with C<gdk_screen_set_font_options()>.

Returns: (nullable): the current font options, or C<Any> if no
default font options have been set.

Since: 2.10

  method gdk_screen_get_font_options ( --> cairo_font_options_t  )


=end pod

sub gdk_screen_get_font_options ( N-GObject $screen )
  returns cairo_font_options_t
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_set_resolution:
=begin pod
=head2 [[gdk_] screen_] set_resolution

Since: 2.10

  method gdk_screen_set_resolution ( Num $dpi )

=item Num $dpi; the resolution in “dots per inch”. (Physical inches aren’t actually involved; the terminology is conventional.) Sets the resolution for font handling on the screen. This is a scale factor between points specified in a B<PangoFontDescription> and cairo units. The default value is 96, meaning that a 10 point font will be 13 units high. (10 * 96. / 72. = 13.3).

=end pod

sub gdk_screen_set_resolution ( N-GObject $screen, num64 $dpi )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_get_resolution:
=begin pod
=head2 [[gdk_] screen_] get_resolution

Gets the resolution for font handling on the screen; see
C<gdk_screen_set_resolution()> for full details.

Returns: the current resolution, or -1 if no resolution
has been set.

Since: 2.10

  method gdk_screen_get_resolution ( --> Num  )


=end pod

sub gdk_screen_get_resolution ( N-GObject $screen )
  returns num64
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_screen_get_window_stack:
=begin pod
=head2 [[gdk_] screen_] get_window_stack

Returns a B<GList> of B<Gnome::Gdk3::Windows> representing the current
window stack.

On X11, this is done by inspecting the _NET_CLIENT_LIST_STACKING
property on the root window, as described in the
[Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec).
If the window manager does not support the
_NET_CLIENT_LIST_STACKING hint, this function returns C<Any>.

On other platforms, this function may return C<Any>, depending on whether
it is implementable on that platform.

The returned list is newly allocated and owns references to the
windows it contains, so it should be freed using C<g_list_free()> and
its windows unrefed using C<g_object_unref()> when no longer needed.

Returns: (nullable) (transfer full) (element-type B<Gnome::Gdk3::Window>): a
list of B<Gnome::Gdk3::Windows> for the current window stack, or C<Any>.

Since: 2.10

  method gdk_screen_get_window_stack ( --> N-GList  )


=end pod

sub gdk_screen_get_window_stack ( N-GObject $screen )
  returns N-GList
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:0:size-changed:
=head3 size-changed

The I<size-changed> signal is emitted when the pixel width or
height of a screen changes.

Since: 2.2

  method handler (
    Gnome::GObject::Object :widget($screen),
    *%user-options
  );

=item $screen; the object on which the signal is emitted


=comment #TS:0:composited-changed:
=head3 composited-changed

The I<composited-changed> signal is emitted when the composited
status of the screen changes

Since: 2.10

  method handler (
    Gnome::GObject::Object :widget($screen),
    *%user-options
  );

=item $screen; the object on which the signal is emitted


=comment #TS:0:monitors-changed:
=head3 monitors-changed

The I<monitors-changed> signal is emitted when the number, size
or position of the monitors attached to the screen change.

Only for X11 and OS X for now. A future implementation for Win32
may be a possibility.

Since: 2.14

  method handler (
    Gnome::GObject::Object :widget($screen),
    *%user-options
  );

=item $screen; the object on which the signal is emitted


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=begin comment
=comment #TP:0:font-options:
=head3 Font options

The B<Gnome::GObject::Value> type of property I<font-options> is C<G_TYPE_POINTER>.
=end comment


=comment #TP:0:resolution:
=head3 Font resolution

The B<Gnome::GObject::Value> type of property I<resolution> is C<G_TYPE_DOUBLE>.
=end pod























=finish
#-------------------------------------------------------------------------------
sub gdk_screen_get_default ( )
  returns N-GObject         # GdkScreen
  is native(&gdk-lib)
  { * }

sub gdk_screen_get_display ( N-GObject $screen )
  returns N-GObject         # GdkDisplay
  is native(&gdk-lib)
  { * }
