use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Types

=head1 Description

Types for the Gdk modules

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::Types;


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gdktypes.h
unit class Gnome::Gdk3::Types:auth<github:MARTIMM>;
#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkByteOrder

A set of values describing the possible byte-orders
for storing pixel values in memory.


=item GDK_LSB_FIRST: The values are stored with the least-significant byte first. For instance, the 32-bit value 0xffeecc would be stored in memory as 0xcc, 0xee, 0xff, 0x00.
=item GDK_MSB_FIRST: The values are stored with the most-significant byte first. For instance, the 32-bit value 0xffeecc would be stored in memory as 0x00, 0xff, 0xee, 0xcc.


=end pod

#TE:0:GdkByteOrder:
enum GdkByteOrder is export (
  'GDK_LSB_FIRST',
  'GDK_MSB_FIRST'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkModifierType

A set of bit-flags to indicate the state of modifier keys and mouse buttons
in various event types. Typical modifier keys are Shift, Control, Meta,
Super, Hyper, Alt, Compose, Apple, CapsLock or ShiftLock.

Like the X Window System, GDK supports 8 modifier keys and 5 mouse buttons.

Since 2.10, GDK recognizes which of the Meta, Super or Hyper keys are mapped
to Mod2 - Mod5, and indicates this by setting C<GDK_SUPER_MASK>,
C<GDK_HYPER_MASK> or C<GDK_META_MASK> in the state field of key events.

Note that GDK may add internal values to events which include
reserved values such as C<GDK_MODIFIER_RESERVED_13_MASK>.  Your code
should preserve and ignore them.  You can use C<GDK_MODIFIER_MASK> to
remove all reserved values.

Also note that the GDK X backend interprets button press events for button
4-7 as scroll events, so C<GDK_BUTTON4_MASK> and C<GDK_BUTTON5_MASK> will never
be set.


=item GDK_SHIFT_MASK: the Shift key.
=item GDK_LOCK_MASK: a Lock key (depending on the modifier mapping of the X server this may either be CapsLock or ShiftLock).
=item GDK_CONTROL_MASK: the Control key.
=item GDK_MOD1_MASK: the fourth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier, but normally it is the Alt key).
=item GDK_MOD2_MASK: the fifth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_MOD3_MASK: the sixth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_MOD4_MASK: the seventh modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_MOD5_MASK: the eighth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_BUTTON1_MASK: the first mouse button.
=item GDK_BUTTON2_MASK: the second mouse button.
=item GDK_BUTTON3_MASK: the third mouse button.
=item GDK_BUTTON4_MASK: the fourth mouse button.
=item GDK_BUTTON5_MASK: the fifth mouse button.
=item GDK_MODIFIER_RESERVED_13_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_14_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_15_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_16_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_17_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_18_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_19_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_20_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_21_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_22_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_23_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_24_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_25_MASK: A reserved bit flag; do not use in your own code
=item GDK_SUPER_MASK: the Super modifier. Since 2.10
=item GDK_HYPER_MASK: the Hyper modifier. Since 2.10
=item GDK_META_MASK: the Meta modifier. Since 2.10
=item GDK_MODIFIER_RESERVED_29_MASK: A reserved bit flag; do not use in your own code
=item GDK_RELEASE_MASK: not used in GDK itself. GTK+ uses it to differentiate between (keyval, modifiers) pairs from key press and release events.
=item GDK_MODIFIER_MASK: a mask covering all modifier types.


=end pod

#TE:0:GdkModifierType:
enum GdkModifierType is export (
  'GDK_SUPER_MASK'    => 1 +< 26,
  'GDK_HYPER_MASK'    => 1 +< 27,
  'GDK_META_MASK'     => 1 +< 28,
  'GDK_MODIFIER_RESERVED_29_MASK'  => 1 +< 29,
  'GDK_RELEASE_MASK'  => 1 +< 30,
  'GDK_MODIFIER_MASK' => 0x5c001fff
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkModifierIntent

This enum is used with C<gdk_keymap_get_modifier_mask()>
in order to determine what modifiers the
currently used windowing system backend uses for particular
purposes. For example, on X11/Windows, the Control key is used for
invoking menu shortcuts (accelerators), whereas on Apple computers
it’s the Command key (which correspond to C<GDK_CONTROL_MASK> and
C<GDK_MOD2_MASK>, respectively).

Since: 3.4


=item GDK_MODIFIER_INTENT_PRIMARY_ACCELERATOR: the primary modifier used to invoke menu accelerators.
=item GDK_MODIFIER_INTENT_CONTEXT_MENU: the modifier used to invoke context menus. Note that mouse button 3 always triggers context menus. When this modifier is not 0, it additionally triggers context menus when used with mouse button 1.
=item GDK_MODIFIER_INTENT_EXTEND_SELECTION: the modifier used to extend selections using `modifier`-click or `modifier`-cursor-key
=item GDK_MODIFIER_INTENT_MODIFY_SELECTION: the modifier used to modify selections, which in most cases means toggling the clicked item into or out of the selection.
=item GDK_MODIFIER_INTENT_NO_TEXT_INPUT: when any of these modifiers is pressed, the key event cannot produce a symbol directly. This is meant to be used for input methods, and for use cases like typeahead search.
=item GDK_MODIFIER_INTENT_SHIFT_GROUP: the modifier that switches between keyboard groups (AltGr on X11/Windows and Option/Alt on OS X).
=item GDK_MODIFIER_INTENT_DEFAULT_MOD_MASK: The set of modifier masks accepted as modifiers in accelerators. Needed because Command is mapped to MOD2 on OSX, which is widely used, but on X11 MOD2 is NumLock and using that for a mod key is problematic at best. Ref: https://bugzilla.gnome.org/show_bug.cgi?id=736125.


=end pod

#TE:0:GdkModifierIntent:
enum GdkModifierIntent is export (
  'GDK_MODIFIER_INTENT_PRIMARY_ACCELERATOR',
  'GDK_MODIFIER_INTENT_CONTEXT_MENU',
  'GDK_MODIFIER_INTENT_EXTEND_SELECTION',
  'GDK_MODIFIER_INTENT_MODIFY_SELECTION',
  'GDK_MODIFIER_INTENT_NO_TEXT_INPUT',
  'GDK_MODIFIER_INTENT_SHIFT_GROUP',
  'GDK_MODIFIER_INTENT_DEFAULT_MOD_MASK',
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkStatus

=end pod

#TE:0:GdkStatus:
enum GdkStatus is export (
  'GDK_OK'          => 0,
  'GDK_ERROR'       => -1,
  'GDK_ERROR_PARAM' => -2,
  'GDK_ERROR_FILE'  => -3,
  'GDK_ERROR_MEM'   => -4
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkGrabStatus

Returned by C<gdk_device_grab()>, C<gdk_pointer_grab()> and C<gdk_keyboard_grab()> to
indicate success or the reason for the failure of the grab attempt.


=item GDK_GRAB_SUCCESS: the resource was successfully grabbed.
=item GDK_GRAB_ALREADY_GRABBED: the resource is actively grabbed by another client.
=item GDK_GRAB_INVALID_TIME: the resource was grabbed more recently than the specified time.
=item GDK_GRAB_NOT_VIEWABLE: the grab window or the I<confine_to> window are not viewable.
=item GDK_GRAB_FROZEN: the resource is frozen by an active grab of another client.
=item GDK_GRAB_FAILED: the grab failed for some other reason. Since 3.16


=end pod

#TE:0:GdkGrabStatus:
enum GdkGrabStatus is export (
  'GDK_GRAB_SUCCESS'         => 0,
  'GDK_GRAB_ALREADY_GRABBED' => 1,
  'GDK_GRAB_INVALID_TIME'    => 2,
  'GDK_GRAB_NOT_VIEWABLE'    => 3,
  'GDK_GRAB_FROZEN'          => 4,
  'GDK_GRAB_FAILED'          => 5
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkGrabOwnership

Defines how device grabs interact with other devices.


=item GDK_OWNERSHIP_NONE: All other devices’ events are allowed.
=item GDK_OWNERSHIP_WINDOW: Other devices’ events are blocked for the grab window.
=item GDK_OWNERSHIP_APPLICATION: Other devices’ events are blocked for the whole application.


=end pod

#TE:0:GdkGrabOwnership:
enum GdkGrabOwnership is export (
  'GDK_OWNERSHIP_NONE',
  'GDK_OWNERSHIP_WINDOW',
  'GDK_OWNERSHIP_APPLICATION'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkEventMask

A set of bit-flags to indicate which events a window is to receive.
Most of these masks map onto one or more of the B<Gnome::Gdk3::EventType> event types
above.

See the [input handling overview][chap-input-handling] for details of
[event masks][event-masks] and [event propagation][event-propagation].

C<GDK_POINTER_MOTION_HINT_MASK> is deprecated. It is a special mask
to reduce the number of C<GDK_MOTION_NOTIFY> events received. When using
C<GDK_POINTER_MOTION_HINT_MASK>, fewer C<GDK_MOTION_NOTIFY> events will
be sent, some of which are marked as a hint (the is_hint member is
C<1>). To receive more motion events after a motion hint event,
the application needs to asks for more, by calling
C<gdk_event_request_motions()>.

Since GTK 3.8, motion events are already compressed by default, independent
of this mechanism. This compression can be disabled with
C<gdk_window_set_event_compression()>. See the documentation of that function
for details.

If C<GDK_TOUCH_MASK> is enabled, the window will receive touch events
from touch-enabled devices. Those will come as sequences of B<Gnome::Gdk3::EventTouch>
with type C<GDK_TOUCH_UPDATE>, enclosed by two events with
type C<GDK_TOUCH_BEGIN> and C<GDK_TOUCH_END> (or C<GDK_TOUCH_CANCEL>).
C<gdk_event_get_event_sequence()> returns the event sequence for these
events, so different sequences may be distinguished.


=item GDK_EXPOSURE_MASK: receive expose events
=item GDK_POINTER_MOTION_MASK: receive all pointer motion events
=item GDK_POINTER_MOTION_HINT_MASK: deprecated. see the explanation above
=item GDK_BUTTON_MOTION_MASK: receive pointer motion events while any button is pressed
=item GDK_BUTTON1_MOTION_MASK: receive pointer motion events while 1 button is pressed
=item GDK_BUTTON2_MOTION_MASK: receive pointer motion events while 2 button is pressed
=item GDK_BUTTON3_MOTION_MASK: receive pointer motion events while 3 button is pressed
=item GDK_BUTTON_PRESS_MASK: receive button press events
=item GDK_BUTTON_RELEASE_MASK: receive button release events
=item GDK_KEY_PRESS_MASK: receive key press events
=item GDK_KEY_RELEASE_MASK: receive key release events
=item GDK_ENTER_NOTIFY_MASK: receive window enter events
=item GDK_LEAVE_NOTIFY_MASK: receive window leave events
=item GDK_FOCUS_CHANGE_MASK: receive focus change events
=item GDK_STRUCTURE_MASK: receive events about window configuration change
=item GDK_PROPERTY_CHANGE_MASK: receive property change events
=item GDK_VISIBILITY_NOTIFY_MASK: receive visibility change events
=item GDK_PROXIMITY_IN_MASK: receive proximity in events
=item GDK_PROXIMITY_OUT_MASK: receive proximity out events
=item GDK_SUBSTRUCTURE_MASK: receive events about window configuration changes of child windows
=item GDK_SCROLL_MASK: receive scroll events
=item GDK_TOUCH_MASK: receive touch events. Since 3.4
=item GDK_SMOOTH_SCROLL_MASK: receive smooth scrolling events. Since 3.4
=item GDK_TABLET_PAD_MASK: receive tablet pad events. Since 3.22
=item GDK_ALL_EVENTS_MASK: the combination of all the above event masks.


=end pod

#TE:0:GdkEventMask:
enum GdkEventMask is export (
  'GDK_EXPOSURE_MASK'             => 1 +< 1,
  'GDK_POINTER_MOTION_MASK'       => 1 +< 2,
  'GDK_POINTER_MOTION_HINT_MASK'  => 1 +< 3,
  'GDK_BUTTON_MOTION_MASK'        => 1 +< 4,
  'GDK_BUTTON1_MOTION_MASK'       => 1 +< 5,
  'GDK_BUTTON2_MOTION_MASK'       => 1 +< 6,
  'GDK_BUTTON3_MOTION_MASK'       => 1 +< 7,
  'GDK_BUTTON_PRESS_MASK'         => 1 +< 8,
  'GDK_BUTTON_RELEASE_MASK'       => 1 +< 9,
  'GDK_KEY_PRESS_MASK'            => 1 +< 10,
  'GDK_KEY_RELEASE_MASK'          => 1 +< 11,
  'GDK_ENTER_NOTIFY_MASK'         => 1 +< 12,
  'GDK_LEAVE_NOTIFY_MASK'         => 1 +< 13,
  'GDK_FOCUS_CHANGE_MASK'         => 1 +< 14,
  'GDK_STRUCTURE_MASK'            => 1 +< 15,
  'GDK_PROPERTY_CHANGE_MASK'      => 1 +< 16,
  'GDK_VISIBILITY_NOTIFY_MASK'    => 1 +< 17,
  'GDK_PROXIMITY_IN_MASK'         => 1 +< 18,
  'GDK_PROXIMITY_OUT_MASK'        => 1 +< 19,
  'GDK_SUBSTRUCTURE_MASK'         => 1 +< 20,
  'GDK_SCROLL_MASK'               => 1 +< 21,
  'GDK_TOUCH_MASK'                => 1 +< 22,
  'GDK_SMOOTH_SCROLL_MASK'        => 1 +< 23,
  'GDK_TOUCHPAD_GESTURE_MASK'     => 1 +< 24,
  'GDK_TABLET_PAD_MASK'           => 1 +< 25,
  'GDK_ALL_EVENTS_MASK'           => 0x3FFFFFE
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkGLError

Error enumeration for B<Gnome::Gdk3::GLContext>.

Since: 3.16


=item GDK_GL_ERROR_NOT_AVAILABLE: OpenGL support is not available
=item GDK_GL_ERROR_UNSUPPORTED_FORMAT: The requested visual format is not supported
=item GDK_GL_ERROR_UNSUPPORTED_PROFILE: The requested profile is not supported


=end pod

#TE:0:GdkGLError:
enum GdkGLError is export (
  'GDK_GL_ERROR_NOT_AVAILABLE',
  'GDK_GL_ERROR_UNSUPPORTED_FORMAT',
  'GDK_GL_ERROR_UNSUPPORTED_PROFILE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkWindowTypeHint

These are hints for the window manager that indicate what type of function
the window has. The window manager can use this when determining decoration
and behaviour of the window. The hint must be set before mapping the window.

See the [Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec)
specification for more details about window types.


=item GDK_WINDOW_TYPE_HINT_NORMAL: Normal toplevel window.
=item GDK_WINDOW_TYPE_HINT_DIALOG: Dialog window.
=item GDK_WINDOW_TYPE_HINT_MENU: Window used to implement a menu; GTK+ uses this hint only for torn-off menus, see B<Gnome::Gtk3::TearoffMenuItem>.
=item GDK_WINDOW_TYPE_HINT_TOOLBAR: Window used to implement toolbars.
=item GDK_WINDOW_TYPE_HINT_SPLASHSCREEN: Window used to display a splash screen during application startup.
=item GDK_WINDOW_TYPE_HINT_UTILITY: Utility windows which are not detached toolbars or dialogs.
=item GDK_WINDOW_TYPE_HINT_DOCK: Used for creating dock or panel windows.
=item GDK_WINDOW_TYPE_HINT_DESKTOP: Used for creating the desktop background window.
=item GDK_WINDOW_TYPE_HINT_DROPDOWN_MENU: A menu that belongs to a menubar.
=item GDK_WINDOW_TYPE_HINT_POPUP_MENU: A menu that does not belong to a menubar, e.g. a context menu.
=item GDK_WINDOW_TYPE_HINT_TOOLTIP: A tooltip.
=item GDK_WINDOW_TYPE_HINT_NOTIFICATION: A notification - typically a “bubble” that belongs to a status icon.
=item GDK_WINDOW_TYPE_HINT_COMBO: A popup from a combo box.
=item GDK_WINDOW_TYPE_HINT_DND: A window that is used to implement a DND cursor.


=end pod

#TE:0:GdkWindowTypeHint:
enum GdkWindowTypeHint is export (
  'GDK_WINDOW_TYPE_HINT_NORMAL',
  'GDK_WINDOW_TYPE_HINT_DIALOG',
  'GDK_WINDOW_TYPE_HINT_TOOLBAR',
  'GDK_WINDOW_TYPE_HINT_SPLASHSCREEN',
  'GDK_WINDOW_TYPE_HINT_UTILITY',
  'GDK_WINDOW_TYPE_HINT_DOCK',
  'GDK_WINDOW_TYPE_HINT_DESKTOP',
  'GDK_WINDOW_TYPE_HINT_TOOLTIP',
  'GDK_WINDOW_TYPE_HINT_NOTIFICATION',
  'GDK_WINDOW_TYPE_HINT_COMBO',
  'GDK_WINDOW_TYPE_HINT_DND'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkAxisUse

An enumeration describing the way in which a device
axis (valuator) maps onto the predefined valuator
types that GTK+ understands.

Note that the X and Y axes are not really needed; pointer devices
report their location via the x/y members of events regardless. Whether
X and Y are present as axes depends on the GDK backend.


=item GDK_AXIS_IGNORE: the axis is ignored.
=item GDK_AXIS_X: the axis is used as the x axis.
=item GDK_AXIS_Y: the axis is used as the y axis.
=item GDK_AXIS_PRESSURE: the axis is used for pressure information.
=item GDK_AXIS_XTILT: the axis is used for x tilt information.
=item GDK_AXIS_YTILT: the axis is used for y tilt information.
=item GDK_AXIS_WHEEL: the axis is used for wheel information.
=item GDK_AXIS_DISTANCE: the axis is used for pen/tablet distance information. (Since: 3.22)
=item GDK_AXIS_ROTATION: the axis is used for pen rotation information. (Since: 3.22)
=item GDK_AXIS_SLIDER: the axis is used for pen slider information. (Since: 3.22)
=item GDK_AXIS_LAST: a constant equal to the numerically highest axis value.


=end pod

#TE:0:GdkAxisUse:
enum GdkAxisUse is export (
  'GDK_AXIS_IGNORE',
  'GDK_AXIS_X',
  'GDK_AXIS_Y',
  'GDK_AXIS_PRESSURE',
  'GDK_AXIS_XTILT',
  'GDK_AXIS_YTILT',
  'GDK_AXIS_WHEEL',
  'GDK_AXIS_DISTANCE',
  'GDK_AXIS_ROTATION',
  'GDK_AXIS_SLIDER',
  'GDK_AXIS_LAST'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkAxisFlags

Flags describing the current capabilities of a device/tool.

Since: 3.22


=item GDK_AXIS_FLAG_X: X axis is present
=item GDK_AXIS_FLAG_Y: Y axis is present
=item GDK_AXIS_FLAG_PRESSURE: Pressure axis is present
=item GDK_AXIS_FLAG_XTILT: X tilt axis is present
=item GDK_AXIS_FLAG_YTILT: Y tilt axis is present
=item GDK_AXIS_FLAG_WHEEL: Wheel axis is present
=item GDK_AXIS_FLAG_DISTANCE: Distance axis is present
=item GDK_AXIS_FLAG_ROTATION: Z-axis rotation is present
=item GDK_AXIS_FLAG_SLIDER: Slider axis is present


=end pod

#TE:0:GdkAxisFlags:
enum GdkAxisFlags is export (
  'GDK_AXIS_FLAG_X'        => 1 +< GDK_AXIS_X,
  'GDK_AXIS_FLAG_Y'        => 1 +< GDK_AXIS_Y,
  'GDK_AXIS_FLAG_PRESSURE' => 1 +< GDK_AXIS_PRESSURE,
  'GDK_AXIS_FLAG_XTILT'    => 1 +< GDK_AXIS_XTILT,
  'GDK_AXIS_FLAG_YTILT'    => 1 +< GDK_AXIS_YTILT,
  'GDK_AXIS_FLAG_WHEEL'    => 1 +< GDK_AXIS_WHEEL,
  'GDK_AXIS_FLAG_DISTANCE' => 1 +< GDK_AXIS_DISTANCE,
  'GDK_AXIS_FLAG_ROTATION' => 1 +< GDK_AXIS_ROTATION,
  'GDK_AXIS_FLAG_SLIDER'   => 1 +< GDK_AXIS_SLIDER,
);

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkRectangle

Defines the position and size of a rectangle. It is identical to
B<cairo_rectangle_int_t>.

=item Int $.x;
=item Int $.y;
=item Int $.width;
=item Int $.height;

=end pod

#TT:0:N-GdkRectangle:
class N-GdkRectangle is export is repr('CStruct') {
  has int32 $.x;
  has int32 $.y;
  has int32 $.width;
  has int32 $.height;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkPoint

Defines the x and y coordinates of a point.


=item Int $.x: the x coordinate of the point.
=item Int $.y: the y coordinate of the point.


=end pod

#TT:0:N-GdkPoint:
class N-GdkPoint is export is repr('CStruct') {
  has int32 $.x;
  has int32 $.y;
}



















=finish
#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkByteOrder

A set of values describing the possible byte-orders
for storing pixel values in memory.


=item GDK_LSB_FIRST: The values are stored with the least-significant byte first. For instance, the 32-bit value 0xffeecc would be stored in memory as 0xcc, 0xee, 0xff, 0x00.
=item GDK_MSB_FIRST: The values are stored with the most-significant byte first. For instance, the 32-bit value 0xffeecc would be stored in memory as 0x00, 0xff, 0xee, 0xcc.


=end pod

#TE:0:GdkByteOrder:
enum GdkByteOrder is export (
  'GDK_LSB_FIRST',
  'GDK_MSB_FIRST'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkRectangle

Defines the position and size of a rectangle.

=item $.x
=item $.y
=item $.width
=item $.height

=end pod

class GdkRectangle is repr('CStruct') is export {
  has int32 $.x;
  has int32 $.y;
  has int32 $.width;
  has int32 $.height;
};

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkModifierType

A set of bit-flags to indicate the state of modifier keys and mouse buttons in various event types. Typical modifier keys are Shift, Control, Meta, Super, Hyper, Alt, Compose, Apple, CapsLock or ShiftLock.

Like the X Window System, GDK supports 8 modifier keys and 5 mouse buttons.

Since 2.10, GDK recognizes which of the Meta, Super or Hyper keys are mapped to Mod2 - Mod5, and indicates this by setting C<GDK_SUPER_MASK>, C<GDK_HYPER_MASK> or C<GDK_META_MASK> in the state field of key events.

Note that GDK may add internal values to events which include reserved values such as C<GDK_MODIFIER_RESERVED_13_MASK>. Your code should preserve and ignore them.  You can use C<GDK_MODIFIER_MASK> to remove all reserved values.

Also note that the GDK X backend interprets button press events for button 4-7 as scroll events, so C<GDK_BUTTON4_MASK> and C<GDK_BUTTON5_MASK> will never be set.

=item GDK_SHIFT_MASK: the Shift key.
=item GDK_LOCK_MASK: a Lock key (depending on the modifier mapping of the X server this may either be CapsLock or ShiftLock).
=item GDK_CONTROL_MASK: the Control key.
=item GDK_MOD1_MASK: the fourth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier, but normally it is the Alt key).
=item GDK_MOD2_MASK: the fifth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_MOD3_MASK: the sixth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_MOD4_MASK: the seventh modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_MOD5_MASK: the eighth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_BUTTON1_MASK: the first mouse button.
=item GDK_BUTTON2_MASK: the second mouse button.
=item GDK_BUTTON3_MASK: the third mouse button.
=item GDK_BUTTON4_MASK: the fourth mouse button.
=item GDK_BUTTON5_MASK: the fifth mouse button.
=item GDK_MODIFIER_RESERVED_13_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_14_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_15_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_16_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_17_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_18_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_19_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_20_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_21_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_22_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_23_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_24_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_25_MASK: A reserved bit flag; do not use in your own code
=item GDK_SUPER_MASK: the Super modifier. Since 2.10
=item GDK_HYPER_MASK: the Hyper modifier. Since 2.10
=item GDK_META_MASK: the Meta modifier. Since 2.10
=item GDK_MODIFIER_RESERVED_29_MASK: A reserved bit flag; do not use in your own code
=item GDK_RELEASE_MASK: not used in GDK itself. GTK+ uses it to differentiate between (keyval, modifiers) pairs from key press and release events.
=item GDK_MODIFIER_MASK: a mask covering all modifier types.
=end pod

#TE:0:GdkModifierType:
enum GdkModifierType is export (
  GDK_SHIFT_MASK    => 1 +< 0,
  GDK_LOCK_MASK     => 1 +< 1,
  GDK_CONTROL_MASK  => 1 +< 2,
  GDK_MOD1_MASK     => 1 +< 3,
  GDK_MOD2_MASK     => 1 +< 4,
  GDK_MOD3_MASK     => 1 +< 5,
  GDK_MOD4_MASK     => 1 +< 6,
  GDK_MOD5_MASK     => 1 +< 7,
  GDK_BUTTON1_MASK  => 1 +< 8,
  GDK_BUTTON2_MASK  => 1 +< 9,
  GDK_BUTTON3_MASK  => 1 +< 10,
  GDK_BUTTON4_MASK  => 1 +< 11,
  GDK_BUTTON5_MASK  => 1 +< 12,

  GDK_MODIFIER_RESERVED_13_MASK  => 1 +< 13,
  GDK_MODIFIER_RESERVED_14_MASK  => 1 +< 14,
  GDK_MODIFIER_RESERVED_15_MASK  => 1 +< 15,
  GDK_MODIFIER_RESERVED_16_MASK  => 1 +< 16,
  GDK_MODIFIER_RESERVED_17_MASK  => 1 +< 17,
  GDK_MODIFIER_RESERVED_18_MASK  => 1 +< 18,
  GDK_MODIFIER_RESERVED_19_MASK  => 1 +< 19,
  GDK_MODIFIER_RESERVED_20_MASK  => 1 +< 20,
  GDK_MODIFIER_RESERVED_21_MASK  => 1 +< 21,
  GDK_MODIFIER_RESERVED_22_MASK  => 1 +< 22,
  GDK_MODIFIER_RESERVED_23_MASK  => 1 +< 23,
  GDK_MODIFIER_RESERVED_24_MASK  => 1 +< 24,
  GDK_MODIFIER_RESERVED_25_MASK  => 1 +< 25,

  #`{{ The next few modifiers are used by XKB, so we skip to the end.
    Bits 15 - 25 are currently unused. Bit 29 is used internally.
 }}

  GDK_SUPER_MASK    => 1 +< 26,
  GDK_HYPER_MASK    => 1 +< 27,
  GDK_META_MASK     => 1 +< 28,

  GDK_MODIFIER_RESERVED_29_MASK  => 1 +< 29,

  GDK_RELEASE_MASK  => 1 +< 30,

  # Combination of GDK_SHIFT_MASK..GDK_BUTTON5_MASK + GDK_SUPER_MASK
  #   + GDK_HYPER_MASK + GDK_META_MASK + GDK_RELEASE_MASK */
  GDK_MODIFIER_MASK => 0x5c001fff
);

enum GdkWindowTypeHint is export <
  GDK_WINDOW_TYPE_HINT_NORMAL
  GDK_WINDOW_TYPE_HINT_DIALOG
  GDK_WINDOW_TYPE_HINT_MENU
  GDK_WINDOW_TYPE_HINT_TOOLBAR
  GDK_WINDOW_TYPE_HINT_SPLASHSCREEN
  GDK_WINDOW_TYPE_HINT_UTILITY
  GDK_WINDOW_TYPE_HINT_DOCK
  GDK_WINDOW_TYPE_HINT_DESKTOP
  GDK_WINDOW_TYPE_HINT_DROPDOWN_MENU
  GDK_WINDOW_TYPE_HINT_POPUP_MENU
  GDK_WINDOW_TYPE_HINT_TOOLTIP
  GDK_WINDOW_TYPE_HINT_NOTIFICATION
  GDK_WINDOW_TYPE_HINT_COMBO
  GDK_WINDOW_TYPE_HINT_DND
>;
