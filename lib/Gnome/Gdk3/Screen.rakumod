#TL:1:Gnome::Gdk3::Screen:

use v6.d;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Screen

Object representing a physical screen

=head1 Description

B<Gnome::Gdk3::Screen> objects are the GDK representation of the screen on which windows can be displayed and on which the pointer moves. X originally identified screens with physical screens, but nowadays it is more common to have a single B<Gnome::Gdk3::Screen> which combines several physical monitors (see C<gdk_screen_get_n_monitors()>).

B<Gnome::Gdk3::Screen> is used throughout GDK and GTK+ to specify which screen the top level windows are to be displayed on. it is also used to query the screen specification and default settings such as the default visual (C<gdk_screen_get_system_visual()>), the dimensions of the physical monitors (C<gdk_screen_get_monitor_geometry()>), etc.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::Screen;
  also is Gnome::GObject::Object;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Glib::List:api<1>;

use Gnome::GObject::Object:api<1>;

use Gnome::Cairo;
use Gnome::Cairo::Types:api<1>;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkscreen.h
# https://developer.gnome.org/gdk3/stable/GdkScreen.html
unit class Gnome::Gdk3::Screen:auth<github:MARTIMM>:api<1>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new plain object with the default screen.

  multi method new ( )


=head3 :native-object

Create an object using a native screen object from elsewhere.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:1:new():
#TM:4:new(:native-object):TopLevelClassSupport

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<size-changed composited-changed monitors-changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  if self.^name eq 'Gnome::Gdk3::Screen' #`{{or %options<GdkScreen>}} {
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;

      if %options.keys.elems {
        die X::Gnome.new(
          :message('Unsupported options for ' ~ self.^name ~
                   ': ' ~ %options.keys.join(', ')
                  )
        );
      }

      else {
        $no = _gdk_screen_get_default();
      }

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GdkScreen');
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gdk_screen_$native-sub"); };
  try { $s = &::("gdk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gdk_' /;

  self._set-class-name-of-sub('GdkScreen');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:1:get-display:
=begin pod
=head2 get-display

Gets the display to which the I<screen> belongs.

Returns: the display to which I<screen> belongs

  method get-display ( --> N-GObject )

=end pod

# Used Any to prevent loading and circular dependencies
method get-display-rk ( --> Any ) {
  Gnome::N::deprecate(
    'get-display-rk', 'coercing from get-display',
    '0.19.2', '0.21.0'
  );

  self._wrap-native-type(
    'Gnome::Gdk3::Display',
    gdk_screen_get_display(self._get-native-object-no-reffing)
  )
}

method get-display ( --> N-GObject ) {
  gdk_screen_get_display(self._get-native-object-no-reffing)
}

sub gdk_screen_get_display (
  N-GObject $screen --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-font-options:
=begin pod
=head2 get-font-options

Gets any options previously set with C<set-font-options()>.

Returns: the current font options, or C<undefined> if no default font options have been set.

  method get-font-options ( --> cairo_font_options_t )

=end pod

method get-font-options ( --> cairo_font_options_t ) {
  gdk_screen_get_font_options(self._get-native-object-no-reffing)
}

sub gdk_screen_get_font_options (
  N-GObject $screen --> cairo_font_options_t
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-resolution:
=begin pod
=head2 get-resolution

Gets the resolution for font handling on the screen; see C<set-resolution()> for full details.

Returns: the current resolution, or -1 if no resolution has been set.

  method get-resolution ( --> Num )

=end pod

method get-resolution ( --> Num ) {
  gdk_screen_get_resolution(self._get-native-object-no-reffing)
}

sub gdk_screen_get_resolution (
  N-GObject $screen --> gdouble
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-rgba-visual:
=begin pod
=head2 get-rgba-visual

Gets a visual to use for creating windows with an alpha channel. The windowing system on which GTK+ is running may not support this capability, in which case C<undefined> will be returned. Even if a non-C<undefined> value is returned, its possible that the window’s alpha channel won’t be honored when displaying the window on the screen: in particular, for X an appropriate windowing manager and compositing manager must be running to provide appropriate display.

This functionality is not implemented in the Windows backend.

For setting an overall opacity for a top-level window, see C<gdk-window-set-opacity()>.

Returns: a visual to use for windows with an alpha channel or C<undefined> if the capability is not available.

  method get-rgba-visual ( --> N-GObject )

=end pod

method get-rgba-visual-rk ( --> Any ) {
  Gnome::N::deprecate(
    'get-rgba-visual-rk', 'coercing from get-rgba-visual',
    '0.19.2', '0.21.0'
  );

  self._wrap-native-type(
    'Gnome::Gdk3::Visual',
    gdk_screen_get_rgba_visual(self._get-native-object-no-reffing)
  )
}

method get-rgba-visual ( --> N-GObject ) {
  gdk_screen_get_rgba_visual(self._get-native-object-no-reffing)
}

sub gdk_screen_get_rgba_visual (
  N-GObject $screen --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-root-window:
=begin pod
=head2 get-root-window

Gets the root window of I<screen>.

Returns: the root window

  method get-root-window ( --> N-GObject )

=end pod

method get-root-window-rk ( --> Any ) {
  Gnome::N::deprecate(
    'get-root-window-rk', 'coercing from get-root-window',
    '0.19.2', '0.21.0'
  );

  self._wrap-native-type(
    'Gnome::Gdk3::Window',
    gdk_screen_get_root_window(self._get-native-object-no-reffing)
  )
}

method get-root-window ( --> N-GObject ) {
  gdk_screen_get_root_window(self._get-native-object-no-reffing)
}

sub gdk_screen_get_root_window (
  N-GObject $screen --> N-GObject
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-setting:
=begin pod
=head2 get-setting

Retrieves a desktop-wide setting such as double-click time for the B<Gnome::Gdk3::Screen> I<screen>.

FIXME needs a list of valid settings here, or a link to more information.

Returns: C<True> if the setting existed and a value was stored in I<value>, C<False> otherwise.

  method get-setting ( Str $name, N-GObject() $value --> Bool )

=item Str $name; the name of the setting
=item N-GObject $value; location to store the value of the setting
=end pod

method get-setting ( Str $name, N-GObject() $value --> Bool ) {
  gdk_screen_get_setting(
    self._get-native-object-no-reffing, $name, $value
  ).Bool
}

sub gdk_screen_get_setting (
  N-GObject $screen, gchar-ptr $name, N-GObject $value --> gboolean
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:get-system-visual:
=begin pod
=head2 get-system-visual

Get the system’s default visual for I<screen>. This is the visual for the root window of the display. The return value should not be freed.

Returns: the system visual

  method get-system-visual ( --> N-GObject )

=end pod

method get-system-visual-rk ( --> Any ) {
  Gnome::N::deprecate(
    'get-system-visual-rk', 'coercing from get-system-visual',
    '0.19.2', '0.21.0'
  );

  self._wrap-native-type(
    'Gnome::Gdk3::Visual',
    gdk_screen_get_system_visual(self._get-native-object-no-reffing)
  )
}

method get-system-visual ( --> N-GObject ) {
  gdk_screen_get_system_visual(self._get-native-object-no-reffing)
}

sub gdk_screen_get_system_visual (
  N-GObject $screen --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-toplevel-windows:
=begin pod
=head2 get-toplevel-windows, get-toplevel-windows-rk

  method get-toplevel-windows-rk ( --> Gnome::Glib::List )
  method get-toplevel-windows ( --> N-GList )

=end pod

method get-toplevel-windows-rk ( --> Gnome::Glib::List ) {
  Gnome::Glib::List.new(
    :native-object(
      gdk_screen_get_toplevel_windows(self._get-native-object-no-reffing)
    )
  )
}

method get-toplevel-windows ( --> N-GList ) {
  gdk_screen_get_toplevel_windows(self._get-native-object-no-reffing)
}

sub gdk_screen_get_toplevel_windows (
  N-GObject $screen --> N-GList
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-window-stack:
=begin pod
=head2 get-window-stack, get-window-stack-rk

Returns a B<Gnome::Gdk3::List> of B<Gnome::Gdk3::Windows> representing the current window stack.

On X11, this is done by inspecting the -NET-CLIENT-LIST-STACKING property on the root window, as described in the [Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec). If the window manager does not support the -NET-CLIENT-LIST-STACKING hint, this function returns C<undefined>.

On other platforms, this function may return C<undefined>, depending on whether it is implementable on that platform.

The returned list is newly allocated and owns references to the windows it contains, so it should be freed using C<g-list-free()> and its windows unrefed using C<g-object-unref()> when no longer needed.

Returns:   (element-type GdkWindow): a list of B<Gnome::Gdk3::Windows> for the current window stack, or C<undefined>.

  method get-window-stack-rk ( --> Gnome::Glib::List )
  method get-window-stack ( --> N-GList )

=end pod

method get-window-stack-rk ( --> Gnome::Glib::List ) {
  Gnome::Glib::List.new(
    :native-object(
      gdk_screen_get_window_stack(self._get-native-object-no-reffing)
    )
  )
}

method get-window-stack ( --> N-GList ) {
  gdk_screen_get_window_stack(self._get-native-object-no-reffing)
}

sub gdk_screen_get_window_stack (
  N-GObject $screen --> N-GList
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:is-composited:
=begin pod
=head2 is-composited

Returns whether windows with an RGBA visual can reasonably be expected to have their alpha channel drawn correctly on the screen.

On X11 this function returns whether a compositing manager is compositing I<screen>.

Returns: Whether windows with RGBA visuals can reasonably be expected to have their alpha channels drawn correctly on the screen.

  method is-composited ( --> Bool )

=end pod

method is-composited ( --> Bool ) {
  gdk_screen_is_composited(self._get-native-object-no-reffing).Bool
}

sub gdk_screen_is_composited (
  N-GObject $screen --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:list-visuals:
=begin pod
=head2 list-visuals, list-visuals-rk

Lists the available visuals for the specified I<screen>. A visual describes a hardware image data format. For example, a visual might support 24-bit color, or 8-bit color, and might expect pixels to be in a certain format.

Call C<g-list-free()> on the return value when you’re finished with it.

Returns: (transfer container) (element-type GdkVisual): a list of visuals; the list must be freed, but not its contents

  method list-visuals-rk ( --> Gnome::Glib::List )
  method list-visuals ( --> N-GList )

=end pod

method list-visuals-rk ( --> Gnome::Glib::List ) {
  Gnome::Glib::List.new(
    :native-object(
      gdk_screen_list_visuals(self._get-native-object-no-reffing)
    )
  )
}

method list-visuals ( --> N-GList ) {
  gdk_screen_list_visuals(self._get-native-object-no-reffing)
}

sub gdk_screen_list_visuals (
  N-GObject $screen --> N-GList
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-font-options:
=begin pod
=head2 set-font-options

Sets the default font options for the screen. These options will be set on any B<PangoContext>’s newly created with C<gdk-pango-context-get-for-screen()>. Changing the default set of font options does not affect contexts that have already been created.

  method set-font-options ( cairo_font_options_t $options )

=item cairo_font_options_t $options; a B<cairo-font-options-t>, or C<undefined> to unset any previously set default font options.
=end pod

method set-font-options ( cairo_font_options_t $options ) {

  gdk_screen_set_font_options(
    self._get-native-object-no-reffing, $options
  );
}

sub gdk_screen_set_font_options (
  N-GObject $screen, cairo_font_options_t $options
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:set-resolution:
=begin pod
=head2 set-resolution

  method set-resolution ( Num() $dpi )

=item Num $dpi; the resolution in “dots per inch”. (Physical inches aren’t actually involved; the terminology is conventional.)

Sets the resolution for font handling on the screen. This is a scale factor between points specified in a B<PangoFontDescription> and cairo units. The default value is 96, meaning that a 10 point font will be 13 units high. (10 * 96. / 72. = 13.3).
=end pod

method set-resolution ( Num() $dpi ) {
  gdk_screen_set_resolution(self._get-native-object-no-reffing, $dpi.Num);
}

sub gdk_screen_set_resolution (
  N-GObject $screen, gdouble $dpi
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gdk_screen_get_default:new(:default)
#`{{
=begin pod
=head2 [[gdk_] screen_] get_default

Gets the default screen for the default display. (See gdk_display_get_default()).

  method gdk_screen_get_default ( --> N-GObject  )

Returns a native B<Gnome::Gdk3::Screen>.

=end pod
}}
sub _gdk_screen_get_default ( --> N-GObject )
  is native(&gdk-lib)
  is symbol('gdk_screen_get_default')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<connect-object()> directly from B<Gnome::GObject::Signal>.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<connect-object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment -----------------------------------------------------------------------
=comment #TS:0:composited-changed:
=head3 composited-changed

The I<composited-changed> signal is emitted when the composited
status of the screen changes


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($screen),
    *%user-options
  );

=item $screen; the object on which the signal is emitted


=comment -----------------------------------------------------------------------
=comment #TS:0:monitors-changed:
=head3 monitors-changed

The I<monitors-changed> signal is emitted when the number, size
or position of the monitors attached to the screen change.

Only for X11 and OS X for now. A future implementation for Win32
may be a possibility.


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($screen),
    *%user-options
  );

=item $screen; the object on which the signal is emitted


=comment -----------------------------------------------------------------------
=comment #TS:0:size-changed:
=head3 size-changed

The I<size-changed> signal is emitted when the pixel width or
height of a screen changes.


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($screen),
    *%user-options
  );

=item $screen; the object on which the signal is emitted


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:0:font-options:
=head3 Font options: font-options


The B<Gnome::GObject::Value> type of property I<font-options> is C<G_TYPE_POINTER>.

=comment -----------------------------------------------------------------------
=comment #TP:1:resolution:
=head3 Font resolution: resolution


The B<Gnome::GObject::Value> type of property I<resolution> is C<G_TYPE_DOUBLE>.
=end pod
