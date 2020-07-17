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

=head2 Example

  my Gnome::Gtk3::Window $top-window .= new;
  $top-window.set-title('Hello GTK!');
  # ... etcetera ...

  # Define a handler method
  method handle-keypress ( N-GdkEvent $event, :$widget ) {
    if $event.event-any.type ~~ GDK_KEY_PRESS {
      my N-GdkEventKey $event-key = $event;
      if $event.event-key.keyval eq 's' {
        # key 's' pressed, stop process ...
      }
    }
  }

  # And register the signal handler for a window event
  $top-window.register-signal( self, 'handle-keypress', 'key-press-event');

If the handler handles only one event type, the method can also be defined as

  method handle-keypress ( N-GdkEventKey $event-key, :$widget ) {
    if $event-key.type ~~ GDK_KEY_PRESS and $event-key.keyval eq 's' {
      # key 's' pressed, stop process ...
    }
  }

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gdk3::Types;

#-------------------------------------------------------------------------------
# https://developer.gnome.org/gdk3/stable/gdk3-Event-Structures.html
# https://developer.gnome.org/gdk3/stable/gdk3-Events.html
unit class Gnome::Gdk3::Events:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types

=head2 enum GdkFilterReturn

Specifies the result of applying a C<Gnome::Gdk3::FilterFunc> to a native event.

=item GDK_FILTER_CONTINUE: event not handled, continue processing.
=item GDK_FILTER_TRANSLATE: native event translated into a GDK event and stored in the `event` structure that was passed in.
=item GDK_FILTER_REMOVE: event handled, terminate processing.

=end pod

#TE:0:GdkFilterReturn:
enum GdkFilterReturn is export <
  GDK_FILTER_CONTINUE GDK_FILTER_TRANSLATE GDK_FILTER_REMOVE
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 Enum GdkEventType

Specifies the type of the event.

Do not confuse these events with the signals that GTK+ widgets emit. Although many of these events result in corresponding signals being emitted, the events are often transformed or filtered along the way.

In some language bindings, the values C<GDK_2BUTTON_PRESS> andC<GDK_3BUTTON_PRESS> would translate into something syntactically invalid (eg `C<Gnome::Gdk3::.EventType>.2ButtonPress`, where a symbol is not allowed to start with a number). In that case, the aliases C<GDK_DOUBLE_BUTTON_PRESS> and C<GDK_TRIPLE_BUTTON_PRESS> can be used instead.

=item GDK_NOTHING; a special code to indicate a null event.
=item GDK_DELETE; the window manager has requested that the toplevel window be hidden or destroyed, usually when the user clicks on a special icon in the title bar.
=item GDK_DESTROY; the window has been destroyed.
=item GDK_EXPOSE; all or part of the window has become visible and needs to be redrawn.
=item GDK_MOTION_NOTIFY; the pointer (usually a mouse) has moved.
=item GDK_BUTTON_PRESS; a mouse button has been pressed.
=item GDK_2BUTTON_PRESS; a mouse button has been double-clicked (clicked twice within a short period of time). Note that each click also generates a GDK_BUTTON_PRESS event.
=item GDK_DOUBLE_BUTTON_PRESS; alias for GDK_2BUTTON_PRESS, added in 3.6.
=item GDK_3BUTTON_PRESS; a mouse button has been clicked 3 times in a short period of time. Note that each click also generates a GDK_BUTTON_PRESS event.
=item GDK_TRIPLE_BUTTON_PRESS; alias for GDK_3BUTTON_PRESS, added in 3.6.
=item GDK_BUTTON_RELEASE; a mouse button has been released.
=item GDK_KEY_PRESS; a key has been pressed.
=item GDK_KEY_RELEASE; a key has been released.
=item GDK_ENTER_NOTIFY; the pointer has entered the window.
=item GDK_LEAVE_NOTIFY; the pointer has left the window.
=item GDK_FOCUS_CHANGE; the keyboard focus has entered or left the window.
=item GDK_CONFIGURE; the size, position or stacking order of the window has changed. Note that GTK+ discards these events for GDK_WINDOW_CHILD windows.
=item GDK_MAP; the window has been mapped.
=item GDK_UNMAP; the window has been unmapped.
=item GDK_PROPERTY_NOTIFY; a property on the window has been changed or deleted.
=item GDK_SELECTION_CLEAR; the application has lost ownership of a selection.
=item GDK_SELECTION_REQUEST; another application has requested a selection.
=item GDK_SELECTION_NOTIFY; a selection has been received.
=item GDK_PROXIMITY_IN; an input device has moved into contact with a sensing surface (e.g. a touchscreen or graphics tablet).
=item GDK_PROXIMITY_OUT; an input device has moved out of contact with a sensing surface.
=item GDK_DRAG_ENTER; the mouse has entered the window while a drag is in progress.
=item GDK_DRAG_LEAVE; the mouse has left the window while a drag is in progress.
=item GDK_DRAG_MOTION; the mouse has moved in the window while a drag is in progress.
=item GDK_DRAG_STATUS; the status of the drag operation initiated by the window has changed.
=item GDK_DROP_START; a drop operation onto the window has started.
=item GDK_DROP_FINISHED; the drop operation initiated by the window has completed.
=item GDK_CLIENT_EVENT; a message has been received from another application.
=item GDK_VISIBILITY_NOTIFY; the window visibility status has changed.
=item GDK_SCROLL; the scroll wheel was turned.
=item GDK_WINDOW_STATE; the state of a window has changed. See GdkWindowState for the possible window states.
=item GDK_SETTING. a setting has been modified.
=item GDK_OWNER_CHANGE; the owner of a selection has changed. This event type was added in 2.6
=item GDK_GRAB_BROKEN; a pointer or keyboard grab was broken. This event type was added in 2.8.
=item GDK_DAMAGE; the content of the window has been changed. This event type was added in 2.14.
=item GDK_TOUCH_BEGIN; A new touch event sequence has just started. This event type was added in 3.4.
=item GDK_TOUCH_UPDATE; A touch event sequence has been updated. This event type was added in 3.4.
=item GDK_TOUCH_END; A touch event sequence has finished. This event type was added in 3.4.
=item GDK_TOUCH_CANCEL; A touch event sequence has been canceled. This event type was added in 3.4.
=item GDK_TOUCHPAD_SWIPE; A touchpad swipe gesture event, the current state is determined by its phase field. This event type was added in 3.18.
=item GDK_TOUCHPAD_PINCH; A touchpad pinch gesture event, the current state is determined by its phase field. This event type was added in 3.18.
=item GDK_PAD_BUTTON_PRESS; A tablet pad button press event. This event type was added in 3.22.
=item GDK_PAD_BUTTON_RELEASE; A tablet pad button release event. This event type was added in 3.22.
=item GDK_PAD_RING; A tablet pad axis event from a "ring". This event type was added in 3.22.
=item GDK_PAD_STRIP; A tablet pad axis event from a "strip". This event type was added in 3.22.
=item GDK_PAD_GROUP_MODE; A tablet pad group mode change. This event type was added in 3.22.
=item GDK_EVENT_LAST; Marks the end of the GdkEventType enumeration. Added in 2.18
=end pod

# enum size = int because of use of -1.

#TE:0:GdkEventType:
enum GdkEventType is export (
  'GDK_NOTHING'		=> -1,
  'GDK_DELETE'		=> 0,
  'GDK_DESTROY'		=> 1,
  'GDK_EXPOSE'		=> 2,
  'GDK_MOTION_NOTIFY'	=> 3,
  'GDK_BUTTON_PRESS'	=> 4,
  'GDK_2BUTTON_PRESS'	=> 5,
  'GDK_DOUBLE_BUTTON_PRESS' => 5,
  'GDK_3BUTTON_PRESS'	=> 6,
  'GDK_TRIPLE_BUTTON_PRESS' => 6,
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
  'GDK_EVENT_LAST'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkVisibilityState

Specifies the visiblity status of a window for a C<Gnome::Gdk3::EventVisibility>.

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
=head2 enum GdkTouchpadGesturePhase

Specifies the current state of a touchpad gesture. All gestures are
guaranteed to begin with an event with phase C<GDK_TOUCHPAD_GESTURE_PHASE_BEGIN>,
followed by 0 or several events with phase C<GDK_TOUCHPAD_GESTURE_PHASE_UPDATE>.

A finished gesture may have 2 possible outcomes, an event with phase
C<GDK_TOUCHPAD_GESTURE_PHASE_END> will be emitted when the gesture is
considered successful, this should be used as the hint to perform any
permanent changes.
Cancelled gestures may be so for a variety of reasons, due to hardware
or the compositor, or due to the gesture recognition layers hinting the
gesture did not finish resolutely (eg. a 3rd finger being added during
a pinch gesture). In these cases, the last event will report the phase
C<GDK_TOUCHPAD_GESTURE_PHASE_CANCEL>, this should be used as a hint
to undo any visible/permanent changes that were done throughout the
progress of the gesture.

See also C<Gnome::Gdk3::EventTouchpadSwipe> and C<Gnome::Gdk3::EventTouchpadPinch>.



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
=head2 enum GdkScrollDirection

Specifies the direction for C<Gnome::Gdk3::EventScroll>.


=item GDK_SCROLL_UP: the window is scrolled up.
=item GDK_SCROLL_DOWN: the window is scrolled down.
=item GDK_SCROLL_LEFT: the window is scrolled to the left.
=item GDK_SCROLL_RIGHT: the window is scrolled to the right.
=item GDK_SCROLL_SMOOTH: the scrolling is determined by the delta values in C<Gnome::Gdk3::EventScroll>. See C<gdk_event_get_scroll_deltas()>. Since: 3.4


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
=head2 enum GdkNotifyType

Specifies the kind of crossing for C<Gnome::Gdk3::EventCrossing>.

See the X11 protocol specification of LeaveNotify for
full details of crossing event generation.


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
=head2 enum GdkCrossingMode

Specifies the crossing mode for C<Gnome::Gdk3::EventCrossing>.


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
=head2 enum GdkPropertyState

Specifies the type of a property change for a C<Gnome::Gdk3::EventProperty>.


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
=item GDK_WINDOW_STATE_TILED: the window is in a tiled state, Since 3.10. Since 3.22.23, this is deprecated in favor of per-edge information.
=item GDK_WINDOW_STATE_TOP_TILED: whether the top edge is tiled, Since 3.22.23
=item GDK_WINDOW_STATE_TOP_RESIZABLE: whether the top edge is resizable, Since 3.22.23
=item GDK_WINDOW_STATE_RIGHT_TILED: whether the right edge is tiled, Since 3.22.23
=item GDK_WINDOW_STATE_RIGHT_RESIZABLE: whether the right edge is resizable, Since 3.22.23
=item GDK_WINDOW_STATE_BOTTOM_TILED: whether the bottom edge is tiled, Since 3.22.23
=item GDK_WINDOW_STATE_BOTTOM_RESIZABLE: whether the bottom edge is resizable, Since 3.22.23
=item GDK_WINDOW_STATE_LEFT_TILED: whether the left edge is tiled, Since 3.22.23
=item GDK_WINDOW_STATE_LEFT_RESIZABLE: whether the left edge is resizable, Since 3.22.23


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
=head2 enum GdkSettingAction

Specifies the kind of modification applied to a setting in a
C<Gnome::Gdk3::EventSetting>.


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
=head1 Types

=head2 class N-GdkEventAny

Contains the fields which are common to all event structs.
Any event pointer can safely be cast to a pointer to a C<Gnome::Gdk3::EventAny> to
access these fields.


=item C<GdkEventType> $.type: the type of the event.
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.


=end pod

#TT:0:N-GdkEventAny:
class N-GdkEventAny is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
}

my constant GdkEventAny is export = N-GdkEventAny;

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventExpose

Generated when all or part of a window becomes visible and needs to be
redrawn.


=item C<GdkEventType> $.type: the type of the event (C<GDK_EXPOSE> or C<GDK_DAMAGE>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item N-GObject $.area: bounding box of I<region>.
=item cairo_region_t $.region: the region that needs to be redrawn.
=item ___count: the number of contiguous C<GDK_EXPOSE> events following this one. The only use for this is “exposure compression”, i.e. handling all contiguous C<GDK_EXPOSE> events in one go, though GDK performs some exposure compression so this is not normally needed.


=end pod

#TT:0:N-GdkEventExpose:
class N-GdkEventExpose is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has N-GObject $.area;
  has cairo_region_t $.region;
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventVisibility

Generated when the window visibility status has changed.

Deprecated: 3.12: Modern composited windowing systems with pervasive
transparency make it impossible to track the visibility of a window
reliably, so this event can not be guaranteed to provide useful
information.


=item C<GdkEventType> $.type: the type of the event (C<GDK_VISIBILITY_NOTIFY>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item C<Gdk3VisibilityState> $.state: the new visibility state (C<GDK_VISIBILITY_FULLY_OBSCURED>, C<GDK_VISIBILITY_PARTIAL> or C<GDK_VISIBILITY_UNOBSCURED>).


=end pod

#TT:0:N-GdkEventVisibility:
class N-GdkEventVisibility is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has int32 $.state;
}

my constant GdkEventVisibility is export = N-GdkEventVisibility;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventMotion

Generated when the pointer moves.


=item C<GdkEventType> $.type: the type of the event.
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item Num $.x: the x coordinate of the pointer relative to the window.
=item Num $.y: the y coordinate of the pointer relative to the window.
=item Num $.axes: I<x>, I<y> translated to the axes of I<device>, or C<Any> if I<device> is the mouse.
=item UInt $.state: (type C<Gnome::Gdk3::ModifierType>): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See C<Gnome::Gdk3::ModifierType>.
=item Int $.is_hint: set to 1 if this event is just a hint, see the C<GDK_POINTER_MOTION_HINT_MASK> value of C<Gnome::Gdk3::EventMask>.
=item N-GObject $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.
=item Num $.x_root: the x coordinate of the pointer relative to the root of the screen.
=item Num $.y_root: the y coordinate of the pointer relative to the root of the screen.


=end pod

#TT:0:N-GdkEventMotion:
class N-GdkEventMotion is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has num64 $.axes;
  has uint32 $.state;
  has int16 $.is_hint;
  has N-GObject $.device;
  has num64 $.x_root;
  has num64 $.y_root;
}

my constant GdkEventMotion is export = N-GdkEventMotion;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventButton

Used for button press and button release events. The
I<type> field will be one of C<GDK_BUTTON_PRESS>,
C<GDK_2BUTTON_PRESS>, C<GDK_3BUTTON_PRESS> or C<GDK_BUTTON_RELEASE>,

Double and triple-clicks result in a sequence of events being received.
For double-clicks the order of events will be:

- C<GDK_BUTTON_PRESS>
- C<GDK_BUTTON_RELEASE>
- C<GDK_BUTTON_PRESS>
- C<GDK_2BUTTON_PRESS>
- C<GDK_BUTTON_RELEASE>

Note that the first click is received just like a normal
button press, while the second click results in a C<GDK_2BUTTON_PRESS>
being received just after the C<GDK_BUTTON_PRESS>.

Triple-clicks are very similar to double-clicks, except that
C<GDK_3BUTTON_PRESS> is inserted after the third click. The order of the
events is:

- C<GDK_BUTTON_PRESS>
- C<GDK_BUTTON_RELEASE>
- C<GDK_BUTTON_PRESS>
- C<GDK_2BUTTON_PRESS>
- C<GDK_BUTTON_RELEASE>
- C<GDK_BUTTON_PRESS>
- C<GDK_3BUTTON_PRESS>
- C<GDK_BUTTON_RELEASE>

For a double click to occur, the second button press must occur within
1/4 of a second of the first. For a triple click to occur, the third
button press must also occur within 1/2 second of the first button press.


=item C<GdkEventType> $.type: the type of the event (C<GDK_BUTTON_PRESS>, C<GDK_2BUTTON_PRESS>, C<GDK_3BUTTON_PRESS> or C<GDK_BUTTON_RELEASE>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item Num $.x: the x coordinate of the pointer relative to the window.
=item Num $.y: the y coordinate of the pointer relative to the window.
=item Num $.axes: I<x>, I<y> translated to the axes of I<device>, or C<Any> if I<device> is the mouse.
=item UInt $.state: (type C<Gnome::Gdk3::ModifierType>): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See C<Gnome::Gdk3::ModifierType>.
=item UInt $.button: the button which was pressed or released, numbered from 1 to 5. Normally button 1 is the left mouse button, 2 is the middle button, and 3 is the right button. On 2-button mice, the middle button can often be simulated by pressing both mouse buttons together.
=item N-GObject $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.
=item Num $.x_root: the x coordinate of the pointer relative to the root of the screen.
=item Num $.y_root: the y coordinate of the pointer relative to the root of the screen.


=end pod

#TT:0:N-GdkEventButton:
class N-GdkEventButton is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has num64 $.axes;
  has uint32 $.state;
  has uint32 $.button;
  has N-GObject $.device;
  has num64 $.x_root;
  has num64 $.y_root;
}

my constant GdkEventButton is export = N-GdkEventButton;

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


=item C<GdkEventType> $.type: the type of the event (C<GDK_TOUCH_BEGIN>, C<GDK_TOUCH_UPDATE>, C<GDK_TOUCH_END>, C<GDK_TOUCH_CANCEL>)
=item N-GObject $.window: the window which received the event
=item Int $.send_event: C<1> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item Num $.x: the x coordinate of the pointer relative to the window
=item Num $.y: the y coordinate of the pointer relative to the window
=item Num $.axes: I<x>, I<y> translated to the axes of I<device>, or C<Any> if I<device> is the mouse
=item UInt $.state: (type C<Gnome::Gdk3::ModifierType>): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See C<Gnome::Gdk3::ModifierType>
=item C<Gnome::Gdk3::EventSequence> $.sequence: the event sequence that the event belongs to
=item Int $.emulating_pointer: whether the event should be used for emulating pointer event
=item N-GObject $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.
=item Num $.x_root: the x coordinate of the pointer relative to the root of the screen
=item Num $.y_root: the y coordinate of the pointer relative to the root of the screen


=end pod

#TT:0:N-GdkEventTouch:
class N-GdkEventTouch is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has num64 $.axes;
  has uint32 $.state;
  has N-GdkEventSequence $.sequence;
  has int32 $.emulating_pointer;
  has N-GObject $.device;
  has num64 $.x_root;
  has num64 $.y_root;
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


=item C<GdkEventType> $.type: the type of the event (C<GDK_SCROLL>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item Num $.x: the x coordinate of the pointer relative to the window.
=item Num $.y: the y coordinate of the pointer relative to the window.
=item UInt $.state: (type C<Gnome::Gdk3::ModifierType>): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See C<Gnome::Gdk3::ModifierType>.
=item C<Gnome::Gdk3::ScrollDirection> $.direction: the direction to scroll to (one of C<GDK_SCROLL_UP>, C<GDK_SCROLL_DOWN>, C<GDK_SCROLL_LEFT>, C<GDK_SCROLL_RIGHT> or C<GDK_SCROLL_SMOOTH>).
=item N-GObject $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.
=item Num $.x_root: the x coordinate of the pointer relative to the root of the screen.
=item Num $.y_root: the y coordinate of the pointer relative to the root of the screen.
=item Num $.delta_x: the x coordinate of the scroll delta
=item Num $.delta_y: the y coordinate of the scroll delta


=end pod

#TT:0:N-GdkEventScroll:
class N-GdkEventScroll is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has uint32 $.state;
  has int32 $.direction;
  has N-GObject $.device;
  has num64 $.x_root;
  has num64 $.y_root;
  has num64 $.delta_x;
  has num64 $.delta_y;
  has uint32 $.is_stop;
}

my constant GdkEventScroll is export = N-GdkEventScroll;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventKey

Describes a key press or key release event.


=item C<GdkEventType> $.type: the type of the event (C<GDK_KEY_PRESS> or C<GDK_KEY_RELEASE>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item UInt $.state: (type C<Gnome::Gdk3::ModifierType>): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See C<Gnome::Gdk3::ModifierType>.
=item UInt $.keyval: the key that was pressed or released. See the `gdk/gdkkeysyms.h` header file for a complete list of GDK key codes.
=item Int $.length: the length of I<string>.
=item Str $.string: a string containing an approximation of the text that would result from this keypress. The only correct way to handle text input of text is using input methods (see C<Gnome::Gtk3::IMContext>), so this field is deprecated and should never be used. (C<gdk_unicode_to_keyval()> provides a non-deprecated way of getting an approximate translation for a key.) The string is encoded in the encoding of the current locale (Note: this for backwards compatibility: strings in GTK+ and GDK are typically in UTF-8.) and NUL-terminated. In some cases, the translation of the key code will be a single NUL byte, in which case looking at I<length> is necessary to distinguish it from the an empty translation.
=item UInt $.hardware_keycode: the raw code of the key that was pressed or released.
=item UInt $.group: the keyboard group.
=item ___is_modifier: a flag that indicates if I<hardware_keycode> is mapped to a modifier. Since 2.10


=end pod

#TT:0:N-GdkEventKey:
class N-GdkEventKey is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has uint32 $.time;
  has uint32 $.state;
  has uint32 $.keyval;
  has int32 $.length;
  has str $.string;
  has uint16 $.hardware_keycode;
  has byte $.group;
  has uint32 $.is_modifier;
}

my constant GdkEventKey is export = N-GdkEventKey;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventCrossing

Generated when the pointer enters or leaves a window.


=item C<GdkEventType> $.type: the type of the event (C<GDK_ENTER_NOTIFY> or C<GDK_LEAVE_NOTIFY>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item N-GObject $.subwindow: the window that was entered or left.
=item UInt $.time: the time of the event in milliseconds.
=item Num $.x: the x coordinate of the pointer relative to the window.
=item Num $.y: the y coordinate of the pointer relative to the window.
=item Num $.x_root: the x coordinate of the pointer relative to the root of the screen.
=item Num $.y_root: the y coordinate of the pointer relative to the root of the screen.
=item C<Gnome::Gdk3::CrossingMode> $.mode: the crossing mode (C<GDK_CROSSING_NORMAL>, C<GDK_CROSSING_GRAB>, C<GDK_CROSSING_UNGRAB>, C<GDK_CROSSING_GTK_GRAB>, C<GDK_CROSSING_GTK_UNGRAB> or C<GDK_CROSSING_STATE_CHANGED>).  C<GDK_CROSSING_GTK_GRAB>, C<GDK_CROSSING_GTK_UNGRAB>, and C<GDK_CROSSING_STATE_CHANGED> were added in 2.14 and are always synthesized, never native.
=item C<Gnome::Gdk3::NotifyType> $.detail: the kind of crossing that happened (C<GDK_NOTIFY_INFERIOR>, C<GDK_NOTIFY_ANCESTOR>, C<GDK_NOTIFY_VIRTUAL>, C<GDK_NOTIFY_NONLINEAR> or C<GDK_NOTIFY_NONLINEAR_VIRTUAL>).
=item Int $.focus: C<1> if I<window> is the focus window or an inferior.
=item UInt $.state: (type C<Gnome::Gdk3::ModifierType>): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See C<Gnome::Gdk3::ModifierType>.


=end pod

#TT:0:N-GdkEventCrossing:
class N-GdkEventCrossing is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has N-GObject $.subwindow;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has num64 $.x_root;
  has num64 $.y_root;
  has int32 $.mode;
  has int32 $.detail;
  has int32 $.focus;
  has uint32 $.state;
}

my constant GdkEventCrossing is export = N-GdkEventCrossing;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventFocus

Describes a change of keyboard focus.


=item C<GdkEventType> $.type: the type of the event (C<GDK_FOCUS_CHANGE>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item Int $.in: C<1> if the window has gained the keyboard focus, C<0> if it has lost the focus.


=end pod

#TT:0:N-GdkEventFocus:
class N-GdkEventFocus is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has int16 $.in;
}

my constant GdkEventFocus is export = N-GdkEventFocus;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventConfigure

Generated when a window size or position has changed.


=item C<GdkEventType> $.type: the type of the event (C<GDK_CONFIGURE>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item Int $.x: the new x coordinate of the window, relative to its parent.
=item Int $.y: the new y coordinate of the window, relative to its parent.
=item Int $.width: the new width of the window.
=item Int $.height: the new height of the window.

=end pod

#TT:0:N-GdkEventConfigure:
class N-GdkEventConfigure is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has int32 $.x;
  has int32 $.y;
  has int32 $.width;
  has int32 $.height;
}

my constant GdkEventConfigure is export = N-GdkEventConfigure;

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventProperty

Describes a property change on a window.


=item C<GdkEventType> $.type: the type of the event (C<GDK_PROPERTY_NOTIFY>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item C<Gnome::Gdk3::Atom> $.atom: the property that was changed.
=item UInt $.time: the time of the event in milliseconds.
=item UInt $.state: (type C<Gnome::Gdk3::PropertyState>): whether the property was changed (C<GDK_PROPERTY_NEW_VALUE>) or deleted (C<GDK_PROPERTY_DELETE>).


=end pod

#TT:0:N-GdkEventProperty:
class N-GdkEventProperty is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has GdkAtom $.atom;
  has uint32 $.time;
  has uint32 $.state;
}
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventSelection

Generated when a selection is requested or ownership of a selection
is taken over by another client application.


=item C<GdkEventType> $.type: the type of the event (C<GDK_SELECTION_CLEAR>, C<GDK_SELECTION_NOTIFY> or C<GDK_SELECTION_REQUEST>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item C<Gnome::Gdk3::Atom> $.selection: the selection.
=item C<Gnome::Gdk3::Atom> $.target: the target to which the selection should be converted.
=item C<Gnome::Gdk3::Atom> $.property: the property in which to place the result of the conversion.
=item UInt $.time: the time of the event in milliseconds.
=item N-GObject $.requestor: the window on which to place I<property> or C<Any> if none.


=end pod

#TT:0:N-GdkEventSelection:
class N-GdkEventSelection is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has GdkAtom $.selection;
  has GdkAtom $.target;
  has GdkAtom $.property;
  has uint32 $.time;
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

Since: 2.6


=item C<GdkEventType> $.type: the type of the event (C<GDK_OWNER_CHANGE>).
=item N-GObject $.window: the window which received the event
=item Int $.send_event: C<1> if the event was sent explicitly.
=item N-GObject $.owner: the new owner of the selection, or C<Any> if there is none
=item C<Gnome::Gdk3::OwnerChange> $.reason: the reason for the ownership change as a C<Gnome::Gdk3::OwnerChange> value
=item C<Gnome::Gdk3::Atom> $.selection: the atom identifying the selection
=item UInt $.time: the timestamp of the event
=item UInt $.selection_time: the time at which the selection ownership was taken over


=end pod

#TT:0:N-GdkEventOwnerChange:
class N-GdkEventOwnerChange is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has N-GObject $.owner;
  has GdkOwnerChange $.reason;
  has GdkAtom $.selection;
  has uint32 $.time;
  has uint32 $.selection_time;
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


=item C<GdkEventType> $.type: the type of the event (C<GDK_PROXIMITY_IN> or C<GDK_PROXIMITY_OUT>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item N-GObject $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.


=end pod

#TT:0:N-GdkEventProximity:
class N-GdkEventProximity is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has uint32 $.time;
  has N-GObject $.device;
}

my constant GdkEventProximity is export = N-GdkEventProximity;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventSetting

Generated when a setting is modified.


=item C<GdkEventType> $.type: the type of the event (C<GDK_SETTING>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item C<Gnome::Gdk3::SettingAction> $.action: what happened to the setting (C<GDK_SETTING_ACTION_NEW>, C<GDK_SETTING_ACTION_CHANGED> or C<GDK_SETTING_ACTION_DELETED>).
=item Str $.name: the name of the setting.


=end pod

#TT:0:N-GdkEventSetting:
class N-GdkEventSetting is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has int32 $.action;
  has Str $.name;
}

my constant GdkEventSetting is export = N-GdkEventSetting;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventWindowState

Generated when the state of a toplevel window changes.


=item C<GdkEventType> $.type: the type of the event (C<GDK_WINDOW_STATE>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item C<Gnome::Gdk3::WindowState> $.changed_mask: mask specifying what flags have changed.
=item C<Gnome::Gdk3::WindowState> $.new_window_state: the new window state, a combination of C<Gnome::Gdk3::WindowState> bits.


=end pod

#TT:0:N-GdkEventWindowState:
class N-GdkEventWindowState is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has int32 $.changed_mask;
  has int32 $.new_window_state;
}

my constant GdkEventWindowState is export = N-GdkEventWindowState;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventGrabBroken

Generated when a pointer or keyboard grab is broken. On X11, this happens
when the grab window becomes unviewable (i.e. it or one of its ancestors
is unmapped), or if the same application grabs the pointer or keyboard
again. Note that implicit grabs (which are initiated by button presses)
can also cause C<N-GdkEventGrabBroken> events.

Since: 2.8


=item C<GdkEventType> $.type: the type of the event (C<GDK_GRAB_BROKEN>)
=item N-GObject $.window: the window which received the event, i.e. the window that previously owned the grab
=item Int $.send_event: C<1> if the event was sent explicitly.
=item Int $.keyboard: C<1> if a keyboard grab was broken, C<0> if a pointer grab was broken
=item Int $.implicit: C<1> if the broken grab was implicit
=item N-GObject $.grab_window: If this event is caused by another grab in the same application, I<grab_window> contains the new grab window. Otherwise I<grab_window> is C<Any>.


=end pod

#TT:0:N-GdkEventGrabBroken:
class N-GdkEventGrabBroken is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has int32 $.keyboard;
  has int32 $.implicit;
  has N-GObject $.grab_window;
}

my constant GdkEventGrabBroken is export = N-GdkEventGrabBroken;

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventDND

Generated during DND operations.


=item C<GdkEventType> $.type: the type of the event (C<GDK_DRAG_ENTER>, C<GDK_DRAG_LEAVE>, C<GDK_DRAG_MOTION>, C<GDK_DRAG_STATUS>, C<GDK_DROP_START> or C<GDK_DROP_FINISHED>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item C<Gnome::Gdk3::DragContext> $.context: the C<Gnome::Gdk3::DragContext> for the current DND operation.
=item UInt $.time: the time of the event in milliseconds.
=item Int $.x_root: the x coordinate of the pointer relative to the root of the screen, only set for C<GDK_DRAG_MOTION> and C<GDK_DROP_START>.
=item Int $.y_root: the y coordinate of the pointer relative to the root of the screen, only set for C<GDK_DRAG_MOTION> and C<GDK_DROP_START>.


=end pod

#TT:0:N-GdkEventDND:
class N-GdkEventDND is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has GdkDragContext $.context;
  has uint32 $.time;
  has int16 $.x_root;
  has int16 $.y_root;
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventTouchpadSwipe

Generated during touchpad swipe gestures.


=item C<GdkEventType> $.type: the type of the event (C<GDK_TOUCHPAD_SWIPE>)
=item N-GObject $.window: the window which received the event
=item Int $.send_event: C<1> if the event was sent explicitly
=item Int $.phase: the current phase of the gesture
=item Int $.n_fingers: The number of fingers triggering the swipe
=item UInt $.time: the time of the event in milliseconds
=item Num $.x: The X coordinate of the pointer
=item Num $.y: The Y coordinate of the pointer
=item Num $.dx: Movement delta in the X axis of the swipe focal point
=item Num $.dy: Movement delta in the Y axis of the swipe focal point
=item Num $.x_root: The X coordinate of the pointer, relative to the root of the screen.
=item Num $.y_root: The Y coordinate of the pointer, relative to the root of the screen.
=item UInt $.state: (type C<Gnome::Gdk3::ModifierType>): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See C<Gnome::Gdk3::ModifierType>.


=end pod

#TT:0:N-GdkEventTouchpadSwipe:
class N-GdkEventTouchpadSwipe is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has int8 $.phase;
  has int8 $.n_fingers;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has num64 $.dx;
  has num64 $.dy;
  has num64 $.x_root;
  has num64 $.y_root;
  has uint32 $.state;
}

my constant GdkEventTouchpadSwipe is export = N-GdkEventTouchpadSwipe;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventTouchpadPinch

Generated during touchpad swipe gestures.


=item C<GdkEventType> $.type: the type of the event (C<GDK_TOUCHPAD_PINCH>)
=item N-GObject $.window: the window which received the event
=item Int $.send_event: C<1> if the event was sent explicitly
=item Int $.phase: the current phase of the gesture
=item Int $.n_fingers: The number of fingers triggering the pinch
=item UInt $.time: the time of the event in milliseconds
=item Num $.x: The X coordinate of the pointer
=item Num $.y: The Y coordinate of the pointer
=item Num $.dx: Movement delta in the X axis of the swipe focal point
=item Num $.dy: Movement delta in the Y axis of the swipe focal point
=item Num $.angle_delta: The angle change in radians, negative angles denote counter-clockwise movements
=item Num $.scale: The current scale, relative to that at the time of the corresponding C<GDK_TOUCHPAD_GESTURE_PHASE_BEGIN> event
=item Num $.x_root: The X coordinate of the pointer, relative to the root of the screen.
=item Num $.y_root: The Y coordinate of the pointer, relative to the root of the screen.
=item UInt $.state: (type C<Gnome::Gdk3::ModifierType>): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See C<Gnome::Gdk3::ModifierType>.


=end pod

#TT:0:N-GdkEventTouchpadPinch:
class N-GdkEventTouchpadPinch is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has int8 $.phase;
  has int8 $.n_fingers;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has num64 $.dx;
  has num64 $.dy;
  has num64 $.angle_delta;
  has num64 $.scale;
  has num64 $.x_root;
  has num64 $.y_root;
  has uint32 $.state;
}

my constant GdkEventTouchpadPinch is export = N-GdkEventTouchpadPinch;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventPadButton

Generated during C<GDK_SOURCE_TABLET_PAD> button presses and releases.

Since: 3.22


=item C<GdkEventType> $.type: the type of the event (C<GDK_PAD_BUTTON_PRESS> or C<GDK_PAD_BUTTON_RELEASE>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item UInt $.group: the pad group the button belongs to. A C<GDK_SOURCE_TABLET_PAD> device may have one or more groups containing a set of buttons/rings/strips each.
=item UInt $.button: The pad button that was pressed.
=item UInt $.mode: The current mode of I<group>. Different groups in a C<GDK_SOURCE_TABLET_PAD> device may have different current modes.


=end pod

#TT:0:N-GdkEventPadButton:
class N-GdkEventPadButton is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has uint32 $.time;
  has uint32 $.group;
  has uint32 $.button;
  has uint32 $.mode;
}

my constant GdkEventPadButton is export = N-GdkEventPadButton;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventPadAxis

Generated during C<GDK_SOURCE_TABLET_PAD> interaction with tactile sensors.

Since: 3.22

=item C<GdkEventType> $.type: the type of the event (C<GDK_PAD_RING> or C<GDK_PAD_STRIP>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item UInt $.group: the pad group the ring/strip belongs to. A C<GDK_SOURCE_TABLET_PAD> device may have one or more groups containing a set of buttons/rings/strips each.
=item UInt $.index: number of strip/ring that was interacted. This number is 0-indexed.
=item UInt $.mode: The current mode of I<group>. Different groups in a C<GDK_SOURCE_TABLET_PAD> device may have different current modes.
=item Num $.value: The current value for the given axis.


=end pod

#TT:0:N-GdkEventPadAxis:
class N-GdkEventPadAxis is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has uint32 $.time;
  has uint32 $.group;
  has uint32 $.index;
  has uint32 $.mode;
  has num64 $.value;
}

my constant GdkEventPadAxis is export = N-GdkEventPadAxis;

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkEventPadGroupMode

Generated during C<GDK_SOURCE_TABLET_PAD> mode switches in a group.

Since: 3.22

=item C<GdkEventType> $.type: the type of the event (C<GDK_PAD_GROUP_MODE>).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: C<1> if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item UInt $.group: the pad group that is switching mode. A C<GDK_SOURCE_TABLET_PAD> device may have one or more groups containing a set of buttons/rings/strips each.
=item UInt $.mode: The new mode of I<group>. Different groups in a C<GDK_SOURCE_TABLET_PAD> device may have different current modes.

=end pod

#TT:0:N-GdkEventPadGroupMode:
class N-GdkEventPadGroupMode is export is repr('CStruct') {
  has int32 $.type;
  has N-GObject $.window;
  has int8 $.send_event;
  has uint32 $.time;
  has uint32 $.group;
  has uint32 $.mode;
}

my constant GdkEventPadGroupMode is export = N-GdkEventPadGroupMode;

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
  HAS N-GdkEventAny $.event-any;
#  HAS N-GdkEventExpose $.event-expose;
  HAS N-GdkEventVisibility $.visibility;
  HAS N-GdkEventMotion $.event-motion;
  HAS N-GdkEventButton $.event-button;
#  HAS N-GdkEventTouch $.event-touch;
  HAS N-GdkEventScroll $.event-scroll;
  HAS N-GdkEventKey $.event-key;
  HAS N-GdkEventCrossing $.event-crossing;
  HAS N-GdkEventFocus $.event-focus;
  HAS N-GdkEventConfigure $.event-configure;
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
}

my constant GdkEvent is export = N-GdkEvent;

=begin pod
=head3 struct N-GdkEventExpose B<I<this event structure is not yet implemented>>
=head3 struct N-GdkEventTouch B<I<this event structure is not yet implemented>>
=head3 struct N-GdkEventSelection B<I<this event structure is not yet implemented>>
=head3 struct N-GdkEventProperty B<I<this event structure is not yet implemented>>
=head3 struct N-GdkEventOwnerChange B<I<this event structure is not yet implemented>>
=head3 struct N-GdkEventDND B<I<this event structure is not yet implemented>>

=end pod

#-------------------------------------------------------------------------------
#my Bool $signals-added = False;
#`{{
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method new ( GdkEventType :$event-name! )

Create a new event object. When successful, the object must be freed explicitly when done using C<gdk_event_free()>.

  multi method new ( Gnome::GObject::Object :$native-object! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  #$signals-added = self.add-signal-types( $?CLASS.^name,
  #  # ... :type<signame>
  #) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk3::Events';

  # process all named arguments
  if ? %options<event-name> {
    self.set-native-object(gdk_events_new(%options<event-name>));
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}
}}

#`{{
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  #return unless self.^name eq 'Gnome::Gdk3::Events';
}
}}

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
#TM:0:gdk_events_pending:
=begin pod
=head2 gdk_events_pending

Checks if any events are ready to be processed for any display.

Returns: C<1> if any events are pending.

  method gdk_events_pending ( --> Int  )


=end pod

sub gdk_events_pending (  )
  returns int32
  is native(&gdk-lib)
  { * }

#`{{ drop
#-------------------------------------------------------------------------------
#TM:0:gdk_event_get:
=begin pod
=head2 gdk_event_get

Checks all open displays for a B<Gnome::Gdk3::Event> to process,to be processed
on, fetching events from the windowing system if necessary.
See C<gdk_display_get_event()>.

Returns: (nullable): the next B<Gnome::Gdk3::Event> to be processed, or C<Any>
if no events are pending. The returned B<Gnome::Gdk3::Event> should be freed
with C<gdk_event_free()>.

  method gdk_event_get ( --> N-GdkEvent  )


=end pod

sub gdk_event_get (  )
  returns N-GdkEvent
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_peek:
=begin pod
=head2 gdk_event_peek

If there is an event waiting in the event queue of some open
display, returns a copy of it. See C<gdk_display_peek_event()>.

Returns: (nullable): a copy of the first B<Gnome::Gdk3::Event> on some event
queue, or C<Any> if no events are in any queues. The returned
B<Gnome::Gdk3::Event> should be freed with C<gdk_event_free()>.

  method gdk_event_peek ( --> N-GdkEvent  )


=end pod

sub gdk_event_peek (  )
  returns N-GdkEvent
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_event_put:
=begin pod
=head2 gdk_event_put

Appends a copy of the given event onto the front of the event
queue for event->any.window’s display, or the default event
queue if event->any.window is C<Any>. See C<gdk_display_put_event()>.

  method gdk_event_put ( N-GdkEvent $event )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>.

=end pod

sub gdk_event_put ( N-GdkEvent $event )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_new:
=begin pod
=head2 gdk_event_new

Creates a new event of the given type. All fields are set to 0.

Returns: a newly-allocated B<Gnome::Gdk3::Event>. The returned B<Gnome::Gdk3::Event>
should be freed with C<gdk_event_free()>.

Since: 2.2

  method gdk_event_new ( GdkEventType $type --> N-GdkEvent  )

=item GdkEventType $type; a B<Gnome::Gdk3::EventType>

=end pod

sub gdk_event_new ( int32 $type )
  returns N-GdkEvent
  is native(&gdk-lib)
  { * }

#`{{ drop
#-------------------------------------------------------------------------------
#TM:0:gdk_event_copy:
=begin pod
=head2 gdk_event_copy

Copies a B<Gnome::Gdk3::Event>, copying or incrementing the reference count of the
resources associated with it (e.g. B<Gnome::Gdk3::Window>’s and strings).

Returns: a copy of I<event>. The returned B<Gnome::Gdk3::Event> should be freed with
C<gdk_event_free()>.

  method gdk_event_copy ( N-GdkEvent $event --> N-GdkEvent  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_copy ( N-GdkEvent $event )
  returns N-GdkEvent
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_free:
=begin pod
=head2 gdk_event_free

Frees a B<Gnome::Gdk3::Event>, freeing or decrementing any resources associated with it.
Note that this function should only be called with events returned from
functions such as C<gdk_event_peek()>, C<gdk_event_get()>, C<gdk_event_copy()>
and C<gdk_event_new()>.

  method gdk_event_free ( N-GdkEvent $event )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>.

=end pod

sub gdk_event_free ( N-GdkEvent $event )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_window:
=begin pod
=head2 gdk_event_get_window

Extracts the B<Gnome::Gdk3::Window> associated with an event.

Returns: (transfer none): The B<Gnome::Gdk3::Window> associated with the event

Since: 3.10

  method gdk_event_get_window ( N-GdkEvent $event --> N-GObject  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_get_window ( N-GdkEvent $event )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_time:
=begin pod
=head2 gdk_event_get_time

Returns the time stamp from I<event>, if there is one; otherwise
returns B<GDK_CURRENT_TIME>. If I<event> is C<Any>, returns B<GDK_CURRENT_TIME>.

Returns: time stamp field from I<event>

  method gdk_event_get_time ( N-GdkEvent $event --> UInt  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_get_time ( N-GdkEvent $event )
  returns uint32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_state:
=begin pod
=head2 gdk_event_get_state

If the event contains a “state” field, puts that field in I<state>. Otherwise
stores an empty state (0). Returns C<1> if there was a state field
in the event. I<event> may be C<Any>, in which case it’s treated
as if the event had no state field.

Returns: C<1> if there was a state field in the event

  method gdk_event_get_state ( N-GdkEvent $event, GdkModifierType $state --> Int  )

=item N-GdkEvent $event; (allow-none): a B<Gnome::Gdk3::Event> or C<Any>
=item GdkModifierType $state; (out): return location for state

=end pod

sub gdk_event_get_state ( N-GdkEvent $event, int32 $state )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_coords:
=begin pod
=head2 gdk_event_get_coords

Extract the event window relative x/y coordinates from an event.

Returns: C<1> if the event delivered event window coordinates

  method gdk_event_get_coords ( N-GdkEvent $event, Num $x_win, Num $y_win --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item Num $x_win; (out) (optional): location to put event window x coordinate
=item Num $y_win; (out) (optional): location to put event window y coordinate

=end pod

sub gdk_event_get_coords ( N-GdkEvent $event, num64 $x_win, num64 $y_win )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_root_coords:
=begin pod
=head2 gdk_event_get_root_coords

Extract the root window relative x/y coordinates from an event.

Returns: C<1> if the event delivered root window coordinates

  method gdk_event_get_root_coords ( N-GdkEvent $event, Num $x_root, Num $y_root --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item Num $x_root; (out) (optional): location to put root window x coordinate
=item Num $y_root; (out) (optional): location to put root window y coordinate

=end pod

sub gdk_event_get_root_coords ( N-GdkEvent $event, num64 $x_root, num64 $y_root )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_button:
=begin pod
=head2 gdk_event_get_button

Extract the button number from an event.

Returns: C<1> if the event delivered a button number

Since: 3.2

  method gdk_event_get_button ( N-GdkEvent $event, UInt $button --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item UInt $button; (out): location to store mouse button number

=end pod

sub gdk_event_get_button ( N-GdkEvent $event, uint32 $button )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_click_count:
=begin pod
=head2 gdk_event_get_click_count

Extracts the click count from an event.

Returns: C<1> if the event delivered a click count

Since: 3.2

  method gdk_event_get_click_count ( N-GdkEvent $event, UInt $click_count --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item UInt $click_count; (out): location to store click count

=end pod

sub gdk_event_get_click_count ( N-GdkEvent $event, uint32 $click_count )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_keyval:
=begin pod
=head2 gdk_event_get_keyval

Extracts the keyval from an event.

Returns: C<1> if the event delivered a key symbol

Since: 3.2

  method gdk_event_get_keyval ( N-GdkEvent $event, UInt $keyval --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item UInt $keyval; (out): location to store the keyval

=end pod

sub gdk_event_get_keyval ( N-GdkEvent $event, uint32 $keyval )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_keycode:
=begin pod
=head2 gdk_event_get_keycode

Extracts the hardware keycode from an event.

Also see C<gdk_event_get_scancode()>.

Returns: C<1> if the event delivered a hardware keycode

Since: 3.2

  method gdk_event_get_keycode ( N-GdkEvent $event, UInt $keycode --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item UInt $keycode; (out): location to store the keycode

=end pod

sub gdk_event_get_keycode ( N-GdkEvent $event, uint16 $keycode )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_scroll_direction:
=begin pod
=head2 gdk_event_get_scroll_direction

Extracts the scroll direction from an event.

Returns: C<1> if the event delivered a scroll direction

Since: 3.2

  method gdk_event_get_scroll_direction ( N-GdkEvent $event, GdkScrollDirection $direction --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item GdkScrollDirection $direction; (out): location to store the scroll direction

=end pod

sub gdk_event_get_scroll_direction ( N-GdkEvent $event, int32 $direction )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_scroll_deltas:
=begin pod
=head2 gdk_event_get_scroll_deltas

Retrieves the scroll deltas from a B<Gnome::Gdk3::Event>

Returns: C<1> if the event contains smooth scroll information

Since: 3.4

  method gdk_event_get_scroll_deltas ( N-GdkEvent $event, Num $delta_x, Num $delta_y --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item Num $delta_x; (out): return location for X delta
=item Num $delta_y; (out): return location for Y delta

=end pod

sub gdk_event_get_scroll_deltas ( N-GdkEvent $event, num64 $delta_x, num64 $delta_y )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_is_scroll_stop_event:
=begin pod
=head2 gdk_event_is_scroll_stop_event



  method gdk_event_is_scroll_stop_event ( N-GdkEvent $event --> Int  )

=item N-GdkEvent $event;

=end pod

sub gdk_event_is_scroll_stop_event ( N-GdkEvent $event )
  returns int32
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_axis:
=begin pod
=head2 gdk_event_get_axis

Extract the axis value for a particular axis use from
an event structure.

Returns: C<1> if the specified axis was found, otherwise C<0>

  method gdk_event_get_axis ( N-GdkEvent $event, GdkAxisUse $axis_use, Num $value --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item GdkAxisUse $axis_use; the axis use to look for
=item Num $value; (out): location to store the value found

=end pod

sub gdk_event_get_axis ( N-GdkEvent $event, GdkAxisUse $axis_use, num64 $value )
  returns int32
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_event_set_device:
=begin pod
=head2 gdk_event_set_device

Sets the device for I<event> to I<device>. The event must
have been allocated by GTK+, for instance, by
C<gdk_event_copy()>.

Since: 3.0

  method gdk_event_set_device ( N-GdkEvent $event, N-GObject $device )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item N-GObject $device; a B<Gnome::Gdk3::Device>

=end pod

sub gdk_event_set_device ( N-GdkEvent $event, N-GObject $device )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_device:
=begin pod
=head2 gdk_event_get_device

If the event contains a “device” field, this function will return
it, else it will return C<Any>.

Returns: (nullable) (transfer none): a B<Gnome::Gdk3::Device>, or C<Any>.

Since: 3.0

  method gdk_event_get_device ( N-GdkEvent $event --> N-GObject  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>.

=end pod

sub gdk_event_get_device ( N-GdkEvent $event )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_set_source_device:
=begin pod
=head2 gdk_event_set_source_device

Sets the slave device for I<event> to I<device>.

The event must have been allocated by GTK+,
for instance by C<gdk_event_copy()>.

Since: 3.0

  method gdk_event_set_source_device ( N-GdkEvent $event, N-GObject $device )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item N-GObject $device; a B<Gnome::Gdk3::Device>

=end pod

sub gdk_event_set_source_device ( N-GdkEvent $event, N-GObject $device )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_source_device:
=begin pod
=head2 gdk_event_get_source_device

This function returns the hardware (slave) B<Gnome::Gdk3::Device> that has
triggered the event, falling back to the virtual (master) device
(as in C<gdk_event_get_device()>) if the event wasn’t caused by
interaction with a hardware device. This may happen for example
in synthesized crossing events after a B<Gnome::Gdk3::Window> updates its
geometry or a grab is acquired/released.

If the event does not contain a device field, this function will
return C<Any>.

Returns: (nullable) (transfer none): a B<Gnome::Gdk3::Device>, or C<Any>.

Since: 3.0

  method gdk_event_get_source_device ( N-GdkEvent $event --> N-GObject  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_get_source_device ( N-GdkEvent $event )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_request_motions:
=begin pod
=head2 gdk_event_request_motions

Request more motion notifies if I<event> is a motion notify hint event.

This function should be used instead of C<gdk_window_get_pointer()> to
request further motion notifies, because it also works for extension
events where motion notifies are provided for devices other than the
core pointer. Coordinate extraction, processing and requesting more
motion events from a C<GDK_MOTION_NOTIFY> event usually works like this:

|[<!-- language="C" -->
{
// motion_event handler
x = motion_event->x;
y = motion_event->y;
// handle (x,y) motion
gdk_event_request_motions (motion_event); // handles is_hint events
}
]|

Since: 2.12

  method gdk_event_request_motions ( N-GdkEventMotion $event )

=item N-GdkEventMotion $event; a valid B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_request_motions ( N-GdkEventMotion $event )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_triggers_context_menu:
=begin pod
=head2 gdk_event_triggers_context_menu

This function returns whether a B<Gnome::Gdk3::EventButton> should trigger a
context menu, according to platform conventions. The right mouse
button always triggers context menus. Additionally, if
C<gdk_keymap_get_modifier_mask()> returns a non-0 mask for
C<GDK_MODIFIER_INTENT_CONTEXT_MENU>, then the left mouse button will
also trigger a context menu if this modifier is pressed.

This function should always be used instead of simply checking for
event->button == C<GDK_BUTTON_SECONDARY>.

Returns: C<1> if the event should trigger a context menu.

Since: 3.4

  method gdk_event_triggers_context_menu ( N-GdkEvent $event --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>, currently only button events are meaningful values

=end pod

sub gdk_event_triggers_context_menu ( N-GdkEvent $event )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_events_get_distance:
=begin pod
=head2 [[gdk_] events_] get_distance

If both events have X/Y information, the distance between both coordinates
(as in a straight line going from I<event1> to I<event2>) will be returned.

Returns: C<1> if the distance could be calculated.

Since: 3.0

  method gdk_events_get_distance ( N-GdkEvent $event1, N-GdkEvent $event2, Num $distance --> Int  )

=item N-GdkEvent $event1; first B<Gnome::Gdk3::Event>
=item N-GdkEvent $event2; second B<Gnome::Gdk3::Event>
=item Num $distance; (out): return location for the distance

=end pod

sub gdk_events_get_distance ( N-GdkEvent $event1, N-GdkEvent $event2, num64 $distance )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_events_get_angle:
=begin pod
=head2 [[gdk_] events_] get_angle

If both events contain X/Y information, this function will return C<1>
and return in I<angle> the relative angle from I<event1> to I<event2>. The rotation
direction for positive angles is from the positive X axis towards the positive
Y axis.

Returns: C<1> if the angle could be calculated.

Since: 3.0

  method gdk_events_get_angle ( N-GdkEvent $event1, N-GdkEvent $event2, Num $angle --> Int  )

=item N-GdkEvent $event1; first B<Gnome::Gdk3::Event>
=item N-GdkEvent $event2; second B<Gnome::Gdk3::Event>
=item Num $angle; (out): return location for the relative angle between both events

=end pod

sub gdk_events_get_angle ( N-GdkEvent $event1, N-GdkEvent $event2, num64 $angle )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_events_get_center:
=begin pod
=head2 [[gdk_] events_] get_center

If both events contain X/Y information, the center of both coordinates
will be returned in I<x> and I<y>.

Returns: C<1> if the center could be calculated.

Since: 3.0

  method gdk_events_get_center ( N-GdkEvent $event1, N-GdkEvent $event2, Num $x, Num $y --> Int  )

=item N-GdkEvent $event1; first B<Gnome::Gdk3::Event>
=item N-GdkEvent $event2; second B<Gnome::Gdk3::Event>
=item Num $x; (out): return location for the X coordinate of the center
=item Num $y; (out): return location for the Y coordinate of the center

=end pod

sub gdk_events_get_center ( N-GdkEvent $event1, N-GdkEvent $event2, num64 $x, num64 $y )
  returns int32
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_event_handler_set:
=begin pod
=head2 gdk_event_handler_set

Sets the function to call to handle all events from GDK.

Note that GTK+ uses this to install its own event handler, so it is
usually not useful for GTK+ applications. (Although an application
can call this function then call C<gtk_main_do_event()> to pass
events to GTK+.)

  method gdk_event_handler_set ( N-GdkEventFunc $func, Pointer $data, GDestroyNotify $notify )

=item N-GdkEventFunc $func; the function to call to handle events from GDK.
=item Pointer $data; user data to pass to the function.
=item GDestroyNotify $notify; the function to call when the handler function is removed, i.e. when C<gdk_event_handler_set()> is called with another event handler.

=end pod

sub gdk_event_handler_set ( N-GdkEventFunc $func, Pointer $data, GDestroyNotify $notify )
  is native(&gdk-lib)
  { * }
}}
#-------------------------------------------------------------------------------
#TM:0:gdk_event_set_screen:
=begin pod
=head2 gdk_event_set_screen

Sets the screen for I<event> to I<screen>. The event must
have been allocated by GTK+, for instance, by
C<gdk_event_copy()>.

Since: 2.2

  method gdk_event_set_screen ( N-GdkEvent $event, N-GObject $screen )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item N-GObject $screen; a B<Gnome::Gdk3::Screen>

=end pod

sub gdk_event_set_screen ( N-GdkEvent $event, N-GObject $screen )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_screen:
=begin pod
=head2 gdk_event_get_screen

Returns the screen for the event. The screen is
typically the screen for `event->any.window`, but
for events such as mouse events, it is the screen
where the pointer was when the event occurs -
that is, the screen which has the root window
to which `event->motion.x_root` and
`event->motion.y_root` are relative.

Returns: (transfer none): the screen for the event

Since: 2.2

  method gdk_event_get_screen ( N-GdkEvent $event --> N-GObject  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_get_screen ( N-GdkEvent $event )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_event_sequence:
=begin pod
=head2 gdk_event_get_event_sequence

If I<event> if of type C<GDK_TOUCH_BEGIN>, C<GDK_TOUCH_UPDATE>,
C<GDK_TOUCH_END> or C<GDK_TOUCH_CANCEL>, returns the B<Gnome::Gdk3::EventSequence>
to which the event belongs. Otherwise, return C<Any>.

Returns: (transfer none): the event sequence that the event belongs to

Since: 3.4

  method gdk_event_get_event_sequence ( N-GdkEvent $event --> N-GdkEventSequence  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_get_event_sequence ( N-GdkEvent $event )
  returns N-GdkEventSequence
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_event_type:
=begin pod
=head2 gdk_event_get_event_type

Retrieves the type of the event.

Returns: a B<Gnome::Gdk3::EventType>

Since: 3.10

  method gdk_event_get_event_type ( N-GdkEvent $event --> GdkEventType  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_get_event_type ( N-GdkEvent $event )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_seat:
=begin pod
=head2 gdk_event_get_seat

Returns the B<Gnome::Gdk3::Seat> this event was generated for.

Returns: (transfer none): The B<Gnome::Gdk3::Seat> of this event

Since: 3.20

  method gdk_event_get_seat ( N-GdkEvent $event --> N-GObject  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_get_seat ( N-GdkEvent $event )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_set_show_events:
=begin pod
=head2 gdk_set_show_events

Sets whether a trace of received events is output.
Note that GTK+ must be compiled with debugging (that is,
configured using the `--enable-debug` option)
to use this option.

  method gdk_set_show_events ( Int $show_events )

=item Int $show_events; C<1> to output event debugging information.

=end pod

sub gdk_set_show_events ( int32 $show_events )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_get_show_events:
=begin pod
=head2 gdk_get_show_events

Gets whether event debugging output is enabled.

Returns: C<1> if event debugging output is enabled.

  method gdk_get_show_events ( --> Int  )


=end pod

sub gdk_get_show_events (  )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_setting_get:
=begin pod
=head2 gdk_setting_get

Obtains a desktop-wide setting, such as the double-click time,
for the default screen. See C<gdk_screen_get_setting()>.

Returns: C<1> if the setting existed and a value was stored
in I<value>, C<0> otherwise.

  method gdk_setting_get ( Str $name, N-GObject $value --> Int  )

=item Str $name; the name of the setting.
=item N-GObject $value; location to store the value of the setting.

=end pod

sub gdk_setting_get ( Str $name, N-GObject $value )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_device_tool:
=begin pod
=head2 gdk_event_get_device_tool

If the event was generated by a device that supports
different tools (eg. a tablet), this function will
return a B<Gnome::Gdk3::DeviceTool> representing the tool that
caused the event. Otherwise, C<Any> will be returned.

Note: the B<Gnome::Gdk3::DeviceTool><!-- -->s will be constant during
the application lifetime, if settings must be stored
persistently across runs, see C<gdk_device_tool_get_serial()>

Returns: (transfer none): The current device tool, or C<Any>

Since: 3.22

  method gdk_event_get_device_tool ( N-GdkEvent $event --> N-GObject  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_get_device_tool ( N-GdkEvent $event )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_set_device_tool:
=begin pod
=head2 gdk_event_set_device_tool

Sets the device tool for this event, should be rarely used.

Since: 3.22

  method gdk_event_set_device_tool ( N-GdkEvent $event, N-GObject $tool )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>
=item N-GObject $tool; (nullable): tool to set on the event, or C<Any>

=end pod

sub gdk_event_set_device_tool ( N-GdkEvent $event, N-GObject $tool )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_scancode:
=begin pod
=head2 gdk_event_get_scancode

Gets the keyboard low-level scancode of a key event.

This is usually hardware_keycode. On Windows this is the high
word of WM_KEY{DOWN,UP} lParam which contains the scancode and
some extended flags.

Returns: The associated keyboard scancode or 0

Since: 3.22

  method gdk_event_get_scancode ( N-GdkEvent $event --> int32  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_get_scancode ( N-GdkEvent $event )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_event_get_pointer_emulated:
=begin pod
=head2 gdk_event_get_pointer_emulated

Returns whether this event is an 'emulated' pointer event (typically
from a touch event), as opposed to a real one.

Returns: C<1> if this event is emulated

Since: 3.22

  method gdk_event_get_pointer_emulated ( N-GdkEvent $event --> Int  )

=item N-GdkEvent $event;  B<event>: a B<Gnome::Gdk3::Event>

=end pod

sub gdk_event_get_pointer_emulated ( N-GdkEvent $event )
  returns int32
  is native(&gdk-lib)
  { * }
