#TL:1:Gnome::Gdk3::Events:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Events

Functions for handling events from the window system

=head1 Description

This section describes functions dealing with events from the window system.

In GTK+ applications the events are handled automatically in C<gtk_main_do_event()> and passed on to the appropriate widgets, so these functions are rarely needed. Though some of the fields in the gdk event structures are useful.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::Events;
  also is Gnome::N::TopLevelClassSupport;

=head2 Example

  my Gnome::Gtk3::Window $top-window .= new;
  $top-window.set-title('Hello GTK!');
  # ... etcetera ...

  # Define a handler method
  method handle-keypress ( N-GdkEvent() $event, :$widget ) {
    if $event.event-any.type ~~ GDK_KEY_PRESS {
      my N-GdkEventKey() $event-key = $event;
      if Buf.new($event.event-key.keyval).decode eq 's' {
        # key 's' pressed, stop process ...
      }
    }
  }

  # And register the signal handler for a window event
  $top-window.register-signal( self, 'handle-keypress', 'key-press-event');

If the handler handles only one event type, the method can also be defined as

  method handle-keypress ( N-GdkEventKey() $event-key, :$widget ) {
    if $event-key.type ~~ GDK_KEY_PRESS and
      Buf.new($event-key.keyval).decode eq 's' {
      # key 's' pressed, stop process ...
    }
  }

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::TopLevelClassSupport:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gdk3::Types:api<1>;

use Gnome::Cairo::Types:api<1>;

#-------------------------------------------------------------------------------
# https://developer.gnome.org/gdk3/stable/gdk3-Event-Structures.html
# https://developer.gnome.org/gdk3/stable/gdk3-Events.html
unit class Gnome::Gdk3::Events:auth<github:MARTIMM>:api<1>;
also is Gnome::N::TopLevelClassSupport;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkCrossingMode

Specifies the crossing mode for B<N-GdkEventCrossing>.

=item GDK_CROSSING_NORMAL: crossing because of pointer motion.
=item GDK_CROSSING_GRAB: crossing because a grab is activated.
=item GDK_CROSSING_UNGRAB: crossing because a grab is deactivated.
=item GDK_CROSSING_GTK_GRAB: crossing because a GTK+ grab is activated.
=item GDK_CROSSING_GTK_UNGRAB: crossing because a GTK+ grab is deactivated.
=item GDK_CROSSING_STATE_CHANGED: crossing because a GTK+ widget changed state (e.g. sensitivity).
=item GDK_CROSSING_TOUCH_BEGIN: crossing because a touch sequence has begun, this event is synthetic as the pointer might have not left the window.
=item GDK_CROSSING_TOUCH_END: crossing because a touch sequence has ended, this event is synthetic as the pointer might have not left the window.
=item GDK_CROSSING_DEVICE_SWITCH: crossing because of a device switch (i.e. a mouse taking control of the pointer after a touch device), this event is synthetic as the pointer didn’t leave the window.

=end pod

#TE:0:GdkCrossingMode:
enum GdkCrossingMode is export (
  'GDK_CROSSING_NORMAL',
  'GDK_CROSSING_GRAB',
  'GDK_CROSSING_UNGRAB',
  'GDK_CROSSING_GTK_GRAB',
  'GDK_CROSSING_GTK_UNGRAB',
  'GDK_CROSSING_STATE_CHANGED',
  'GDK_CROSSING_TOUCH_BEGIN',
  'GDK_CROSSING_TOUCH_END',
  'GDK_CROSSING_DEVICE_SWITCH'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkEventType

Specifies the type of the event.

Do not confuse these events with the signals that GTK+ widgets emit. Although many of these events result in corresponding signals being emitted, the events are often transformed or filtered along the way.

=comment In some language bindings, the values C<GDK-2BUTTON-PRESS> and C<GDK-3BUTTON-PRESS> would translate into something syntactically invalid (eg `Gdk.EventType.2ButtonPress`, where a symbol is not allowed to start with a number). In that case, the aliases C<GDK-DOUBLE-BUTTON-PRESS> and C<GDK-TRIPLE-BUTTON-PRESS> can be used instead.

=item GDK_NOTHING: a special code to indicate a null event.
=item GDK_DELETE: the window manager has requested that the toplevel window be hidden or destroyed, usually when the user clicks on a special icon in the title bar.
=item GDK_DESTROY: the window has been destroyed.
=item GDK_EXPOSE: all or part of the window has become visible and needs to be redrawn.
=item GDK_MOTION_NOTIFY: the pointer (usually a mouse) has moved.
=item GDK_BUTTON_PRESS: a mouse button has been pressed.
=item GDK_2BUTTON_PRESS: a mouse button has been double-clicked (clicked twice within a short period of time). Note that each click also generates a C<GDK_BUTTON_PRESS> event.
=item GDK_DOUBLE_BUTTON_PRESS: alias for C<GDK_2BUTTON_PRESS>.
=item GDK_3BUTTON_PRESS: a mouse button has been clicked 3 times in a short period of time. Note that each click also generates a C<GDK_BUTTON_PRESS> event.
=item GDK_TRIPLE_BUTTON_PRESS: alias for C<GDK_3BUTTON_PRESS>.
=item GDK_BUTTON_RELEASE: a mouse button has been released.
=item GDK_KEY_PRESS: a key has been pressed.
=item GDK_KEY_RELEASE: a key has been released.
=item GDK_ENTER_NOTIFY: the pointer has entered the window.
=item GDK_LEAVE_NOTIFY: the pointer has left the window.
=item GDK_FOCUS_CHANGE: the keyboard focus has entered or left the window.
=item GDK_CONFIGURE: the size, position or stacking order of the window has changed. Note that GTK+ discards these events for C<GDK_WINDOW_CHILD> windows.
=item GDK_MAP: the window has been mapped.
=item GDK_UNMAP: the window has been unmapped.
=item GDK_PROPERTY_NOTIFY: a property on the window has been changed or deleted.
=item GDK_SELECTION_CLEAR: the application has lost ownership of a selection.
=item GDK_SELECTION_REQUEST: another application has requested a selection.
=item GDK_SELECTION_NOTIFY: a selection has been received.
=item GDK_PROXIMITY_IN: an input device has moved into contact with a sensing surface (e.g. a touchscreen or graphics tablet).
=item GDK_PROXIMITY_OUT: an input device has moved out of contact with a sensing surface.
=item GDK_DRAG_ENTER: the mouse has entered the window while a drag is in progress.
=item GDK_DRAG_LEAVE: the mouse has left the window while a drag is in progress.
=item GDK_DRAG_MOTION: the mouse has moved in the window while a drag is in progress.
=item GDK_DRAG_STATUS: the status of the drag operation initiated by the window has changed.
=item GDK_DROP_START: a drop operation onto the window has started.
=item GDK_DROP_FINISHED: the drop operation initiated by the window has completed.
=item GDK_CLIENT_EVENT: a message has been received from another application.
=item GDK_VISIBILITY_NOTIFY: the window visibility status has changed.
=item GDK_SCROLL: the scroll wheel was turned
=item GDK_WINDOW_STATE: the state of a window has changed. See B<Gnome::Gdk3::WindowState> for the possible window states
=item GDK_SETTING: a setting has been modified.
=item GDK_OWNER_CHANGE: the owner of a selection has changed. This event type was added in 2.6
=item GDK_GRAB_BROKEN: a pointer or keyboard grab was broken. This event type was added in 2.8.
=item GDK_DAMAGE: the content of the window has been changed. This event type was added in 2.14.
=item GDK_TOUCH_BEGIN: A new touch event sequence has just started. This event type was added in 3.4.
=item GDK_TOUCH_UPDATE: A touch event sequence has been updated. This event type was added in 3.4.
=item GDK_TOUCH_END: A touch event sequence has finished. This event type was added in 3.4.
=item GDK_TOUCH_CANCEL: A touch event sequence has been canceled. This event type was added in 3.4.
=item GDK_TOUCHPAD_SWIPE: A touchpad swipe gesture event, the current state is determined by its phase field.
=item GDK_TOUCHPAD_PINCH: A touchpad pinch gesture event, the current state is determined by its phase field.
=item GDK_PAD_BUTTON_PRESS: A tablet pad button press event.
=item GDK_PAD_BUTTON_RELEASE: A tablet pad button release event
=item GDK_PAD_RING: A tablet pad axis event from a "ring".
=item GDK_PAD_STRIP: A tablet pad axis event from a "strip".
=item GDK_PAD_GROUP_MODE: A tablet pad group mode change.
=item GDK_EVENT_LAST: marks the end of the GdkEventType enumeration.

=end pod

#TE:4:GdkEventType:
enum GdkEventType is export (
  'GDK_NOTHING'		=> -1,
  'GDK_DELETE'		=> 0,
  'GDK_DESTROY'		=> 1,
  'GDK_EXPOSE'		=> 2,
  'GDK_MOTION_NOTIFY'	=> 3,
  'GDK_BUTTON_PRESS'	=> 4,
  'GDK_2BUTTON_PRESS'	=> 5,
  'GDK_DOUBLE_BUTTON_PRESS' => 5,   # = GDK_2BUTTON_PRESS,
  'GDK_3BUTTON_PRESS'	=> 6,
  'GDK_TRIPLE_BUTTON_PRESS' => 6,   # = GDK_3BUTTON_PRESS,
  'GDK_BUTTON_RELEASE'	=> 7,
  'GDK_KEY_PRESS'		=> 8,
  'GDK_KEY_RELEASE'	=> 9,
  'GDK_ENTER_NOTIFY'	=> 10,
  'GDK_LEAVE_NOTIFY'	=> 11,
  'GDK_FOCUS_CHANGE'	=> 12,
  'GDK_CONFIGURE'		=> 13,
  'GDK_MAP'		=> 14,
  'GDK_UNMAP'		=> 15,
  'GDK_PROPERTY_NOTIFY'	=> 16,
  'GDK_SELECTION_CLEAR'	=> 17,
  'GDK_SELECTION_REQUEST' => 18,
  'GDK_SELECTION_NOTIFY'	=> 19,
  'GDK_PROXIMITY_IN'	=> 20,
  'GDK_PROXIMITY_OUT'	=> 21,
  'GDK_DRAG_ENTER'        => 22,
  'GDK_DRAG_LEAVE'        => 23,
  'GDK_DRAG_MOTION'       => 24,
  'GDK_DRAG_STATUS'       => 25,
  'GDK_DROP_START'        => 26,
  'GDK_DROP_FINISHED'     => 27,
  'GDK_CLIENT_EVENT'	=> 28,
  'GDK_VISIBILITY_NOTIFY' => 29,
  'GDK_SCROLL'            => 31,
  'GDK_WINDOW_STATE'      => 32,
  'GDK_SETTING'           => 33,
  'GDK_OWNER_CHANGE'      => 34,
  'GDK_GRAB_BROKEN'       => 35,
  'GDK_DAMAGE'            => 36,
  'GDK_TOUCH_BEGIN'       => 37,
  'GDK_TOUCH_UPDATE'      => 38,
  'GDK_TOUCH_END'         => 39,
  'GDK_TOUCH_CANCEL'      => 40,
  'GDK_TOUCHPAD_SWIPE'    => 41,
  'GDK_TOUCHPAD_PINCH'    => 42,
  'GDK_PAD_BUTTON_PRESS'  => 43,
  'GDK_PAD_BUTTON_RELEASE' => 44,
  'GDK_PAD_RING'          => 45,
  'GDK_PAD_STRIP'         => 46,
  'GDK_PAD_GROUP_MODE'    => 47,
  'GDK_EVENT_LAST'        # helper variable for decls
);

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkFilterReturn

Specifies the result of applying a B<Gnome::Gdk3::FilterFunc> to a native event.

=item GDK_FILTER_CONTINUE: event not handled, continue processing.
=item GDK_FILTER_TRANSLATE: native event translated into a GDK event and stored in the `event` structure that was passed in.
=item GDK_FILTER_REMOVE: event handled, terminate processing.


=end pod

#TE:0:GdkFilterReturn:
enum GdkFilterReturn is export (
  GDK_FILTER_CONTINUE GDK_FILTER_TRANSLATE GDK_FILTER_REMOVE
);
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkNotifyType

Specifies the kind of crossing for B<N-GdkEventCrossing>.

See the X11 protocol specification of LeaveNotify for full details of crossing event generation.

=item GDK_NOTIFY_ANCESTOR: the window is entered from an ancestor or left towards an ancestor.
=item GDK_NOTIFY_VIRTUAL: the pointer moves between an ancestor and an inferior of the window.
=item GDK_NOTIFY_INFERIOR: the window is entered from an inferior or left towards an inferior.
=item GDK_NOTIFY_NONLINEAR: the window is entered from or left towards a window which is neither an ancestor nor an inferior.
=item GDK_NOTIFY_NONLINEAR_VIRTUAL: the pointer moves between two windows which are not ancestors of each other and the window is part of the ancestor chain between one of these windows and their least common ancestor.
=item GDK_NOTIFY_UNKNOWN: an unknown type of enter/leave event occurred.

=end pod

#TE:0:GdkNotifyType:
enum GdkNotifyType is export (
  'GDK_NOTIFY_ANCESTOR'		=> 0,
  'GDK_NOTIFY_VIRTUAL'		=> 1,
  'GDK_NOTIFY_INFERIOR'		=> 2,
  'GDK_NOTIFY_NONLINEAR'		=> 3,
  'GDK_NOTIFY_NONLINEAR_VIRTUAL'	=> 4,
  'GDK_NOTIFY_UNKNOWN'		=> 5
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkOwnerChange

Specifies why a selection ownership was changed.

=item GDK_OWNER_CHANGE_NEW_OWNER: some other app claimed the ownership
=item GDK_OWNER_CHANGE_DESTROY: the window was destroyed
=item GDK_OWNER_CHANGE_CLOSE: the client was closed

=end pod

#TE:0:GdkOwnerChange:
enum GdkOwnerChange is export (
  'GDK_OWNER_CHANGE_NEW_OWNER',
  'GDK_OWNER_CHANGE_DESTROY',
  'GDK_OWNER_CHANGE_CLOSE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkPropertyState

Specifies the type of a property change for a B<N-GdkEventProperty>.

=item GDK_PROPERTY_NEW_VALUE: the property value was changed.
=item GDK_PROPERTY_DELETE: the property was deleted.

=end pod

#TE:0:GdkPropertyState:
enum GdkPropertyState is export (
  'GDK_PROPERTY_NEW_VALUE',
  'GDK_PROPERTY_DELETE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkScrollDirection

Specifies the direction for B<N-GdkEventScroll>.

=item GDK_SCROLL_UP: the window is scrolled up.
=item GDK_SCROLL_DOWN: the window is scrolled down.
=item GDK_SCROLL_LEFT: the window is scrolled to the left.
=item GDK_SCROLL_RIGHT: the window is scrolled to the right.
=item GDK_SCROLL_SMOOTH: the scrolling is determined by the delta values in B<N-GdkEventScroll>. See C<gdk_event_get_scroll_deltas()>

=end pod

#TE:0:GdkScrollDirection:
enum GdkScrollDirection is export (
  'GDK_SCROLL_UP',
  'GDK_SCROLL_DOWN',
  'GDK_SCROLL_LEFT',
  'GDK_SCROLL_RIGHT',
  'GDK_SCROLL_SMOOTH'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkSettingAction

Specifies the kind of modification applied to a setting in a B<N-GdkEventSetting>.

=item GDK_SETTING_ACTION_NEW: a setting was added.
=item GDK_SETTING_ACTION_CHANGED: a setting was changed.
=item GDK_SETTING_ACTION_DELETED: a setting was deleted.

=end pod

#TE:0:GdkSettingAction:
enum GdkSettingAction is export (
  'GDK_SETTING_ACTION_NEW',
  'GDK_SETTING_ACTION_CHANGED',
  'GDK_SETTING_ACTION_DELETED'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkTouchpadGesturePhase

Specifies the current state of a touchpad gesture. All gestures are guaranteed to begin with an event with phase C<GDK_TOUCHPAD_GESTURE_PHASE_BEGIN>, followed by 0 or several events with phase C<GDK_TOUCHPAD_GESTURE_PHASE_UPDATE>.

A finished gesture may have 2 possible outcomes, an event with phase C<GDK_TOUCHPAD_GESTURE_PHASE_END> will be emitted when the gesture is considered successful, this should be used as the hint to perform any permanent changes. Cancelled gestures may be so for a variety of reasons, due to hardware or the compositor, or due to the gesture recognition layers hinting the gesture did not finish resolutely (eg. a 3rd finger being added during a pinch gesture). In these cases, the last event will report the phase C<GDK_TOUCHPAD_GESTURE_PHASE_CANCEL>, this should be used as a hint to undo any visible/permanent changes that were done throughout the progress of the gesture.

See also B<Gnome::Gdk3::EventTouchpadSwipe> and B<Gnome::Gdk3::EventTouchpadPinch>.

=item GDK_TOUCHPAD_GESTURE_PHASE_BEGIN: The gesture has begun.
=item GDK_TOUCHPAD_GESTURE_PHASE_UPDATE: The gesture has been updated.
=item GDK_TOUCHPAD_GESTURE_PHASE_END: The gesture was finished, changes should be permanently applied.
=item GDK_TOUCHPAD_GESTURE_PHASE_CANCEL: The gesture was cancelled, all changes should be undone.

=end pod

#TE:0:GdkTouchpadGesturePhase:
enum GdkTouchpadGesturePhase is export (
  'GDK_TOUCHPAD_GESTURE_PHASE_BEGIN',
  'GDK_TOUCHPAD_GESTURE_PHASE_UPDATE',
  'GDK_TOUCHPAD_GESTURE_PHASE_END',
  'GDK_TOUCHPAD_GESTURE_PHASE_CANCEL'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkVisibilityState

Specifies the visiblity status of a window for a B<Gnome::Gdk3::EventVisibility>.

=item GDK_VISIBILITY_UNOBSCURED: the window is completely visible.
=item GDK_VISIBILITY_PARTIAL: the window is partially visible.
=item GDK_VISIBILITY_FULLY_OBSCURED: the window is not visible at all.

=end pod

#TE:0:GdkVisibilityState:
enum GdkVisibilityState is export (
  'GDK_VISIBILITY_UNOBSCURED',
  'GDK_VISIBILITY_PARTIAL',
  'GDK_VISIBILITY_FULLY_OBSCURED'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkWindowState

Specifies the state of a toplevel window.

=item GDK_WINDOW_STATE_WITHDRAWN: the window is not shown.
=item GDK_WINDOW_STATE_ICONIFIED: the window is minimized.
=item GDK_WINDOW_STATE_MAXIMIZED: the window is maximized.
=item GDK_WINDOW_STATE_STICKY: the window is sticky.
=item GDK_WINDOW_STATE_FULLSCREEN: the window is maximized without decorations.
=item GDK_WINDOW_STATE_ABOVE: the window is kept above other windows.
=item GDK_WINDOW_STATE_BELOW: the window is kept below other windows.
=item GDK_WINDOW_STATE_FOCUSED: the window is presented as focused (with active decorations).
=item GDK_WINDOW_STATE_TILED: the window is in a tiled state. Since Gtk version 3.22.23, this is deprecated in favor of per-edge information.
=item GDK_WINDOW_STATE_TOP_TILED: whether the top edge is tiled.
=item GDK_WINDOW_STATE_TOP_RESIZABLE: whether the top edge is resizable.
=item GDK_WINDOW_STATE_RIGHT_TILED: whether the right edge is tiled.
=item GDK_WINDOW_STATE_RIGHT_RESIZABLE: whether the right edge is resizable.
=item GDK_WINDOW_STATE_BOTTOM_TILED: whether the bottom edge is tiled.
=item GDK_WINDOW_STATE_BOTTOM_RESIZABLE: whether the bottom edge is resizable.
=item GDK_WINDOW_STATE_LEFT_TILED: whether the left edge is tiled.
=item GDK_WINDOW_STATE_LEFT_RESIZABLE: whether the left edge is resizable.


=end pod

#TE:0:GdkWindowState:
enum GdkWindowState is export (
  'GDK_WINDOW_STATE_WITHDRAWN'        => 1 +< 0,
  'GDK_WINDOW_STATE_ICONIFIED'        => 1 +< 1,
  'GDK_WINDOW_STATE_MAXIMIZED'        => 1 +< 2,
  'GDK_WINDOW_STATE_STICKY'           => 1 +< 3,
  'GDK_WINDOW_STATE_FULLSCREEN'       => 1 +< 4,
  'GDK_WINDOW_STATE_ABOVE'            => 1 +< 5,
  'GDK_WINDOW_STATE_BELOW'            => 1 +< 6,
  'GDK_WINDOW_STATE_FOCUSED'          => 1 +< 7,
  'GDK_WINDOW_STATE_TILED'            => 1 +< 8,
  'GDK_WINDOW_STATE_TOP_TILED'        => 1 +< 9,
  'GDK_WINDOW_STATE_TOP_RESIZABLE'    => 1 +< 10,
  'GDK_WINDOW_STATE_RIGHT_TILED'      => 1 +< 11,
  'GDK_WINDOW_STATE_RIGHT_RESIZABLE'  => 1 +< 12,
  'GDK_WINDOW_STATE_BOTTOM_TILED'     => 1 +< 13,
  'GDK_WINDOW_STATE_BOTTOM_RESIZABLE' => 1 +< 14,
  'GDK_WINDOW_STATE_LEFT_TILED'       => 1 +< 15,
  'GDK_WINDOW_STATE_LEFT_RESIZABLE'   => 1 +< 16
);

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventAny

Contains the fields which are common to all event structs. Any event pointer can safely be cast to a pointer to a B<N-GdkEventAny> to access these fields.

=item GdkEventType $.type: the type of the event.
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.

=end pod

#TT:0:N-GdkEventAny:
class N-GdkEventAny is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;

  method COERCE ( $no --> N-GdkEventAny ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventAny, $no)
  }
}

#`{{TODO cairo_region_t not defined
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventExpose

Generated when all or part of a window becomes visible and needs to be redrawn.

=item GdkEventType $.type: the type of the event (C<GDK_EXPOSE> or C<GDK_DAMAGE>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item N-GObject $.area: bounding box of I<region>.
=item cairo_region_t $.region: the region that needs to be redrawn.
=item ___count: the number of contiguous C<GDK_EXPOSE> events following this one. The only use for this is “exposure compression”, i.e. handling all contiguous C<GDK_EXPOSE> events in one go, though GDK performs some exposure compression so this is not normally needed.

=end pod

# TT:0:N-GdkEventExpose:
class N-GdkEventExpose is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has N-GObject $.area;
  has cairo_region_t $.region;
}
}}

#`{{   Deprecated: 3.12
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventVisibility

Generated when the window visibility status has changed.

Deprecated: 3.12: Modern composited windowing systems with pervasive transparency make it impossible to track the visibility of a window reliably, so this event can not be guaranteed to provide useful information.

=item GdkEventType $.type: the type of the event (C<GDK_VISIBILITY_NOTIFY>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item GdkVisibilityState $.state: the new visibility state (C<GDK_VISIBILITY_FULLY_OBSCURED>, C<GDK_VISIBILITY_PARTIAL> or C<GDK_VISIBILITY_UNOBSCURED>).

=end pod

# TT:0:N-GdkEventVisibility:
class N-GdkEventVisibility is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has GEnum $.state;
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventMotion

Generated when the pointer moves.

=item GdkEventType $.type: the type of the event.
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item C<Num()> $.x: the x coordinate of the pointer relative to the window.
=item C<Num()> $.y: the y coordinate of the pointer relative to the window.
=item C<Num()> $.axes: I<x>, I<y> translated to the axes of I<device>, or C<undefined> if I<device> is the mouse.
=item UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See B<Gnome::Gdk3::ModifierType>.
=item C<Int()> $.is_hint: set to 1 if this event is just a hint, see the C<GDK_POINTER_MOTION_HINT_MASK> value of B<Gnome::Gdk3::EventMask>.
=item N-GObject $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.
=item C<Num()> $.x_root: the x coordinate of the pointer relative to the root of the screen.
=item C<Num()> $.y_root: the y coordinate of the pointer relative to the root of the screen.

=end pod

#TT:1:N-GdkEventMotion:
class N-GdkEventMotion is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has guint32 $.time;
  has gdouble $.x;
  has gdouble $.y;
  has gdouble $.axes;
  has guint $.state;
  has gint16 $.is_hint;
  has N-GObject $.device;
  has gdouble $.x_root;
  has gdouble $.y_root;

  submethod BUILD (
    Int:D :$type, Int() :$time, Num() :$x, Num() :$y, Num() :$axes,
    UInt() :$state, Bool :$is_hint, Num() :$x_root, Num() :$y_root
  ) {
    $!type = $type.value;
    $!send_event = 1;
    $!time = $time // time;

    $!x = $x // 0e0;
    $!y = $y // 0e0;
    $!axes = $axes // 0e0;
    $!state = $state // 0;
    $!is_hint = $is_hint ?? 1 !! 0;
    $!x_root = $x_root // 0e0;
    $!y_root = $y_root  // 0e0;
  }

  submethod TWEAK ( N-GObject() :$window, N-GObject() :$device ) {
    $!window := $window if ?$window;
    $!device := $device if ?$device;
  }

  method COERCE ( $no --> N-GdkEventMotion ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventMotion, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventButton

Used for button press and button release events. The I<type> field will be one of C<GDK_BUTTON_PRESS>, C<GDK_2BUTTON_PRESS>, C<GDK_3BUTTON_PRESS> or C<GDK_BUTTON_RELEASE>,

Double and triple-clicks result in a sequence of events being received. For double-clicks the order of events will be:

- C<GDK_BUTTON_PRESS>
- C<GDK_BUTTON_RELEASE>
- C<GDK_BUTTON_PRESS>
- C<GDK_2BUTTON_PRESS>
- C<GDK_BUTTON_RELEASE>

Note that the first click is received just like a normal button press, while the second click results in a C<GDK_2BUTTON_PRESS> being received just after the C<GDK_BUTTON_PRESS>.

Triple-clicks are very similar to double-clicks, except that C<GDK_3BUTTON_PRESS> is inserted after the third click. The order of the events is:

- C<GDK_BUTTON_PRESS>
- C<GDK_BUTTON_RELEASE>
- C<GDK_BUTTON_PRESS>
- C<GDK_2BUTTON_PRESS>
- C<GDK_BUTTON_RELEASE>
- C<GDK_BUTTON_PRESS>
- C<GDK_3BUTTON_PRESS>
- C<GDK_BUTTON_RELEASE>

For a double click to occur, the second button press must occur within 1/4 of a second of the first. For a triple click to occur, the third button press must also occur within 1/2 second of the first button press.

=item C<GdkEventType> $.type: the type of the event (C<GDK_BUTTON_PRESS>, C<GDK_2BUTTON_PRESS>, C<GDK_3BUTTON_PRESS> or C<GDK_BUTTON_RELEASE>).
=item C<N-GObject> $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item C<UInt> $.time: the time of the event in milliseconds.
=item C<Num()> $.x: the x coordinate of the pointer relative to the window.
=item C<Num()> $.y: the y coordinate of the pointer relative to the window.
=item C<Num()> $.axes: I<x>, I<y> translated to the axes of I<device>, or C<undefined> if I<device> is the mouse.
=item C<UInt> $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See B<Gnome::Gdk3::ModifierType>.
=item C<UInt> $.button: the button which was pressed or released, numbered from 1 to 5. Normally button 1 is the left mouse button, 2 is the middle button, and 3 is the right button. On 2-button mice, the middle button can often be simulated by pressing both mouse buttons together.
=item C<N-GObject> $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.
=item C<Num()> $.x_root: the x coordinate of the pointer relative to the root of the screen.
=item C<Num()> $.y_root: the y coordinate of the pointer relative to the root of the screen.

=end pod

#TT:1:N-GdkEventButton:
class N-GdkEventButton is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has guint32 $.time;
  has gdouble $.x;
  has gdouble $.y;
  has gdouble $.axes;
  has guint $.state;
  has guint $.button;
  has N-GObject $.device;
  has gdouble $.x_root;
  has gdouble $.y_root;

  submethod BUILD (
    Int:D :$type, Int() :$time,
    Num() :$x, Num() :$y, Num() :$axes,
    UInt() :$state, UInt() :$button,
    Num() :$x_root, Num():$y_root
  ) {
    $!type = $type.value;
    $!send_event = 1;
    $!time = $time // time;
    $!x = $x // 0e0;
    $!y = $y // 0e0;
    $!axes = $axes // 0e0;
    $!state = $state // 0;
    $!button = $button // 0;
    $!x_root = $x_root // 0e0;
    $!y_root = $y_root // 0e0;
  }

  submethod TWEAK ( N-GObject() :$window, N-GObject() :$device ) {
    $!window := $window if ?$window;
    $!device := $device if ?$device;
  }

  method COERCE ( $no --> N-GdkEventButton ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventButton, $no)
  }
}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventTouch

Used for touch events.
I<type> field will be one of C<GDK_TOUCH_BEGIN>, C<GDK_TOUCH_UPDATE>,
C<GDK_TOUCH_END> or C<GDK_TOUCH_CANCEL>.

Touch events are grouped into sequences by means of the I<sequence>
field, which can also be obtained with C<gdk_event_get_event_sequence()>.
Each sequence begins with a C<GDK_TOUCH_BEGIN> event, followed by
any number of C<GDK_TOUCH_UPDATE> events, and ends with a C<GDK_TOUCH_END>
(or C<GDK_TOUCH_CANCEL>) event. With multitouch devices, there may be
several active sequences at the same time.


=item GdkEventType $.type: the type of the event (C<GDK_TOUCH_BEGIN>, C<GDK_TOUCH_UPDATE>, C<GDK_TOUCH_END>, C<GDK_TOUCH_CANCEL>)
=item N-GObject $.window: the window which received the event
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item C<Num()> $.x: the x coordinate of the pointer relative to the window
=item C<Num()> $.y: the y coordinate of the pointer relative to the window
=item C<Num()> $.axes: I<x>, I<y> translated to the axes of I<device>, or C<undefined> if I<device> is the mouse
=item UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See B<Gnome::Gdk3::ModifierType>
=item GdkEventSequence $.sequence: the event sequence that the event belongs to
=item Bool $.emulating_pointer: whether the event should be used for emulating pointer event
=item N-GObject $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.
=item C<Num()> $.x_root: the x coordinate of the pointer relative to the root of the screen
=item C<Num()> $.y_root: the y coordinate of the pointer relative to the root of the screen


=end pod

#TT:0:N-GdkEventTouch:
class N-GdkEventTouch is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has guint32 $.time;
  has gdouble $.x;
  has gdouble $.y;
  has gdouble $.axes;
  has guint $.state;
  has GdkEventSequence $.sequence;
  has gboolean $.emulating_pointer;
  has N-GObject $.device;
  has gdouble $.x_root;
  has gdouble $.y_root;
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventScroll

Generated from button presses for the buttons 4 to 7. Wheel mice are
usually configured to generate button press events for buttons 4 and 5
when the wheel is turned.

Some GDK backends can also generate “smooth” scroll events, which
can be recognized by the C<GDK_SCROLL_SMOOTH> scroll direction. For
these, the scroll deltas can be obtained with
C<gdk_event_get_scroll_deltas()>.


=item GdkEventType $.type: the type of the event (C<GDK_SCROLL>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item C<Num()> $.x: the x coordinate of the pointer relative to the window.
=item C<Num()> $.y: the y coordinate of the pointer relative to the window.
=item UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See B<Gnome::Gdk3::ModifierType>.
=item GdkScrollDirection $.direction: the direction to scroll to (one of C<GDK_SCROLL_UP>, C<GDK_SCROLL_DOWN>, C<GDK_SCROLL_LEFT>, C<GDK_SCROLL_RIGHT> or C<GDK_SCROLL_SMOOTH>).
=item N-GObject $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.
=item C<Num()> $.x_root: the x coordinate of the pointer relative to the root of the screen.
=item C<Num()> $.y_root: the y coordinate of the pointer relative to the root of the screen.
=item C<Num()> $.delta_x: the x coordinate of the scroll delta
=item C<Num()> $.delta_y: the y coordinate of the scroll delta


=end pod

#TT:0:N-GdkEventScroll:
class N-GdkEventScroll is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has guint32 $.time;
  has gdouble $.x;
  has gdouble $.y;
  has guint $.state;
  has GEnum $.direction;
  has N-GObject $.device;
  has gdouble $.x_root;
  has gdouble $.y_root;
  has gdouble $.delta_x;
  has gdouble $.delta_y;
  has guint $.is_stop;

  submethod BUILD (
    Int:D :$type, Int() :$time, Num() :$x, Num() :$y,
    UInt() :$state, Int() :$direction, Num() :$x_root, Num() :$y_root
  ) {
    $!type = $type.value;
    $!send_event = 1;
    $!time = $time // time;

    $!x = $x // 0e0;
    $!y = $y // 0e0;
    $!state = $state // 0;
    $!direction = $direction // 0;
    $!x_root = $x_root // 0e0;
    $!y_root = $y_root  // 0e0;
  }

  submethod TWEAK ( N-GObject() :$window, N-GObject() :$device ) {
    $!window := $window if ?$window;
    $!device := $device if ?$device;
  }

  method COERCE ( $no --> N-GdkEventScroll ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventScroll, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventKey

Describes a key press or key release event.

=item C<GdkEventType> $.type: the type of the event (C<GDK_KEY_PRESS> or C<GDK_KEY_RELEASE>).
=item C<N-GObject> $.window: the window which received the event.
=item C<Int> $.send_event: C<True> if the event was sent explicitly.
=item C<UInt> $.time: the time of the event in milliseconds.
=item C<UInt> $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See B<Gnome::Gdk3::ModifierType>.
=item C<UInt> $.keyval: the key that was pressed or released. See the `gdk/gdkkeysyms.h` header file for a complete list of GDK key codes.
=item C<Int> $.length: the length of I<string>.
=comment item C<Str> $.string: a string containing an approximation of the text that would result from this keypress. The only correct way to handle text input of text is using input methods (see B<Gnome::Gdk3::IMContext>), C<B<I<so this field is deprecated and should never be used>>>. (C<gdk_unicode_to_keyval()> provides a non-deprecated way of getting an approximate translation for a key.) The string is encoded in the encoding of the current locale (Note: this for backwards compatibility: strings in GTK+ and GDK are typically in UTF-8.) and NUL-terminated. In some cases, the translation of the key code will be a single NUL byte, in which case looking at I<length> is necessary to distinguish it from the an empty translation.
=item C<UInt> $.hardware_keycode: the raw code of the key that was pressed or released.
=item C<UInt> $.group: the keyboard group.
=item C<Bool> is_modifier: a flag that indicates if I<hardware_keycode> is mapped to a modifier. Since 2.10

=end pod

#TT:1:N-GdkEventKey:
class N-GdkEventKey is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has guint32 $.time;
  has guint $.state;
  has guint $.keyval;
  has gint $.length = 0;             # string deprecated
  has gchar-ptr $.string;            # deprecated
  has guint16 $.hardware_keycode;
  has guint8 $.group;
  has guint $.is_modifier;

  submethod BUILD (
    Int:D :$type, Int() :$time, UInt() :$keyval,
    UInt() :$hardware_keycode, UInt() :$group,
    Bool() :$is_modifier
  ) {
    $!type = $type.value;
    $!send_event = 1;
    $!time = $time // time;

    $!keyval = $keyval // 0;
    $!hardware_keycode = $hardware_keycode // 0;
    $!group = $group // 0;
    $!is_modifier = $is_modifier ?? 1 !! 0;
  }

  submethod TWEAK ( N-GObject() :$window ) {
    $!window := $window if ?$window;
  }

  method COERCE ( $no --> N-GdkEventKey ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventKey, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventCrossing

Generated when the pointer enters or leaves a window.


=item GdkEventType $.type: the type of the event (C<GDK_ENTER_NOTIFY> or C<GDK_LEAVE_NOTIFY>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item N-GObject $.subwindow: the window that was entered or left.
=item UInt $.time: the time of the event in milliseconds.
=item C<Num()> $.x: the x coordinate of the pointer relative to the window.
=item C<Num()> $.y: the y coordinate of the pointer relative to the window.
=item C<Num()> $.x_root: the x coordinate of the pointer relative to the root of the screen.
=item C<Num()> $.y_root: the y coordinate of the pointer relative to the root of the screen.
=item GdkCrossingMode $.mode: the crossing mode (C<GDK_CROSSING_NORMAL>, C<GDK_CROSSING_GRAB>, C<GDK_CROSSING_UNGRAB>, C<GDK_CROSSING_GTK_GRAB>, C<GDK_CROSSING_GTK_UNGRAB> or C<GDK_CROSSING_STATE_CHANGED>).  C<GDK_CROSSING_GTK_GRAB>, C<GDK_CROSSING_GTK_UNGRAB>, and C<GDK_CROSSING_STATE_CHANGED> were added in 2.14 and are always synthesized, never native.
=item GdkNotifyType $.detail: the kind of crossing that happened (C<GDK_NOTIFY_INFERIOR>, C<GDK_NOTIFY_ANCESTOR>, C<GDK_NOTIFY_VIRTUAL>, C<GDK_NOTIFY_NONLINEAR> or C<GDK_NOTIFY_NONLINEAR_VIRTUAL>).
=item Bool $.focus: C<True> if I<window> is the focus window or an inferior.
=item UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See B<Gnome::Gdk3::ModifierType>.


=end pod

#TT:0:N-GdkEventCrossing:
class N-GdkEventCrossing is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has N-GObject $.subwindow;
  has guint32 $.time;
  has gdouble $.x;
  has gdouble $.y;
  has gdouble $.x_root;
  has gdouble $.y_root;
  has GEnum $.mode;
  has GEnum $.detail;
  has gboolean $.focus;
  has guint $.state;

  method COERCE ( $no --> N-GdkEventCrossing ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventCrossing, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventFocus

Describes a change of keyboard focus.


=item GdkEventType $.type: the type of the event (C<GDK_FOCUS_CHANGE>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item C<Int()> $.in: C<True> if the window has gained the keyboard focus, C<False> if it has lost the focus.


=end pod

#TT:0:N-GdkEventFocus:
class N-GdkEventFocus is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has gint16 $.in;

  method COERCE ( $no --> N-GdkEventFocus ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventFocus, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventConfigure

Generated when a window size or position has changed.


=item GdkEventType $.type: the type of the event (C<GDK_CONFIGURE>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item C<Int()> $.x: the new x coordinate of the window, relative to its parent.
=item C<Int()> $.y: the new y coordinate of the window, relative to its parent.
=item C<Int()> $.width: the new width of the window.
=item C<Int()> $.height: the new height of the window.


=end pod

#TT:0:N-GdkEventConfigure:
class N-GdkEventConfigure is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has gint $.x;
  has gint $.y;
  has gint $.width;
  has gint $.height;

  method COERCE ( $no --> N-GdkEventConfigure ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventConfigure, $no)
  }
}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventProperty

Describes a property change on a window.

=item GdkEventType $.type: the type of the event (C<GDK_PROPERTY_NOTIFY>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item GdkAtom $.atom: the property that was changed.
=item UInt $.time: the time of the event in milliseconds.
=item UInt $.state: (type GdkPropertyState): whether the property was changed (C<GDK_PROPERTY_NEW_VALUE>) or deleted (C<GDK_PROPERTY_DELETE>).


=end pod

#TT:0:N-GdkEventProperty:
class N-GdkEventProperty is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has GdkAtom $.atom;
  has guint32 $.time;
  has guint $.state;
}
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventSelection

Generated when a selection is requested or ownership of a selection
is taken over by another client application.


=item GdkEventType $.type: the type of the event (C<GDK_SELECTION_CLEAR>, C<GDK_SELECTION_NOTIFY> or C<GDK_SELECTION_REQUEST>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item GdkAtom $.selection: the selection.
=item GdkAtom $.target: the target to which the selection should be converted.
=item GdkAtom $.property: the property in which to place the result of the conversion.
=item UInt $.time: the time of the event in milliseconds.
=item N-GObject $.requestor: the window on which to place I<property> or C<undefined> if none.


=end pod

#TT:0:N-GdkEventSelection:
class N-GdkEventSelection is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has GdkAtom $.selection;
  has GdkAtom $.target;
  has GdkAtom $.property;
  has guint32 $.time;
  has N-GObject $.requestor;
}
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventOwnerChange

Generated when the owner of a selection changes. On X11, this
information is only available if the X server supports the XFIXES
extension.



=item GdkEventType $.type: the type of the event (C<GDK_OWNER_CHANGE>).
=item N-GObject $.window: the window which received the event
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item N-GObject $.owner: the new owner of the selection, or C<undefined> if there is none
=item GdkOwnerChange $.reason: the reason for the ownership change as a B<Gnome::Gdk3::OwnerChange> value
=item GdkAtom $.selection: the atom identifying the selection
=item UInt $.time: the timestamp of the event
=item UInt $.selection_time: the time at which the selection ownership was taken over


=end pod

#TT:0:N-GdkEventOwnerChange:
class N-GdkEventOwnerChange is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has N-GObject $.owner;
  has GEnum $.reason;
  has GdkAtom $.selection;
  has guint32 $.time;
  has guint32 $.selection_time;
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventProximity

Proximity events are generated when using GDK’s wrapper for the
XInput extension. The XInput extension is an add-on for standard X
that allows you to use nonstandard devices such as graphics tablets.
A proximity event indicates that the stylus has moved in or out of
contact with the tablet, or perhaps that the user’s finger has moved
in or out of contact with a touch screen.

This event type will be used pretty rarely. It only is important for
XInput aware programs that are drawing their own cursor.


=item GdkEventType $.type: the type of the event (C<GDK_PROXIMITY_IN> or C<GDK_PROXIMITY_OUT>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item N-GObject $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.


=end pod

#TT:0:N-GdkEventProximity:
class N-GdkEventProximity is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has guint32 $.time;
  has N-GObject $.device;

  method COERCE ( $no --> N-GdkEventProximity ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventProximity, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventSetting

Generated when a setting is modified.


=item GdkEventType $.type: the type of the event (C<GDK_SETTING>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item GdkSettingAction $.action: what happened to the setting (C<GDK_SETTING_ACTION_NEW>, C<GDK_SETTING_ACTION_CHANGED> or C<GDK_SETTING_ACTION_DELETED>).
=item Str $.name: the name of the setting.


=end pod

#TT:0:N-GdkEventSetting:
class N-GdkEventSetting is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has GEnum $.action;
  has gchar-ptr $.name;

  method COERCE ( $no --> N-GdkEventSetting ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventSetting, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventWindowState

Generated when the state of a toplevel window changes.


=item GdkEventType $.type: the type of the event (C<GDK_WINDOW_STATE>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item GdkWindowState $.changed_mask: mask specifying what flags have changed.
=item GdkWindowState $.new_window_state: the new window state, a combination of B<Gnome::Gdk3::WindowState> bits.


=end pod

#TT:0:N-GdkEventWindowState:
class N-GdkEventWindowState is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has GEnum $.changed_mask;
  has GEnum $.new_window_state;

  method COERCE ( $no --> N-GdkEventWindowState ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventWindowState, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventGrabBroken

Generated when a pointer or keyboard grab is broken. On X11, this happens
when the grab window becomes unviewable (i.e. it or one of its ancestors
is unmapped), or if the same application grabs the pointer or keyboard
again. Note that implicit grabs (which are initiated by button presses)
can also cause B<Gnome::Gdk3::EventGrabBroken> events.



=item GdkEventType $.type: the type of the event (C<GDK_GRAB_BROKEN>)
=item N-GObject $.window: the window which received the event, i.e. the window that previously owned the grab
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item Bool $.keyboard: C<True> if a keyboard grab was broken, C<False> if a pointer grab was broken
=item Bool $.implicit: C<True> if the broken grab was implicit
=item N-GObject $.grab_window: If this event is caused by another grab in the same application, I<grab_window> contains the new grab window. Otherwise I<grab_window> is C<undefined>.


=end pod

#TT:0:N-GdkEventGrabBroken:
class N-GdkEventGrabBroken is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has gboolean $.keyboard;
  has gboolean $.implicit;
  has N-GObject $.grab_window;

  method COERCE ( $no --> N-GdkEventGrabBroken ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventGrabBroken, $no)
  }
}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventDND

Generated during DND operations.


=item GdkEventType $.type: the type of the event (C<GDK_DRAG_ENTER>, C<GDK_DRAG_LEAVE>, C<GDK_DRAG_MOTION>, C<GDK_DRAG_STATUS>, C<GDK_DROP_START> or C<GDK_DROP_FINISHED>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item GdkDragContext $.context: the B<Gnome::Gdk3::DragContext> for the current DND operation.
=item UInt $.time: the time of the event in milliseconds.
=item C<Int()> $.x_root: the x coordinate of the pointer relative to the root of the screen, only set for C<GDK_DRAG_MOTION> and C<GDK_DROP_START>.
=item C<Int()> $.y_root: the y coordinate of the pointer relative to the root of the screen, only set for C<GDK_DRAG_MOTION> and C<GDK_DROP_START>.


=end pod

#TT:0:N-GdkEventDND:
class N-GdkEventDND is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has GdkDragContext $.context;
  has guint32 $.time;
  has gshort $.x_root;
  has gshort $.y_root;
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventTouchpadSwipe

Generated during touchpad swipe gestures.


=item GdkEventType $.type: the type of the event (C<GDK_TOUCHPAD_SWIPE>)
=item N-GObject $.window: the window which received the event
=item C<Int()> $.send_event: C<True> if the event was sent explicitly
=item C<Int()> $.phase: the current phase of the gesture
=item C<Int()> $.n_fingers: The number of fingers triggering the swipe
=item UInt $.time: the time of the event in milliseconds
=item C<Num()> $.x: The X coordinate of the pointer
=item C<Num()> $.y: The Y coordinate of the pointer
=item C<Num()> $.dx: Movement delta in the X axis of the swipe focal point
=item C<Num()> $.dy: Movement delta in the Y axis of the swipe focal point
=item C<Num()> $.x_root: The X coordinate of the pointer, relative to the root of the screen.
=item C<Num()> $.y_root: The Y coordinate of the pointer, relative to the root of the screen.
=item UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See B<Gnome::Gdk3::ModifierType>.


=end pod

#TT:0:N-GdkEventTouchpadSwipe:
class N-GdkEventTouchpadSwipe is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has gint8 $.phase;
  has gint8 $.n_fingers;
  has guint32 $.time;
  has gdouble $.x;
  has gdouble $.y;
  has gdouble $.dx;
  has gdouble $.dy;
  has gdouble $.x_root;
  has gdouble $.y_root;
  has guint $.state;

  method COERCE ( $no --> N-GdkEventTouchpadSwipe ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventTouchpadSwipe, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventTouchpadPinch

Generated during touchpad swipe gestures.


=item GdkEventType $.type: the type of the event (C<GDK_TOUCHPAD_PINCH>)
=item N-GObject $.window: the window which received the event
=item C<Int()> $.send_event: C<True> if the event was sent explicitly
=item C<Int()> $.phase: the current phase of the gesture
=item C<Int()> $.n_fingers: The number of fingers triggering the pinch
=item UInt $.time: the time of the event in milliseconds
=item C<Num()> $.x: The X coordinate of the pointer
=item C<Num()> $.y: The Y coordinate of the pointer
=item C<Num()> $.dx: Movement delta in the X axis of the swipe focal point
=item C<Num()> $.dy: Movement delta in the Y axis of the swipe focal point
=item C<Num()> $.angle_delta: The angle change in radians, negative angles denote counter-clockwise movements
=item C<Num()> $.scale: The current scale, relative to that at the time of the corresponding C<GDK_TOUCHPAD_GESTURE_PHASE_BEGIN> event
=item C<Num()> $.x_root: The X coordinate of the pointer, relative to the root of the screen.
=item C<Num()> $.y_root: The Y coordinate of the pointer, relative to the root of the screen.
=item UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See B<Gnome::Gdk3::ModifierType>.


=end pod

#TT:0:N-GdkEventTouchpadPinch:
class N-GdkEventTouchpadPinch is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has gint8 $.phase;
  has gint8 $.n_fingers;
  has guint32 $.time;
  has gdouble $.x;
  has gdouble $.y;
  has gdouble $.dx;
  has gdouble $.dy;
  has gdouble $.angle_delta;
  has gdouble $.scale;
  has gdouble $.x_root;
  has gdouble $.y_root;
  has guint $.state;

  method COERCE ( $no --> N-GdkEventTouchpadPinch ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventTouchpadPinch, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventPadButton

Generated during C<GDK_SOURCE_TABLET_PAD> button presses and releases.



=item GdkEventType $.type: the type of the event (C<GDK_PAD_BUTTON_PRESS> or C<GDK_PAD_BUTTON_RELEASE>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item UInt $.group: the pad group the button belongs to. A C<GDK_SOURCE_TABLET_PAD> device may have one or more groups containing a set of buttons/rings/strips each.
=item UInt $.button: The pad button that was pressed.
=item UInt $.mode: The current mode of I<group>. Different groups in a C<GDK_SOURCE_TABLET_PAD> device may have different current modes.


=end pod

#TT:0:N-GdkEventPadButton:
class N-GdkEventPadButton is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has guint32 $.time;
  has guint $.group;
  has guint $.button;
  has guint $.mode;

  method COERCE ( $no --> N-GdkEventPadButton ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventPadButton, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventPadAxis

Generated during C<GDK_SOURCE_TABLET_PAD> interaction with tactile sensors.



=item GdkEventType $.type: the type of the event (C<GDK_PAD_RING> or C<GDK_PAD_STRIP>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item UInt $.group: the pad group the ring/strip belongs to. A C<GDK_SOURCE_TABLET_PAD> device may have one or more groups containing a set of buttons/rings/strips each.
=item UInt $.index: number of strip/ring that was interacted. This number is 0-indexed.
=item UInt $.mode: The current mode of I<group>. Different groups in a C<GDK_SOURCE_TABLET_PAD> device may have different current modes.
=item C<Num()> $.value: The current value for the given axis.


=end pod

#TT:0:N-GdkEventPadAxis:
class N-GdkEventPadAxis is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has guint32 $.time;
  has guint $.group;
  has guint $.index;
  has guint $.mode;
  has gdouble $.value;

  method COERCE ( $no --> N-GdkEventPadAxis ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventPadAxis, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventPadGroupMode

Generated during C<GDK_SOURCE_TABLET_PAD> mode switches in a group.



=item GdkEventType $.type: the type of the event (C<GDK_PAD_GROUP_MODE>).
=item N-GObject $.window: the window which received the event.
=item C<Int()> $.send_event: C<True> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item UInt $.group: the pad group that is switching mode. A C<GDK_SOURCE_TABLET_PAD> device may have one or more groups containing a set of buttons/rings/strips each.
=item UInt $.mode: The new mode of I<group>. Different groups in a C<GDK_SOURCE_TABLET_PAD> device may have different current modes.


=end pod

#TT:0:N-GdkEventPadGroupMode:
class N-GdkEventPadGroupMode is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gint8 $.send_event;
  has guint32 $.time;
  has guint $.group;
  has guint $.mode;

  method COERCE ( $no --> N-GdkEventPadGroupMode ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEventPadGroupMode, $no)
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEvent

A C<N-GdkEvent> contains a union of all of the event types, and allows access to the data fields in a number of ways.

The event type is always the first field in all of the event types, and can always be accessed with the following code, no matter what type of event it is:

  method my-handler ( N-GdkEvent $event ) {
    if $event.type ~~ GDK_BUTTON_PRESS {
      my N-GdkEventButton $event-button := $event-button;
      ...
    }

    elsif $event.type ~~ GDK_KEY_RELEASE {
      my N-GdkEventKey $event-key := $event-key;
      ...
    }
  }

The event structures contain data specific to each type of event in GDK. The type is a union of all structures explained above.

=end pod

#TT:2:N-GdkEvent:*
class N-GdkEvent is repr('CUnion') is export {
  HAS N-GdkEventAny $.event-any;              # Deprecate
  HAS N-GdkEventAny $.any;
#  HAS N-GdkEventExpose $.expose;
#  HAS N-GdkEventVisibility $.visibility;     # Gdk deprecated since 3.12
  HAS N-GdkEventMotion $.event-motion;        # Deprecate
  HAS N-GdkEventMotion $.motion;
  HAS N-GdkEventButton $.event-button;        # Deprecate
  HAS N-GdkEventButton $.button;
#  HAS N-GdkEventTouch $.touch;
  HAS N-GdkEventScroll $.event-scroll;        # Deprecate
  HAS N-GdkEventScroll $.scroll;
  HAS N-GdkEventKey $.event-key;              # Deprecate
  HAS N-GdkEventKey $.key;
  HAS N-GdkEventCrossing $.event-crossing;    # Deprecate
  HAS N-GdkEventCrossing $.crossing;
  HAS N-GdkEventFocus $.event-focus;          # Deprecate
  HAS N-GdkEventFocus $.focus;
  HAS N-GdkEventConfigure $.event-configure;  # Deprecate
  HAS N-GdkEventConfigure $.configure;
#  HAS N-GdkEventProperty $.property;
#  HAS N-GdkEventSelection $.selection;
#  HAS N-GdkEventOwnerChange $.owner_change;
  HAS N-GdkEventProximity $.proximity;
#  HAS N-GdkEventDND $.dnd;
  HAS N-GdkEventWindowState $.window_state;
  HAS N-GdkEventSetting $.setting;
  HAS N-GdkEventGrabBroken $.grab_broken;
  HAS N-GdkEventTouchpadSwipe $.touchpad_swipe;
  HAS N-GdkEventTouchpadPinch $.touchpad_pinch;
  HAS N-GdkEventPadButton $.pad_button;
  HAS N-GdkEventPadAxis $.pad_axis;
  HAS N-GdkEventPadGroupMode $.pad_group_mode;

  method COERCE ( $no --> N-GdkEvent ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GdkEvent, $no)
  }
}

my constant GdkEvent is export = N-GdkEvent;

=begin pod
=head3 struct N-GdkEventExpose B<I<this event structure is not yet implemented>>
=head3 struct N-GdkEventTouch B<I<this event structure is not yet implemented>>
=head3 struct N-GdkEventSelection B<I<this event structure is not yet implemented>>
=head3 struct N-GdkEventProperty B<I<this event structure is not yet implemented>>
=head3 struct N-GdkEventOwnerChange B<I<this event structure is not yet implemented>>
=head3 struct N-GdkEventDND B<I<this event structure is not yet implemented>>

Fields C<$.event-any>, C<$.event-motion>, C<$.event-button>, C<$.event-scroll>, C<$.event-key>, C<$.event-crossing>, C<$.event-focus> and C<$.event-configure> are deprecated (version 0.19.2) and replaced by C<$.any>, C<m$.motion>, C<$.button>, C<$.scroll>, C<$.key>, C<$.crossing>, C<$.focus> and C<$.configure> resp. (Fields are removed in version 0.22.0 and higher)
=end pod

#`{{
#-------------------------------------------------------------------------------
my Array $map-type-to-field is export = [
  GDK_NOTHING = '';
  GDK_DELETE = '';
  GDK_DESTROY = '';
  GDK_EXPOSE = '';
  GDK_MOTION_NOTIFY = 'motion',
  GDK_BUTTON_PRESS = 'button',
  GDK_2BUTTON_PRESS = 'button',
  GDK_DOUBLE_BUTTON_PRESS = 'button',
  GDK_3BUTTON_PRESS = 'button',
  GDK_TRIPLE_BUTTON_PRESS = 'button',
  GDK_BUTTON_RELEASE = 'button',
  GDK_KEY_PRESS = 'key',
  GDK_KEY_RELEASE = 'key',
  GDK_ENTER_NOTIFY = '';
  GDK_LEAVE_NOTIFY = '';
  GDK_FOCUS_CHANGE = '';
  GDK_CONFIGURE = 'configure',
  GDK_MAP = '';
  GDK_UNMAP = '';
  GDK_PROPERTY_NOTIFY = '';
  GDK_SELECTION_CLEAR = '';
  GDK_SELECTION_REQUEST = '';
  GDK_SELECTION_NOTIFY = '';
  GDK_PROXIMITY_IN = '';
  GDK_PROXIMITY_OUT = '';
  GDK_DRAG_ENTER = '';
  GDK_DRAG_LEAVE = '';
  GDK_DRAG_MOTION = '';
  GDK_DRAG_STATUS = '';
  GDK_DROP_START = '';
  GDK_DROP_FINISHED = '';
  GDK_CLIENT_EVENT = '';
  GDK_VISIBILITY_NOTIFY = 'visibility',
  GDK_SCROLL = '';
  GDK_WINDOW_STATE = '';
  GDK_SETTING = '';
  GDK_OWNER_CHANGE = '';
  GDK_GRAB_BROKEN = '';
  GDK_DAMAGE = '';
  GDK_TOUCH_BEGIN = '';
  GDK_TOUCH_UPDATE = '';
  GDK_TOUCH_END = '';
  GDK_TOUCH_CANCEL = '';
  GDK_TOUCHPAD_SWIPE = 'touchpad_swipe',
  GDK_TOUCHPAD_PINCH = 'touchpad_pinch',
  GDK_PAD_BUTTON_PRESS = 'pad_button',
  GDK_PAD_BUTTON_RELEASE = 'pad_button',
  GDK_PAD_RING = '';
  GDK_PAD_STRIP = '';
  GDK_PAD_GROUP_MODE = 'pad_group_mode',
  GDK_EVENT_LAST = '';
);
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :type

Creates a new event of the given type. All fields are set to 0.

  multi method new ( GdkEventType :$type!, *%options )

=item $type; a B<Gnome::Gdk3::EventType>
=item %options: Any options to set fields in a N-GdkEvent object wrapped in this event object.


=head3 :get

When C<:get> is given (no value needed) it checks all open displays for a an event to process, to be processed on, fetching events from the windowing system if necessary. See C<Gnome::Gdk3::Display.get-event()>.

Gets the next B<Gnome::Gdk3::Event> to be processed, or, if no events are pending, the object becomes invalid. As always, this object should be freed with C<clear-object()>.

  multi method get ( :get! )


=head3 :native-object

  multi method new ( Gnome::GObject::Object :$native-object! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gdk3::Events' {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;
      if %options<type>:exists {
#        $no = _gdk_event_new(%options<type>);

##`{{
        my $type = %options<type>;

        given $type {
          when any( GDK_MOTION_NOTIFY, GDK_BUTTON_PRESS, GDK_2BUTTON_PRESS,
            GDK_DOUBLE_BUTTON_PRESS, GDK_3BUTTON_PRESS,
            GDK_TRIPLE_BUTTON_PRESS, GDK_BUTTON_RELEASE
          ) {
            $no = N-GdkEventButton.new(|%options);
#note "event $type: $no.gist()";
          }

          when any( GDK_KEY_PRESS, GDK_KEY_RELEASE) {
            $no = N-GdkEventKey.new(|%options);
          }

          when any( GDK_MOTION_NOTIFY) {
            $no = N-GdkEventMotion.new(|%options);
          }

          when any( GDK_SCROLL ) {
            $no = N-GdkEventScroll.new(|%options);
          }

          default {
            $no = _gdk_event_new(%options<type>);
#            die X::Gnome.new(:message("Type $type not supported"));
          }
        }
#}}
      }

      elsif %options<get>:exists {
        $no = _gdk_event_get;
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
        $no = _gdk_events_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GdkEvents');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gdk_events_$native-sub"); };
  try { $s = &::("gdk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gdk_' /;

  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
# ? no ref/unref for a variant type
method native-object-ref ( $n-native-object --> Any ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
#  _g_object_free($n-native-object)
  _gdk_event_free($n-native-object)
}

#`{{
#-------------------------------------------------------------------------------
# TM:0:copy:
=begin pod
=head2 copy

Copies a B<Gnome::Gdk3::Event>, copying or incrementing the reference count of the resources associated with it (e.g. B<Gnome::Gdk3::Window>’s and strings).

Returns: a copy of I<event>. The returned B<Gnome::Gdk3::Event> should be freed with C<gdk_event_free()>.

  method copy ( N-GdkEvent $event --> N-GdkEvent )

=item $event; a B<Gnome::Gdk3::Event>
=end pod

method copy ( N-GdkEvent $event --> N-GdkEvent ) {

  gdk_event_copy(
    self._get-native-object-no-reffing, $event
  )
}

sub gdk_event_copy (
  N-GdkEvent $event --> N-GdkEvent
) is native(&gdk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:_gdk_event_free:
=begin pod
=head2 free

Frees a B<Gnome::Gdk3::Event>, freeing or decrementing any resources associated with it. Note that this function should only be called with events returned from functions such as C<gdk_event_peek()>, C<gdk_event_get()>, C<gdk_event_copy()> and C<gdk_event_new()>.

  method free ( N-GdkEvent $event )

=item $event; a B<Gnome::Gdk3::Event>.
=end pod

method free ( N-GdkEvent $event ) {
  gdk_event_free(
    self._get-native-object-no-reffing, $event
  );
}
}}

sub _gdk_event_free (
  N-GdkEvent $event
) is native(&gdk-lib)
  is symbol('gdk_event_free')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gdk_event_get:
#`{{
=begin pod
=head2 get

Checks all open displays for a B<Gnome::Gdk3::Event> to process,to be processed on, fetching events from the windowing system if necessary. See C<Gnome::Gdk3::Display.get-event()>.

Returns: the next B<Gnome::Gdk3::Event> to be processed, or C<undefined> if no events are pending. The returned B<Gnome::Gdk3::Event> should be freed with C<gdk_event_free()>.

  method get ( --> N-GdkEvent )

=end pod

method get ( --> N-GdkEvent ) {
  gdk_event_get()
}
}}

sub _gdk_event_get (
   --> N-GdkEvent
) is native(&gdk-lib)
  is symbol('gdk_event_get')
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-angle:
=begin pod
=head2 get-angle

If this and the provided event contain X/Y information, this function will return a defined angle, the relative angle from this event to I<$event>. The rotation direction for positive angles is from the positive X axis towards the positive Y axis.

  method get-angle ( N-GdkEvent $event --> Num )

=item $event; the second B<Gnome::Gdk3::Event>
=end pod

method get-angle ( N-GdkEvent $event --> Num ) {
  my gdouble $angle;
  my Bool() $r = gdk_events_get_angle(
    self._get-native-object-no-reffing, $event, $angle
  );

  $r ?? $angle.Num !! Num
}

sub gdk_events_get_angle (
  N-GdkEvent $event1, N-GdkEvent $event2, gdouble $angle is rw --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-center:
=begin pod
=head2 get-center

If this and the provided event contain X/Y information, the center of both coordinates will be returned in a List. An empty list is returned otherwise.

  method get-center ( N-GdkEvent $event2 --> List )

=item $event; the second B<Gnome::Gdk3::Event>

List returns
=item Num; the X coordinate of the center
=item Num; the Y coordinate of the center
=end pod

method get-center ( N-GdkEvent $event, List ) {
  my gdouble $x;
  my gdouble $y;

  my Bool() $r = gdk_events_get_center(
    self._get-native-object-no-reffing, $event, $x, $y
  );

  $r ?? ( $x, $y) !! ( )
}

sub gdk_events_get_center (
  N-GdkEvent $event1, N-GdkEvent $event2, gdouble $x is rw, gdouble $y is rw
  --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-axis:
=begin pod
=head2 get-axis

Extract the axis value for a particular axis use from an event structure.

Returns: the axis value if the specified axis was found, otherwise an undefined C<Num>.

  method get-axis ( GdkAxisUse $axis_use --> Num )

=item $axis_use; the axis use to look for
=end pod

method get-axis ( GdkAxisUse $axis_use --> Num ) {
  my gdouble $value;
  my Bool() $r = gdk_event_get_axis(
    self._get-native-object-no-reffing, $axis_use.value, $value
  );

  $r ?? $value.Num !! Num
}

sub gdk_event_get_axis (
  N-GdkEvent $event, GEnum $axis_use, gdouble $value is rw --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-button:
=begin pod
=head2 get-button

Extract the button number from an event.

Returns: a defined C<Int> if the event delivered a button number.

  method get-button ( --> Int )

=end pod

method get-button ( --> Int ) {
  my guint $button;
  my Bool() $r = gdk_event_get_button(
    self._get-native-object-no-reffing, $button
  );

  $r ?? $button !! Int
}

sub gdk_event_get_button (
  N-GdkEvent $event, guint $button is rw --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-click-count:
=begin pod
=head2 get-click-count

Extracts the click count from an event.

Returns: a defined C<Int> if the event delivered a click count

  method get-click-count ( --> Int )

=end pod

method get-click-count ( --> Int ) {
  my guint $click_count;
  my Bool() $r = gdk_event_get_click_count(
    self._get-native-object-no-reffing, $click_count
  );

  $r ?? $click_count !! Int
}

sub gdk_event_get_click_count (
  N-GdkEvent $event, guint $click_count is rw --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-coords:
=begin pod
=head2 get-coords

Extract the event window relative x/y coordinates from an event.

Returns: C<True> if the event delivered event window coordinates

  method get-coords ( --> List )

List returns;
=item Num; event window x coordinate
=item Num; event window y coordinate
=end pod

method get-coords ( --> List ) {
  my gdouble $x_win;
  my gdouble $y_win;

  my Bool $r = gdk_event_get_coords(
    self._get-native-object-no-reffing, $x_win, $y_win
  ).Bool;

  ( $x_win, $y_win)
}

sub gdk_event_get_coords (
  N-GdkEvent $event, gdouble $x_win is rw, gdouble $y_win is rw --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-device:
=begin pod
=head2 get-device

If the event contains a “device” field, this function will return it, else it will return C<undefined> or an invalid object in the case of C<get-device-rk()>.

Returns: a B<Gnome::Gdk3::Device>, or C<undefined>.

  method get-device ( --> N-GObject )

=end pod

method get-device ( --> N-GObject ) {
  gdk_event_get_device(
    nativecast( N-GdkEvent, self._get-native-object-no-reffing)
  )
}

method get-device-rk ( --> Any ) {
  Gnome::N::deprecate(
    'get-device-rk', 'coercing from get-device',
    '0.19.2', '0.21.0'
  );

  self._wrap-native-type(
    'Gnome::Gdk3::Device',
    gdk_event_get_device(self._get-native-object-no-reffing)
  )
}

sub gdk_event_get_device (
  N-GdkEvent $event --> N-GObject
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-device-tool:
=begin pod
=head2 get-device-tool

If the event was generated by a device that supports different tools (eg. a tablet), this function will return a B<Gnome::Gdk3::DeviceTool> representing the tool that caused the event. Otherwise, C<undefined> will be returned or an invalid object in the case of C<get-device-tool-rk()>.

Note: the B<Gnome::Gdk3::DeviceTool><!-- -->s will be constant during the application lifetime, if settings must be stored persistently across runs, see C<gdk_device_tool_get_serial()>

Returns: The current device tool, or C<undefined>

  method get-device-tool ( --> N-GObject )

=end pod

method get-device-tool ( --> N-GObject ) {
  gdk_event_get_device_tool(self._get-native-object-no-reffing)
}

sub gdk_event_get_device_tool (
  N-GdkEvent $event --> N-GObject
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:get-distance:
=begin pod
=head2 get-distance

If this and the provided event  have X/Y information, the distance between both coordinates (as in a straight line going from this event to I<$event>) will be returned. Otherwise returned value is undefined.

  method get-distance ( N-GdkEvent $event --> Num )

=item $event; second B<Gnome::Gdk3::Event>
=end pod

method get-distance ( N-GdkEvent $event --> Num ) {
  my gdouble $distance;
  my Bool() $r = gdk_events_get_distance(
    self._get-native-object-no-reffing, $event, $distance
  );

  $r ?? $distance.Num !! Num
}

sub gdk_events_get_distance (
  N-GdkEvent $event1, N-GdkEvent $event2, gdouble $distance is rw --> gboolean
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-event-sequence:
=begin pod
=head2 get-event-sequence

If I<event> is of type C<GDK_TOUCH_BEGIN>, C<GDK_TOUCH_UPDATE>, C<GDK_TOUCH_END> or C<GDK_TOUCH_CANCEL>, returns the B<Gnome::Gdk3::EventSequence> to which the event belongs. Otherwise, return C<undefined>.

Returns: the event sequence that the event belongs to

  method get-event-sequence ( --> GdkEventSequence )

=end pod

method get-event-sequence ( --> GdkEventSequence ) {
  gdk_event_get_event_sequence(self._get-native-object-no-reffing)
}

sub gdk_event_get_event_sequence (
  N-GdkEvent $event --> GdkEventSequence
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:get-event-type:
=begin pod
=head2 get-event-type

Retrieves the type of the event.

Returns: a B<Gnome::Gdk3::EventType>

  method get-event-type ( --> GdkEventType )

=end pod

method get-event-type ( --> GdkEventType ) {
  GdkEventType(
    gdk_event_get_event_type(self._get-native-object-no-reffing)
  )
}

sub gdk_event_get_event_type (
  N-GdkEvent $event --> GEnum
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-keycode:
=begin pod
=head2 get-keycode

Extracts the hardware keycode from an event.

Also see C<get-scancode()>.

Returns: a defined keycode if the event delivered a hardware keycode, undefined otherwise.

  method get-keycode ( --> UInt )

=end pod

method get-keycode ( --> UInt ) {
  my guint16 $keycode;
  my Bool() $r = gdk_event_get_keycode(
    self._get-native-object-no-reffing, $keycode
  );

  $r ?? $keycode !! UInt
}

sub gdk_event_get_keycode (
  N-GdkEvent $event, guint16 $keycode is rw --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-keyval:
=begin pod
=head2 get-keyval

Extracts the keyval from an event.

Returns: a defined key symbol if the event delivered a key symbol, undefined otherwise.

  method get-keyval ( --> UInt )

=end pod

method get-keyval ( --> UInt ) {
  my guint $keyval;
  my Bool() $r = gdk_event_get_keyval(
    self._get-native-object-no-reffing, $keyval
  );

  $r ?? $keyval !! UInt
}

sub gdk_event_get_keyval (
  N-GdkEvent $event, guint $keyval is rw --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-pointer-emulated:
=begin pod
=head2 get-pointer-emulated

Returns whether this event is an 'emulated' pointer event (typically from a touch event), as opposed to a real one.

Returns: C<True> if this event is emulated

  method get-pointer-emulated ( --> Bool )

=end pod

method get-pointer-emulated ( --> Bool ) {
  gdk_event_get_pointer_emulated(self._get-native-object-no-reffing).Bool
}

sub gdk_event_get_pointer_emulated (
  N-GdkEvent $event --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-root-coords:
=begin pod
=head2 get-root-coords

Extract the root window relative x/y coordinates from an event.

Returns: a list if the event delivered root window coordinates. The list is empty if not.

  method get-root-coords ( --> List )

The List returns
=item Num; root window x coordinate
=item Num; root window y coordinate
=end pod

method get-root-coords (--> List ) {

  my gdouble $x_root;
  my gdouble $y_root;

  my Bool() $r = gdk_event_get_root_coords(
    self._get-native-object-no-reffing, $x_root, $y_root
  );

  $r ?? ( $x_root, $y_root) !! ()
}

sub gdk_event_get_root_coords (
  N-GdkEvent $event, gdouble $x_root is rw, gdouble $y_root is rw --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-scancode:
=begin pod
=head2 get-scancode

Gets the keyboard low-level scancode of a key event.

This is usually hardware_keycode. On Windows this is the high word of WM_KEY{DOWN,UP} lParam which contains the scancode and some extended flags.

Returns: The associated keyboard scancode or 0

  method get-scancode ( --> Int )

=end pod

method get-scancode ( --> Int ) {
  gdk_event_get_scancode(self._get-native-object-no-reffing)
}

sub gdk_event_get_scancode (
  N-GdkEvent $event --> gint
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-screen:
=begin pod
=head2 get-screen

Returns the screen for the event. The screen is typically the screen in any C<$event.any.window>`, but for events such as mouse events, it is the screen where the pointer was when the event occurs - that is, the screen which has the root window to which C<$event.motion.x_root> and C<$event.motion.y_root> are relative.

Returns: the screen for the event

  method get-screen ( --> N-GObject )

=item $event; a B<Gnome::Gdk3::Event>
=end pod

method get-screen ( --> N-GObject ) {
  gdk_event_get_screen(self._get-native-object-no-reffing)
}

method get-screen-rk ( --> Any ) {
  Gnome::N::deprecate(
    'get-screen-rk', 'coercing from get-screen',
    '0.19.2', '0.21.0'
  );

  self._wrap-native-type(
    'Gnome::Gdk3::Screen',
    gdk_event_get_screen(self._get-native-object-no-reffing)
  )
}

sub gdk_event_get_screen (
  N-GdkEvent $event --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-scroll-deltas:
=begin pod
=head2 get-scroll-deltas

Retrieves the scroll deltas from this event

See also: C<gdk_event_get_scroll_direction()>

Returns: A List holding the values if the event contains smooth scroll information and an empty List otherwise.

  method get-scroll-deltas ( --> List )

The List returns;
=item Num; X delta
=item Num; Y delta
=end pod

method get-scroll-deltas ( --> List ) {
  my gdouble $delta_x;
  my gdouble $delta_y;
  my Bool() $r = gdk_event_get_scroll_deltas(
    self._get-native-object-no-reffing, $delta_x, $delta_y
  );

  $r ?? ( $delta_x, $delta_y) !! ()
}

sub gdk_event_get_scroll_deltas (
  N-GdkEvent $event, gdouble $delta_x is rw, gdouble $delta_y is rw --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-scroll-direction:
=begin pod
=head2 get-scroll-direction

Extracts the scroll direction from an event.

If I<event> is not of type C<GDK_SCROLL>, the contents of I<direction> are undefined.

If you wish to handle both discrete and smooth scrolling, you should check the return value of this function, or of C<get-scroll-deltas()>; for instance:

  # Handle discrete scrolling with a known constant delta;
  constant Num $delta = 12e0;

  my GdkScrollDirection $direction;
  my Num $vscroll_factor = 0e0;
  my Num ( $x_scroll, $y_scroll);

  if ?( $direction = $event.get-scroll-direction ) {
    with $direction {
      when GDK_SCROLL_UP {
        $vscroll_factor = -$delta;
      }

      when GDK_SCROLL_DOWN {
        $vscroll_factor = $delta;
      }

      default {
        # no scrolling
      }
    }
  }

  elsif my List $deltas = $event.get-scroll-deltas {
    # Handle smooth scrolling directly
    $vscroll_factor = $deltas[1];
  }


Returns: a defined GdkScrollDirection value if the event delivered a scroll direction and undefined otherwise

  method get-scroll-direction ( --> GdkScrollDirection )

=end pod

method get-scroll-direction ( --> GdkScrollDirection ) {
  my GEnum $direction;
  my Bool() $r = gdk_event_get_scroll_direction(
    self._get-native-object-no-reffing, $direction
  );

  %$r ?? GdkScrollDirection($direction) !! GdkScrollDirection
}

sub gdk_event_get_scroll_direction (
  N-GdkEvent $event, GEnum $direction --> gboolean
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-seat:
=begin pod
=head2 get-seat

Returns the B<Gnome::Gdk3::Seat> this event was generated for.

  method get-seat ( --> N-GObject )

=end pod

method get-seat ( --> N-GObject ) {
  gdk_event_get_seat(self._get-native-object-no-reffing)
}

sub gdk_event_get_seat (
  N-GdkEvent $event --> N-GObject
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:get-show-events:
=begin pod
=head2 get-show-events

Gets whether event debugging output is enabled.

Returns: C<True> if event debugging output is enabled.

  method get-show-events ( --> Bool )

=end pod

method get-show-events ( --> Bool ) {
  gdk_get_show_events.Bool
}

sub gdk_get_show_events (
   --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-source-device:
=begin pod
=head2 get-source-device

This function returns the hardware secondary B<Gnome::Gdk3::Device> that has triggered the event, falling back to the virtual primary device (as in C<get-device()>) if the event wasn’t caused by interaction with a hardware device.

This may happen for example in synthesized crossing events after a B<Gnome::Gdk3::Window> updates its geometry or a grab is acquired/released.

If the event does not contain a device field, this function will return C<undefined> or an invalid object in the case of C<get-source-device-rk()>.

Returns: a B<Gnome::Gdk3::Device>, or C<undefined>.

  method get-source-device ( --> N-GObject )

=item $event; a B<Gnome::Gdk3::Event>
=end pod

method get-source-device ( --> N-GObject ) {
  gdk_event_get_source_device(self._get-native-object-no-reffing)
}

method get-source-device-rk ( --> Any ) {
  Gnome::N::deprecate(
    'get-source-device-rk', 'coercing from get-source-device',
    '0.19.2', '0.21.0'
  );

  self._wrap-native-type(
    'Gnome::Gdk3::Device',
    gdk_event_get_source_device(self._get-native-object-no-reffing)
  )
}

sub gdk_event_get_source_device (
  N-GdkEvent $event --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-state:
=begin pod
=head2 get-state

If the event contains a “state” field, returns that field.

Returns a defined state value if there was a state field in the event. Undefined otherwise.

=comment I<event> may be C<undefined>, in which case it’s treated as if the event had no state field.

  method get-state ( --> GdkModifierType )

=end pod

method get-state ( --> GdkModifierType ) {
  my GEnum $state;
  my Bool() $r = gdk_event_get_state(
    self._get-native-object-no-reffing, $state
  );

  $r ?? GdkModifierType($state) !! GdkModifierType
}

sub gdk_event_get_state (
  N-GdkEvent $event, GEnum $state --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-time:
=begin pod
=head2 get-time

Returns the time stamp from I<event>, if there is one; otherwise returns the current time.

Returns: time stamp field from this event

  method get-time ( --> UInt )

=end pod

method get-time ( --> UInt ) {
  gdk_event_get_time(self._get-native-object-no-reffing)
}

sub gdk_event_get_time (
  N-GdkEvent $event --> guint32
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-window:
=begin pod
=head2 get-window

Extracts the B<Gnome::Gdk3::Window> associated with an event.

  method get-window ( --> N-GObject )

=end pod

method get-window ( --> N-GObject ) {
  gdk_event_get_window(
    nativecast( N-GdkEvent, self._get-native-object-no-reffing)
  )
}

method get-window-rk ( --> Any ) {
  Gnome::N::deprecate(
    'get-window-rk', 'coercing from get-window',
    '0.19.2', '0.21.0'
  );

  self._wrap-native-type(
    'Gnome::Gdk3::Window',
    gdk_event_get_window( self._get-native-object-no-reffing)
  )
}

sub gdk_event_get_window (
  N-GdkEvent $event --> N-GObject
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:handler-set:
=begin pod
=head2 handler-set

Sets the function to call to handle all events from GDK.

Note that GTK+ uses this to install its own event handler, so it is usually not useful for GTK+ applications. (Although an application can call this function then call C<gtk_main_do_event()> to pass events to GTK+.)

  method handler-set ( GdkEventFunc $func, Pointer $data, GDestroyNotify $notify )

=item $func; the function to call to handle events from GDK.
=item $data; user data to pass to the function.
=item $notify; the function to call when the handler function is removed, i.e. when C<gdk_event_handler_set()> is called with another event handler.
=end pod

method handler-set ( GdkEventFunc $func, Pointer $data, GDestroyNotify $notify ) {

  gdk_event_handler_set(
    $func, $data, $notify
  );
}

sub gdk_event_handler_set (
  GdkEventFunc $func, gpointer $data, GDestroyNotify $notify
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:is-scroll-stop-event:
=begin pod
=head2 is-scroll-stop-event

Check whether a scroll event is a stop scroll event. Scroll sequences with smooth scroll information may provide a stop scroll event once the interaction with the device finishes, e.g. by lifting a finger. This stop scroll event is the signal that a widget may trigger kinetic scrolling based on the current velocity.

Stop scroll events always have a delta of 0/0.

  method is-scroll-stop-event ( --> Bool )

=end pod

method is-scroll-stop-event ( --> Bool ) {
  gdk_event_is_scroll_stop_event(self._get-native-object-no-reffing).Bool
}

sub gdk_event_is_scroll_stop_event (
  N-GdkEvent $event --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gdk_event_new:
#`{{
=begin pod
=head2 gdk-event-new

Creates a new event of the given type. All fields are set to 0.

Returns: a newly-allocated B<Gnome::Gdk3::Event>. The returned B<Gnome::Gdk3::Event> should be freed with C<gdk_event_free()>.

  method gdk-event-new ( GdkEventType $type --> N-GdkEvent )

=item $type; a B<Gnome::Gdk3::EventType>
=end pod

method gdk-event-new ( --> N-GdkEvent ) {
  gdk_event_new($type)
}
}}
sub _gdk_event_new (
  GEnum $type --> N-GdkEvent
) is native(&gdk-lib)
  is symbol('gdk_event_new')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:peek:
=begin pod
=head2 peek

If there is an event waiting in the event queue of some open display, returns a copy of it. See C<Gnome::Gdk3::Display.peek-event()>.

Returns: a copy of the first B<Gnome::Gdk3::Event> on some event queue, or C<undefined> if no events are in any queues. The returned B<Gnome::Gdk3::Event> should be freed with C<gdk_event_free()>.

  method peek ( --> N-GdkEvent )

=end pod

method peek ( --> N-GdkEvent ) {
  gdk_event_peek(self._get-native-object-no-reffing)
}

sub gdk_event_peek (
   --> N-GdkEvent
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:pending:
=begin pod
=head2 pending

Checks if any events are ready to be processed for any display.

Returns: C<True> if any events are pending.

  method pending ( --> Bool )

=end pod

method pending ( --> Bool ) {
  gdk_events_pending.Bool
}

sub gdk_events_pending (
   --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:put:
=begin pod
=head2 put

Appends a copy of this event onto the front of the event queue for C<$event.any.window>’s display, or the default event queue if C<$event.any.window> is C<undefined>. See C<Gnome::Gdk3::Display.put-event()>.

  method put ( )

=end pod

method put ( N-GdkEvent $event ) {
  gdk_event_put( self._get-native-object-no-reffing);
}

sub gdk_event_put (
  N-GdkEvent $event
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:request-motions:
=begin pod
=head2 request-motions

Request more motion notifies if this event is a motion notify hint event.

This function should be used instead of C<Gnome::Gdk3::Window.get-pointer()> to request further motion notifies, because it also works for extension events where motion notifies are provided for devices other than the core pointer. Coordinate extraction, processing and requesting more motion events from a C<GDK_MOTION_NOTIFY> event usually works like this:

=begin comment

==>> TODO A POD Bug???
= begin code
  my Gnome::Gdk3::Event $e .= new(:type(GDK_MOTION_NOTIFY));
  …

  # Motion_event handler
  my $x = $e.x;
  my $y = $e.y;

  # Handle (x,y) motion. Handles .is-hint() events
  $event.request-motions;
= end code

=end comment

  method request-motions ( )

=end pod

method request-motions ( ) {
  gdk_event_request_motions(self._get-native-object-no-reffing);
}

sub gdk_event_request_motions (
  N-GdkEventMotion $event
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-device:
=begin pod
=head2 set-device

Sets the device for I<event> to I<device>. The event must have been allocated by GTK+, for instance, by C<copy()>.

  method set-device ( N-GObject() $device )

=item $device; a B<Gnome::Gdk3::Device>
=end pod

method set-device ( N-GObject() $device ) {
  gdk_event_set_device( self._get-native-object-no-reffing, $device);
}

sub gdk_event_set_device (
  N-GdkEvent $event, N-GObject $device
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-device-tool:
=begin pod
=head2 set-device-tool

Sets the device tool for this event, should be rarely used.

  method set-device-tool ( N-GObject() $tool )

=item $tool; tool to set on the event, or C<undefined>
=end pod

method set-device-tool ( N-GObject() $tool ) {
  gdk_event_set_device_tool( self._get-native-object-no-reffing, $tool);
}

sub gdk_event_set_device_tool (
  N-GdkEvent $event, N-GObject $tool
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:set-screen:
=begin pod
=head2 set-screen

Sets the screen for I<event> to I<screen>. The event must have been allocated by GTK+, for instance, by C<gdk_event_copy()>.

  method set-screen ( N-GObject() $screen )

=item $screen; a B<Gnome::Gdk3::Screen>
=end pod

method set-screen ( N-GObject() $screen ) {
  gdk_event_set_screen( self._get-native-object-no-reffing, $screen);
}

sub gdk_event_set_screen (
  N-GdkEvent $event, N-GObject $screen
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-show-events:
=begin pod
=head2 set-show-events

Sets whether a trace of received events is output. Note that GTK+ must be compiled with debugging (that is, configured using the `--enable-debug` option) to use this option.

  method set-show-events ( Bool $show_events )

=item $show_events; C<True> to output event debugging information.
=end pod

method set-show-events ( Bool $show_events ) {
  gdk_set_show_events($show_events);
}

sub gdk_set_show_events (
  gboolean $show_events
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-source-device:
=begin pod
=head2 set-source-device

Sets the slave device for I<event> to I<device>.

The event must have been allocated by GTK+, for instance by C<gdk_event_copy()>.

  method set-source-device ( N-GObject() $device )

=item $device; a B<Gnome::Gdk3::Device>
=end pod

method set-source-device ( N-GObject() $device ) {
  gdk_event_set_source_device( self._get-native-object-no-reffing, $device);
}

sub gdk_event_set_source_device (
  N-GdkEvent $event, N-GObject $device
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk-setting-get:
=begin pod
=head2 setting-get

Obtains a desktop-wide setting, such as the double-click time, for the default screen. See C<Gnome::Gdk3::Screen.get_setting()>.

Returns: C<True> if the setting existed and a value was stored in I<value>, C<False> otherwise.

  method setting-get ( Str $name, N-GObject() $value --> Bool )

=item $name; the name of the setting.
=item $value; location to store the value of the setting.
=end pod

method setting-get ( Str $name, N-GObject() $value --> Bool ) {
  gdk_setting_get( $name, $value).Bool
}

sub gdk_setting_get (
  gchar-ptr $name, N-GObject $value --> gboolean
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:triggers-context-menu:
=begin pod
=head2 triggers-context-menu

This function returns whether this event (a GdkEventButton type) should trigger a context menu, according to platform conventions. The right mouse button always triggers context menus. Additionally, if C<gdk_keymap_get_modifier_mask()> returns a non-0 mask for C<GDK_MODIFIER_INTENT_CONTEXT_MENU>, then the left mouse button will also trigger a context menu if this modifier is pressed.

This function should always be used instead of simply checking for event->button == C<GDK_BUTTON_SECONDARY>.

Returns: C<True> if the event should trigger a context menu.

  method triggers-context-menu ( --> Bool )

=end pod

method triggers-context-menu ( --> Bool ) {
  gdk_event_triggers_context_menu(self._get-native-object-no-reffing).Bool
}

sub gdk_event_triggers_context_menu (
  N-GdkEvent $event --> gboolean
) is native(&gdk-lib)
  { * }
