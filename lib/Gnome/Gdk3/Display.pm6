#TL:1:Gnome::Gdk3::Display:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Display

Controls a set of B<Gnome::Gdk3::Screens> and their associated input devices

=head1 Description


B<Gnome::Gdk3::Display> objects purpose are two fold:

=item To manage and provide information about input devices (pointers and keyboards)
=item To manage and provide information about the available B<Gnome::Gdk3::Screens>

B<Gnome::Gdk3::Display> objects are the GDK representation of an X Display,
which can be described as a workstation consisting of
a keyboard, a pointing device (such as a mouse) and one or more
screens.
It is used to open and keep track of various B<Gnome::Gdk3::Screen> objects
currently instantiated by the application. It is also used to
access the keyboard(s) and mouse pointer(s) of the display.

Most of the input device handling has been factored out into
the separate B<Gnome::Gdk3::DeviceManager> object. Every display has a
device manager, which you can obtain using
C<gdk_display_get_device_manager()>.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::Display;
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
use Gnome::Gdk3::Events;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkscreen.h
# https://developer.gnome.org/gdk3/stable/GdkDisplay.html
unit class Gnome::Gdk3::Display:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new object with the default display.

  multi method new ( )

Create a new plain object selecting a display by name.

  multi method new ( Bool :open!, Str :$display-name )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:1:new():
#TM:1:new():
#TM:1:new(:open):
#TM:0:new(:native-object):

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<opened>,
    :w1<closed seat-added seat-removed monitor-added monitor-removed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk3::Display';

  if ? %options<default> {
    Gnome::N::deprecate( '.new(:default)', '.new()', '0.15.1', '0.18.0');
    self.set-native-object(gdk_display_get_default()).defined;
  }

  elsif ? %options<open> {
    self.set-native-object(gdk_display_open(%options<display-name>));
  }

  elsif ? %options<native-object> || ? %options<widget> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # replacement for :default option
  else {
    self.set-native-object(gdk_display_get_default()).defined;
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GdkDisplay');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gdk_display_$native-sub"); };
  try { $s = &::("gdk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gdk_' /;

  self.set-class-name-of-sub('GdkDisplay');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:2:gdk_display_open:new(:open,:display-name)
=begin pod
=head2 gdk_display_open

Opens a display.

Returns: (nullable) (transfer none): a B<Gnome::Gdk3::Display>, or C<Any> if the
display could not be opened

Since: 2.2

  method gdk_display_open ( Str $display_name --> N-GObject  )

=item Str $display_name; the name of the display to open

=end pod

sub gdk_display_open ( Str $display_name )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_display_get_name:
=begin pod
=head2 [[gdk_] display_] get_name

Gets the name of the display.

Returns: a string representing the display name. This string is owned
by GDK and should not be modified or freed.

Since: 2.2

  method gdk_display_get_name ( --> Str  )


=end pod

sub gdk_display_get_name ( N-GObject $display )
  returns Str
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gdk_display_get_default_screen:new(:default)
=begin pod
=head2 [[gdk_] display_] get_default_screen

Get the default B<Gnome::Gdk3::Screen> for this display.

Since: 2.2

  method gdk_display_get_default_screen ( --> N-GObject  )


=end pod

sub gdk_display_get_default_screen ( N-GObject $display )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_device_is_grabbed:
=begin pod
=head2 [[gdk_] display_] device_is_grabbed

Returns C<1> if there is an ongoing grab on I<device> for I<display>.

Returns: C<1> if there is a grab in effect for I<device>.

  method gdk_display_device_is_grabbed ( N-GObject $device --> Int  )

=item N-GObject $device; a B<Gnome::Gdk3::Device>

=end pod

sub gdk_display_device_is_grabbed ( N-GObject $display, N-GObject $device )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_beep:
=begin pod
=head2 gdk_display_beep

Emits a short beep on I<display>

Since: 2.2

  method gdk_display_beep ( )


=end pod

sub gdk_display_beep ( N-GObject $display )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_sync:
=begin pod
=head2 gdk_display_sync

Flushes any requests queued for the windowing system and waits until all
requests have been handled. This is often used for making sure that the
display is synchronized with the current state of the program. Calling
C<gdk_display_sync()> before C<gdk_error_trap_pop()> makes sure that any errors
generated from earlier requests are handled before the error trap is
removed.

This is most useful for X11. On windowing systems where requests are
handled synchronously, this function will do nothing.

Since: 2.2

  method gdk_display_sync ( )


=end pod

sub gdk_display_sync ( N-GObject $display )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_flush:
=begin pod
=head2 gdk_display_flush

Flushes any requests queued for the windowing system; this happens automatically
when the main loop blocks waiting for new events, but if your application
is drawing without returning control to the main loop, you may need
to call this function explicitly. A common case where this function
needs to be called is when an application is executing drawing commands
from a thread other than the thread where the main loop is running.

This is most useful for X11. On windowing systems where requests are
handled synchronously, this function will do nothing.

Since: 2.4

  method gdk_display_flush ( )


=end pod

sub gdk_display_flush ( N-GObject $display )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_close:
=begin pod
=head2 gdk_display_close

Closes the connection to the windowing system for the given display,
and cleans up associated resources.

Since: 2.2

  method gdk_display_close ( )


=end pod

sub gdk_display_close ( N-GObject $display )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_display_is_closed:
=begin pod
=head2 [[gdk_] display_] is_closed

Finds out if the display has been closed.

Returns: C<1> if the display is closed.

Since: 2.22

  method gdk_display_is_closed ( --> Int  )


=end pod

sub gdk_display_is_closed ( N-GObject $display )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_event:
=begin pod
=head2 [[gdk_] display_] get_event

Gets the next B<Gnome::Gdk3::Event> to be processed for the display, fetching events from the windowing system if necessary.

Returns: (nullable): the next B<Gnome::Gdk3::Event> to be processed, or C<Any>
if no events are pending. The returned B<Gnome::Gdk3::Event> should be freed
with C<gdk_event_free()>.

Since: 2.2

  method gdk_display_get_event ( --> GdkEvent  )


=end pod

sub gdk_display_get_event ( N-GObject $display )
  returns GdkEvent
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_peek_event:
=begin pod
=head2 [[gdk_] display_] peek_event

Gets a copy of the first B<Gnome::Gdk3::Event> in the I<display>’s event queue, without
removing the event from the queue.  (Note that this function will
not get more events from the windowing system.  It only checks the events
that have already been moved to the GDK event queue.)

Returns: (nullable): a copy of the first B<Gnome::Gdk3::Event> on the event
queue, or C<Any> if no events are in the queue. The returned
B<Gnome::Gdk3::Event> should be freed with C<gdk_event_free()>.

Since: 2.2

  method gdk_display_peek_event ( --> GdkEvent  )


=end pod

sub gdk_display_peek_event ( N-GObject $display )
  returns GdkEvent
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_put_event:
=begin pod
=head2 [[gdk_] display_] put_event

Appends a copy of the given event onto the front of the event
queue for I<display>.

Since: 2.2

  method gdk_display_put_event ( GdkEvent $event )

=item GdkEvent $event; a B<Gnome::Gdk3::Event>.

=end pod

sub gdk_display_put_event ( N-GObject $display, GdkEvent $event )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_has_pending:
=begin pod
=head2 [[gdk_] display_] has_pending

Returns whether the display has events that are waiting
to be processed.

Returns: C<1> if there are events ready to be processed.

Since: 3.0

  method gdk_display_has_pending ( --> Int  )


=end pod

sub gdk_display_has_pending ( N-GObject $display )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_set_double_click_time:
=begin pod
=head2 [[gdk_] display_] set_double_click_time



  method gdk_display_set_double_click_time ( UInt $msec )

=item UInt $msec;

=end pod

sub gdk_display_set_double_click_time ( N-GObject $display, uint32 $msec )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_set_double_click_distance:
=begin pod
=head2 [[gdk_] display_] set_double_click_distance



  method gdk_display_set_double_click_distance ( UInt $distance )

=item UInt $distance;

=end pod

sub gdk_display_set_double_click_distance ( N-GObject $display, uint32 $distance )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_default:
=begin pod
=head2 [[gdk_] display_] get_default

Gets the default GdkDisplay. This is a convenience function for C<gdk_display_manager_get_default_display(gdk_display_manager_get())>.

Returns a GdkDisplay, or NULL if there is no default display.

  method gdk_display_get_default ( --> N-GObject  )


=end pod

sub gdk_display_get_default (  )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_supports_cursor_alpha:
=begin pod
=head2 [[gdk_] display_] supports_cursor_alpha

Returns C<1> if cursors can use an 8bit alpha channel
on I<display>. Otherwise, cursors are restricted to bilevel
alpha (i.e. a mask).

Returns: whether cursors can have alpha channels.

Since: 2.4

  method gdk_display_supports_cursor_alpha ( --> Int  )


=end pod

sub gdk_display_supports_cursor_alpha ( N-GObject $display )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_supports_cursor_color:
=begin pod
=head2 [[gdk_] display_] supports_cursor_color

Returns C<1> if multicolored cursors are supported
on I<display>. Otherwise, cursors have only a forground
and a background color.

Returns: whether cursors can have multiple colors.

Since: 2.4

  method gdk_display_supports_cursor_color ( --> Int  )


=end pod

sub gdk_display_supports_cursor_color ( N-GObject $display )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_default_cursor_size:
=begin pod
=head2 [[gdk_] display_] get_default_cursor_size

Returns the default size to use for cursors on I<display>.

Returns: the default cursor size.

Since: 2.4

  method gdk_display_get_default_cursor_size ( --> UInt  )


=end pod

sub gdk_display_get_default_cursor_size ( N-GObject $display )
  returns uint32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_maximal_cursor_size:
=begin pod
=head2 [[gdk_] display_] get_maximal_cursor_size

Gets the maximal size to use for cursors on I<display>.

Since: 2.4

  method gdk_display_get_maximal_cursor_size ( UInt $width, UInt $height )

=item UInt $width; (out): the return location for the maximal cursor width
=item UInt $height; (out): the return location for the maximal cursor height

=end pod

sub gdk_display_get_maximal_cursor_size ( N-GObject $display, uint32 $width, uint32 $height )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_default_group:
=begin pod
=head2 [[gdk_] display_] get_default_group

Returns the default group leader window for all toplevel windows
on I<display>. This window is implicitly created by GDK.
See C<gdk_window_set_group()>.

Returns: (transfer none): The default group leader window
for I<display>

Since: 2.4

  method gdk_display_get_default_group ( --> N-GObject  )


=end pod

sub gdk_display_get_default_group ( N-GObject $display )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_supports_selection_notification:
=begin pod
=head2 [[gdk_] display_] supports_selection_notification

Returns whether B<Gnome::Gdk3::EventOwnerChange> events will be
sent when the owner of a selection changes.

Returns: whether B<Gnome::Gdk3::EventOwnerChange> events will
be sent.

Since: 2.6

  method gdk_display_supports_selection_notification ( --> Int  )


=end pod

sub gdk_display_supports_selection_notification ( N-GObject $display )
  returns int32
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_display_request_selection_notification:
=begin pod
=head2 [[gdk_] display_] request_selection_notification

Request B<Gnome::Gdk3::EventOwnerChange> events for ownership changes
of the selection named by the given atom.

Returns: whether B<Gnome::Gdk3::EventOwnerChange> events will
be sent.

Since: 2.6

  method gdk_display_request_selection_notification ( GdkAtom $selection --> Int  )

=item GdkAtom $selection; the B<Gnome::Gdk3::Atom> naming the selection for which ownership change notification is requested

=end pod

sub gdk_display_request_selection_notification ( N-GObject $display, GdkAtom $selection )
  returns int32
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_display_supports_clipboard_persistence:
=begin pod
=head2 [[gdk_] display_] supports_clipboard_persistence

Returns whether the speicifed display supports clipboard
persistance; i.e. if it’s possible to store the clipboard data after an
application has quit. On X11 this checks if a clipboard daemon is
running.

Returns: C<1> if the display supports clipboard persistance.

Since: 2.6

  method gdk_display_supports_clipboard_persistence ( --> Int  )


=end pod

sub gdk_display_supports_clipboard_persistence ( N-GObject $display )
  returns int32
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_display_store_clipboard:
=begin pod
=head2 [[gdk_] display_] store_clipboard

Issues a request to the clipboard manager to store the
clipboard data. On X11, this is a special program that works
according to the
[FreeDesktop Clipboard Specification](http://www.freedesktop.org/Standards/clipboard-manager-spec).

Since: 2.6

  method gdk_display_store_clipboard ( N-GObject $clipboard_window, UInt $time_, GdkAtom $targets, Int $n_targets )

=item N-GObject $clipboard_window; a B<Gnome::Gdk3::Window> belonging to the clipboard owner
=item UInt $time_; a timestamp
=item GdkAtom $targets; (array length=n_targets): an array of targets that should be saved, or C<Any> if all available targets should be saved.
=item Int $n_targets; length of the I<targets> array

=end pod

sub gdk_display_store_clipboard ( N-GObject $display, N-GObject $clipboard_window, uint32 $time_, GdkAtom $targets, int32 $n_targets )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_display_supports_shapes:
=begin pod
=head2 [[gdk_] display_] supports_shapes

Returns C<1> if C<gdk_window_shape_combine_mask()> can
be used to create shaped windows on I<display>.

Returns: C<1> if shaped windows are supported

Since: 2.10

  method gdk_display_supports_shapes ( --> Int  )


=end pod

sub gdk_display_supports_shapes ( N-GObject $display )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_supports_input_shapes:
=begin pod
=head2 [[gdk_] display_] supports_input_shapes

Returns C<1> if C<gdk_window_input_shape_combine_mask()> can
be used to modify the input shape of windows on I<display>.

Returns: C<1> if windows with modified input shape are supported

Since: 2.10

  method gdk_display_supports_input_shapes ( --> Int  )


=end pod

sub gdk_display_supports_input_shapes ( N-GObject $display )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_notify_startup_complete:
=begin pod
=head2 [[gdk_] display_] notify_startup_complete

Indicates to the GUI environment that the application has
finished loading, using a given identifier.

GTK+ will call this function automatically for B<Gnome::Gtk3::Window>
with custom startup-notification identifier unless
C<gtk_window_set_auto_startup_notification()> is called to
disable that feature.

Since: 3.0

  method gdk_display_notify_startup_complete ( Str $startup_id )

=item Str $startup_id; a startup-notification identifier, for which notification process should be completed

=end pod

sub gdk_display_notify_startup_complete ( N-GObject $display, Str $startup_id )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_app_launch_context:
=begin pod
=head2 [[gdk_] display_] get_app_launch_context

Returns a B<Gnome::Gdk3::AppLaunchContext> suitable for launching
applications on the given display.

Returns: (transfer full): a new B<Gnome::Gdk3::AppLaunchContext> for I<display>.
Free with C<g_object_unref()> when done

Since: 3.0

  method gdk_display_get_app_launch_context ( --> N-GObject  )


=end pod

sub gdk_display_get_app_launch_context ( N-GObject $display )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_default_seat:
=begin pod
=head2 [[gdk_] display_] get_default_seat

Returns the default B<Gnome::Gdk3::Seat> for this display.

Returns: (transfer none): the default seat.

Since: 3.20

  method gdk_display_get_default_seat ( --> N-GObject  )


=end pod

sub gdk_display_get_default_seat ( N-GObject $display )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_list_seats:
=begin pod
=head2 [[gdk_] display_] list_seats

Returns the list of seats known to I<display>.

Returns: (transfer container) (element-type B<Gnome::Gdk3::Seat>): the
list of seats known to the B<Gnome::Gdk3::Display>

Since: 3.20

  method gdk_display_list_seats ( --> N-GList  )


=end pod

sub gdk_display_list_seats ( N-GObject $display )
  returns N-GList
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_n_monitors:
=begin pod
=head2 [[gdk_] display_] get_n_monitors

Gets the number of monitors that belong to I<display>.

The returned number is valid until the next emission of the
 I<monitor-added> or  I<monitor-removed> signal.

Returns: the number of monitors
Since: 3.22

  method gdk_display_get_n_monitors ( --> int32  )


=end pod

sub gdk_display_get_n_monitors ( N-GObject $display )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_monitor:
=begin pod
=head2 [[gdk_] display_] get_monitor

Gets a monitor associated with this display.

Returns: (transfer none): the B<Gnome::Gdk3::Monitor>, or C<Any> if
I<monitor_num> is not a valid monitor number
Since: 3.22

  method gdk_display_get_monitor ( int32 $monitor_num --> N-GObject  )

=item int32 $monitor_num; number of the monitor

=end pod

sub gdk_display_get_monitor ( N-GObject $display, int32 $monitor_num )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_primary_monitor:
=begin pod
=head2 [[gdk_] display_] get_primary_monitor

Gets the primary monitor for the display.

The primary monitor is considered the monitor where the “main desktop”
lives. While normal application windows typically allow the window
manager to place the windows, specialized desktop applications
such as panels should place themselves on the primary monitor.

Returns: (transfer none): the primary monitor, or C<Any> if no primary
monitor is configured by the user
Since: 3.22

  method gdk_display_get_primary_monitor ( --> N-GObject  )


=end pod

sub gdk_display_get_primary_monitor ( N-GObject $display )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_monitor_at_point:
=begin pod
=head2 [[gdk_] display_] get_monitor_at_point

Gets the monitor in which the point (I<x>, I<y>) is located,
or a nearby monitor if the point is not in any monitor.

Returns: (transfer none): the monitor containing the point
Since: 3.22

  method gdk_display_get_monitor_at_point ( int32 $x, int32 $y --> N-GObject  )

=item int32 $x; the x coordinate of the point
=item int32 $y; the y coordinate of the point

=end pod

sub gdk_display_get_monitor_at_point ( N-GObject $display, int32 $x, int32 $y )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_display_get_monitor_at_window:
=begin pod
=head2 [[gdk_] display_] get_monitor_at_window

Gets the monitor in which the largest area of I<window>
resides, or a monitor close to I<window> if it is outside
of all monitors.

Returns: (transfer none): the monitor with the largest overlap with I<window>
Since: 3.22

  method gdk_display_get_monitor_at_window ( N-GObject $window --> N-GObject  )

=item N-GObject $window; a B<Gnome::Gdk3::Window>

=end pod

sub gdk_display_get_monitor_at_window ( N-GObject $display, N-GObject $window )
  returns N-GObject
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


=comment #TS:0:opened:
=head3 opened

The I<opened> signal is emitted when the connection to the windowing
system for I<display> is opened.

  method handler (
    Gnome::GObject::Object :widget($display),
    *%user-options
  );

=item $display; the object on which the signal is emitted


=comment #TS:0:closed:
=head3 closed

The I<closed> signal is emitted when the connection to the windowing
system for I<display> is closed.

Since: 2.2

  method handler (
    Int $is_error,
    Gnome::GObject::Object :widget($display),
    *%user-options
  );

=item $display; the object on which the signal is emitted

=item $is_error; C<1> if the display was closed due to an error


=comment #TS:0:seat-added:
=head3 seat-added

The I<seat-added> signal is emitted whenever a new seat is made
known to the windowing system.

Since: 3.20

  method handler (
    N-GObject #`{{ native Gnome::Gdk3::Seat }} $seat,
    Gnome::GObject::Object :widget($display),
    *%user-options
  );

=item $display; the object on which the signal is emitted

=item $seat; the seat that was just added


=comment #TS:0:seat-removed:
=head3 seat-removed

The I<seat-removed> signal is emitted whenever a seat is removed
by the windowing system.

Since: 3.20

  method handler (
    N-GObject #`{{ native Gnome::Gdk3::Seat }} $seat,
    Gnome::GObject::Object :widget($display),
    *%user-options
  );

=item $display; the object on which the signal is emitted

=item $seat; the seat that was just removed


=comment #TS:0:monitor-added:
=head3 monitor-added

The I<monitor-added> signal is emitted whenever a monitor is
added.

Since: 3.22

  method handler (
    N-GObject #`{{ native Gnome::Gdk3::Monitor }} $monitor,
    Gnome::GObject::Object :widget($display),
    *%user-options
  );

=item $display; the objedct on which the signal is emitted

=item $monitor; the monitor that was just added


=comment #TS:0:monitor-removed:
=head3 monitor-removed

The I<monitor-removed> signal is emitted whenever a monitor is
removed.

Since: 3.22

  method handler (
    N-GObject #`{{ native Gnome::Gdk3::Monitor }} $monitor,
    Gnome::GObject::Object :widget($display),
    *%user-options
  );

=item $display; the object on which the signal is emitted

=item $monitor; the monitor that was just removed


=end pod









=finish
#-------------------------------------------------------------------------------
sub gdk_display_open ( Str $display-name )
  returns N-GObject       # GdkDisplay
  is native(&gdk-lib)
  { * }

sub gdk_display_get_default ( )
  returns N-GObject       # GdkDisplay
  is native(&gdk-lib)
  { * }

sub gdk_display_warp_pointer (
  N-GObject $display, N-GObject $screen, int32 $x, int32 $y
) is native(&gdk-lib)
  { * }

sub gdk_display_get_name ( N-GObject $display )
  returns Str
  is native(&gdk-lib)
  { * }
