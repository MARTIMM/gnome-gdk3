#TL:1:Gnome::Gdk3::Device:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Device

Object representing an input device

=head1 Description

The B<Gnome::Gdk3::Device> object represents a single input device, such as a keyboard, a mouse, a touchpad, etc.

See the B<Gnome::Gdk3::DeviceManager> documentation for more information about the various kinds of master and slave devices, and their relationships.

=begin comment
A screen device can be retrieved from a widget via the following steps
=item Call C<.get-window()> from B<Gnome::Gtk3::Widget>. This returns a native B<Gnome::Gdk3::Window>.
=item Then call C<.get_screen()> from B<Gnome::Gdk3::Window> to get a B<Gnome::Gdk3::Screen>.
=end comment


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::Device;
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

#use Gnome::Gdk3::Types:api<1>;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkdevice.h
# https://developer.gnome.org/gdk3/stable/GdkDevice.html
unit class Gnome::Gdk3::Device:auth<github:MARTIMM>:api<1>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkDeviceType

Indicates the device type. See [above][GdkDeviceManager.description]
for more information about the meaning of these device types.

=item GDK_DEVICE_TYPE_MASTER: Device is a master (or virtual) device. There will be an associated focus indicator on the screen.
=item GDK_DEVICE_TYPE_SLAVE: Device is a slave (or physical) device.
=item GDK_DEVICE_TYPE_FLOATING: Device is a physical device, currently not attached to any virtual device.

=end pod

#TE:0:GdkDeviceType:
enum GdkDeviceType is export (
  'GDK_DEVICE_TYPE_MASTER',
  'GDK_DEVICE_TYPE_SLAVE',
  'GDK_DEVICE_TYPE_FLOATING'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkInputMode

An enumeration that describes the mode of an input device.

=item GDK_MODE_DISABLED: the device is disabled and will not report any events.
=item GDK_MODE_SCREEN: the device is enabled. The device’s coordinate space maps to the entire screen.
=item GDK_MODE_WINDOW: the device is enabled. The device’s coordinate space is mapped to a single window. The manner in which this window is chosen is undefined, but it will typically be the same way in which the focus window for key events is determined.

=end pod

#TE:0:GdkInputMode:
enum GdkInputMode is export (
  'GDK_MODE_DISABLED',
  'GDK_MODE_SCREEN',
  'GDK_MODE_WINDOW'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkInputSource

An enumeration describing the type of an input device in general terms.

=item GDK_SOURCE_MOUSE: the device is a mouse. (This will be reported for the core pointer, even if it is something else, such as a trackball.)
=item GDK_SOURCE_PEN: the device is a stylus of a graphics tablet or similar device.
=item GDK_SOURCE_ERASER: the device is an eraser. Typically, this would be the other end of a stylus on a graphics tablet.
=item GDK_SOURCE_CURSOR: the device is a graphics tablet “puck” or similar device.
=item GDK_SOURCE_KEYBOARD: the device is a keyboard.
=item GDK_SOURCE_TOUCHSCREEN: the device is a direct-input touch device, such as a touchscreen or tablet.
=item GDK_SOURCE_TOUCHPAD: the device is an indirect touch device, such as a touchpad.
=item GDK_SOURCE_TRACKPOINT: the device is a trackpoint.
=item GDK_SOURCE_TABLET_PAD: the device is a "pad", a collection of buttons, rings and strips found in drawing tablets.

=end pod

#TE:0:GdkInputSource:
enum GdkInputSource is export (
  'GDK_SOURCE_MOUSE',
  'GDK_SOURCE_PEN',
  'GDK_SOURCE_ERASER',
  'GDK_SOURCE_CURSOR',
  'GDK_SOURCE_KEYBOARD',
  'GDK_SOURCE_TOUCHSCREEN',
  'GDK_SOURCE_TOUCHPAD',
  'GDK_SOURCE_TRACKPOINT',
  'GDK_SOURCE_TABLET_PAD'
);

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GdkTimeCoord

A B<Gnome::Gdk3::TimeCoord> stores a single event in a motion history.

=item UInt $.time: The timestamp for this event.
=item Num $.axes: the values of the device’s axes.

=end pod

#TT:0:N-GdkTimeCoord:
class N-GdkTimeCoord is export is repr('CStruct') {
  has guint32 $.time;
  has gdouble $.axes[GDK_MAX_TIMECOORD_AXES];
}
}}

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :native-object

Create a Device object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:4:new(:native-object):
submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<tool-changed>, :w0<changed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gdk3::Device' #`{{ or %options<GdkDevice> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gdk_device_new___x___($no);
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
        $no = _gdk_device_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GdkDevice');
  }

#`{{
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<changed>, :w1<tool-changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk3::Device';

  if %options<native-object>:exists {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message(
        "Unsupported options for {self.^name}: %options.keys.join(', ')"
      )
    );
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GdkDevice');
}}
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gdk_device_$native-sub"); };
  try { $s = &::("gdk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gdk_' /;

  self._set-class-name-of-sub('GdkDevice');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_name:
=begin pod
=head2 [[gdk_] device_] get_name

Determines the name of the device.

Returns: a name

Since: 2.20

  method gdk_device_get_name ( --> Str  )


=end pod

sub gdk_device_get_name ( N-GObject $device )
  returns Str
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_has_cursor:
=begin pod
=head2 [[gdk_] device_] get_has_cursor

Determines whether the pointer follows device motion.
This is not meaningful for keyboard devices, which don't have a pointer.

Returns: C<1> if the pointer follows device motion

Since: 2.20

  method gdk_device_get_has_cursor ( --> Int  )


=end pod

sub gdk_device_get_has_cursor ( N-GObject $device )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_source:
=begin pod
=head2 [[gdk_] device_] get_source

Determines the type of the device.

Returns: a B<Gnome::Gdk3::InputSource>

Since: 2.20

  method gdk_device_get_source ( --> GdkInputSource  )


=end pod

sub gdk_device_get_source ( N-GObject $device )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_mode:
=begin pod
=head2 [[gdk_] device_] get_mode

Determines the mode of the device.

Returns: a B<Gnome::Gdk3::InputSource>

Since: 2.20

  method gdk_device_get_mode ( --> GdkInputMode  )


=end pod

sub gdk_device_get_mode ( N-GObject $device )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_set_mode:
=begin pod
=head2 [[gdk_] device_] set_mode

Sets a the mode of an input device. The mode controls if the
device is active and whether the device’s range is mapped to the
entire screen or to a single window.

Note: This is only meaningful for floating devices, master devices (and
slaves connected to these) drive the pointer cursor, which is not limited
by the input mode.

Returns: C<1> if the mode was successfully changed.

  method gdk_device_set_mode ( GdkInputMode $mode --> Int  )

=item GdkInputMode $mode; the input mode.

=end pod

sub gdk_device_set_mode ( N-GObject $device, int32 $mode )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_n_keys:
=begin pod
=head2 [[gdk_] device_] get_n_keys

Returns the number of keys the device currently has.

Returns: the number of keys.

Since: 2.24

  method gdk_device_get_n_keys ( --> Int  )


=end pod

sub gdk_device_get_n_keys ( N-GObject $device )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_key:
=begin pod
=head2 [[gdk_] device_] get_key

If I<index_> has a valid keyval, this function will return C<1>
and fill in I<keyval> and I<modifiers> with the keyval settings.

Returns: C<1> if keyval is set for I<index>.

Since: 2.20

  method gdk_device_get_key ( UInt $index_, UInt $keyval, GdkModifierType $modifiers --> Int  )

=item UInt $index_; the index of the macro button to get.
=item UInt $keyval; (out): return value for the keyval.
=item GdkModifierType $modifiers; (out): return value for modifiers.

=end pod

sub gdk_device_get_key ( N-GObject $device, uint32 $index_, uint32 $keyval, int32 $modifiers )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_set_key:
=begin pod
=head2 [[gdk_] device_] set_key

Specifies the X key event to generate when a macro button of a device
is pressed.

  method gdk_device_set_key ( UInt $index_, UInt $keyval, GdkModifierType $modifiers )

=item UInt $index_; the index of the macro button to set
=item UInt $keyval; the keyval to generate
=item GdkModifierType $modifiers; the modifiers to set

=end pod

sub gdk_device_set_key ( N-GObject $device, uint32 $index_, uint32 $keyval, int32 $modifiers )
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_axis_use:
=begin pod
=head2 [[gdk_] device_] get_axis_use

Returns the axis use for I<index_>.

Returns: a B<Gnome::Gdk3::AxisUse> specifying how the axis is used.

Since: 2.20

  method gdk_device_get_axis_use ( UInt $index_ --> GdkAxisUse  )

=item UInt $index_; the index of the axis.

=end pod

sub gdk_device_get_axis_use ( N-GObject $device, uint32 $index_ )
  returns GdkAxisUse
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_set_axis_use:
=begin pod
=head2 [[gdk_] device_] set_axis_use

Specifies how an axis of a device is used.

  method gdk_device_set_axis_use ( UInt $index_, GdkAxisUse $use )

=item UInt $index_; the index of the axis
=item GdkAxisUse $use; specifies how the axis is used

=end pod

sub gdk_device_set_axis_use ( N-GObject $device, uint32 $index_, GdkAxisUse $use )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_state:
=begin pod
=head2 [[gdk_] device_] get_state

Gets the current state of a pointer device relative to I<window>. As a slave
device’s coordinates are those of its master pointer, this
function may not be called on devices of type C<GDK_DEVICE_TYPE_SLAVE>,
unless there is an ongoing grab on them. See C<gdk_device_grab()>.

  method gdk_device_get_state ( N-GObject $window, Num $axes, GdkModifierType $mask )

=item N-GObject $window; a B<Gnome::Gdk3::Window>.
=item Num $axes; (nullable) (array): an array of doubles to store the values of the axes of I<device> in, or C<Any>.
=item GdkModifierType $mask; (optional) (out): location to store the modifiers, or C<Any>.

=end pod

sub gdk_device_get_state ( N-GObject $device, N-GObject $window, num64 $axes, int32 $mask )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_position:
=begin pod
=head2 [[gdk_] device_] get_position

Gets the current location of I<device>. As a slave device
coordinates are those of its master pointer, This function
may not be called on devices of type C<GDK_DEVICE_TYPE_SLAVE>,
unless there is an ongoing grab on them, see C<gdk_device_grab()>.

Since: 3.0

  method gdk_device_get_position ( N-GObject $screen, Int $x, Int $y )

=item N-GObject $screen; (out) (transfer none) (allow-none): location to store the B<Gnome::Gdk3::Screen> the I<device> is on, or C<Any>.
=item Int $x; (out) (allow-none): location to store root window X coordinate of I<device>, or C<Any>.
=item Int $y; (out) (allow-none): location to store root window Y coordinate of I<device>, or C<Any>.

=end pod

sub gdk_device_get_position ( N-GObject $device, N-GObject $screen, int32 $x, int32 $y )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_window_at_position:
=begin pod
=head2 [[gdk_] device_] get_window_at_position

Obtains the window underneath I<device>, returning the location of the device in I<win_x> and I<win_y>. Returns
C<Any> if the window tree under I<device> is not known to GDK (for example, belongs to another application).

As a slave device coordinates are those of its master pointer, This
function may not be called on devices of type C<GDK_DEVICE_TYPE_SLAVE>,
unless there is an ongoing grab on them, see C<gdk_device_grab()>.

Returns: (nullable) (transfer none): the B<Gnome::Gdk3::Window> under the
device position, or C<Any>.

Since: 3.0

  method gdk_device_get_window_at_position ( Int $win_x, Int $win_y --> N-GObject  )

=item Int $win_x; (out) (allow-none): return location for the X coordinate of the device location, relative to the window origin, or C<Any>.
=item Int $win_y; (out) (allow-none): return location for the Y coordinate of the device location, relative to the window origin, or C<Any>.

=end pod

sub gdk_device_get_window_at_position ( N-GObject $device, int32 $win_x, int32 $win_y )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_position_double:
=begin pod
=head2 [[gdk_] device_] get_position_double

Gets the current location of I<device> in double precision. As a slave device's
coordinates are those of its master pointer, this function
may not be called on devices of type C<GDK_DEVICE_TYPE_SLAVE>,
unless there is an ongoing grab on them. See C<gdk_device_grab()>.

Since: 3.10

  method gdk_device_get_position_double ( N-GObject $screen, Num $x, Num $y )

=item N-GObject $screen; (out) (transfer none) (allow-none): location to store the B<Gnome::Gdk3::Screen> the I<device> is on, or C<Any>.
=item Num $x; (out) (allow-none): location to store root window X coordinate of I<device>, or C<Any>.
=item Num $y; (out) (allow-none): location to store root window Y coordinate of I<device>, or C<Any>.

=end pod

sub gdk_device_get_position_double ( N-GObject $device, N-GObject $screen, num64 $x, num64 $y )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_window_at_position_double:
=begin pod
=head2 [[gdk_] device_] get_window_at_position_double

Obtains the window underneath I<device>, returning the location of the device in I<win_x> and I<win_y> in
double precision. Returns C<Any> if the window tree under I<device> is not known to GDK (for example,
belongs to another application).

As a slave device coordinates are those of its master pointer, This
function may not be called on devices of type C<GDK_DEVICE_TYPE_SLAVE>,
unless there is an ongoing grab on them, see C<gdk_device_grab()>.

Returns: (nullable) (transfer none): the B<Gnome::Gdk3::Window> under the
device position, or C<Any>.

Since: 3.0

  method gdk_device_get_window_at_position_double ( Num $win_x, Num $win_y --> N-GObject  )

=item Num $win_x; (out) (allow-none): return location for the X coordinate of the device location, relative to the window origin, or C<Any>.
=item Num $win_y; (out) (allow-none): return location for the Y coordinate of the device location, relative to the window origin, or C<Any>.

=end pod

sub gdk_device_get_window_at_position_double ( N-GObject $device, num64 $win_x, num64 $win_y )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_history:
=begin pod
=head2 [[gdk_] device_] get_history

Obtains the motion history for a pointer device; given a starting and
ending timestamp, return all events in the motion history for
the device in the given range of time. Some windowing systems
do not support motion history, in which case, C<0> will
be returned. (This is not distinguishable from the case where
motion history is supported and no events were found.)

Note that there is also C<gdk_window_set_event_compression()> to get
more motion events delivered directly, independent of the windowing
system.

Returns: C<1> if the windowing system supports motion history and
at least one event was found.

  method gdk_device_get_history ( N-GObject $window, UInt $start, UInt $stop, GdkTimeCoord $events, Int $n_events --> Int  )

=item N-GObject $window; the window with respect to which which the event coordinates will be reported
=item UInt $start; starting timestamp for range of events to return
=item UInt $stop; ending timestamp for the range of events to return
=item GdkTimeCoord $events; (array length=n_events) (out) (transfer full) (optional): location to store a newly-allocated array of B<Gnome::Gdk3::TimeCoord>, or C<Any>
=item Int $n_events; (out) (optional): location to store the length of I<events>, or C<Any>

=end pod

sub gdk_device_get_history ( N-GObject $device, N-GObject $window, uint32 $start, uint32 $stop, GdkTimeCoord $events, int32 $n_events )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_free_history:
=begin pod
=head2 [[gdk_] device_] free_history

Frees an array of B<Gnome::Gdk3::TimeCoord> that was returned by C<gdk_device_get_history()>.

  method gdk_device_free_history ( GdkTimeCoord $events, Int $n_events )

=item GdkTimeCoord $events; (array length=n_events): an array of B<Gnome::Gdk3::TimeCoord>.
=item Int $n_events; the length of the array.

=end pod

sub gdk_device_free_history ( GdkTimeCoord $events, int32 $n_events )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_n_axes:
=begin pod
=head2 [[gdk_] device_] get_n_axes

Returns the number of axes the device currently has.

Returns: the number of axes.

Since: 3.0

  method gdk_device_get_n_axes ( --> Int  )


=end pod

sub gdk_device_get_n_axes ( N-GObject $device )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_list_axes:
=begin pod
=head2 [[gdk_] device_] list_axes

Returns a B<GList> of B<Gnome::Gdk3::Atoms>, containing the labels for
the axes that I<device> currently has.

Returns: (transfer container) (element-type B<Gnome::Gdk3::Atom>):
A B<GList> of B<Gnome::Gdk3::Atoms>, free with C<g_list_free()>.

Since: 3.0

  method gdk_device_list_axes ( --> N-GList  )


=end pod

sub gdk_device_list_axes ( N-GObject $device )
  returns N-GList
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_axis_value:
=begin pod
=head2 [[gdk_] device_] get_axis_value

Interprets an array of double as axis values for a given device,
and locates the value in the array for a given axis label, as returned
by C<gdk_device_list_axes()>

Returns: C<1> if the given axis use was found, otherwise C<0>.

Since: 3.0

  method gdk_device_get_axis_value ( Num $axes, GdkAtom $axis_label, Num $value --> Int  )

=item Num $axes; (array): pointer to an array of axes
=item GdkAtom $axis_label; B<Gnome::Gdk3::Atom> with the axis label.
=item Num $value; (out): location to store the found value.

=end pod

sub gdk_device_get_axis_value ( N-GObject $device, num64 $axes, GdkAtom $axis_label, num64 $value )
  returns int32
  is native(&gdk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_axis:
=begin pod
=head2 [[gdk_] device_] get_axis

Interprets an array of double as axis values for a given device,
and locates the value in the array for a given axis use.

Returns: C<1> if the given axis use was found, otherwise C<0>

  method gdk_device_get_axis ( Num $axes, GdkAxisUse $use, Num $value --> Int  )

=item Num $axes; (array): pointer to an array of axes
=item GdkAxisUse $use; the use to look for
=item Num $value; (out): location to store the found value.

=end pod

sub gdk_device_get_axis ( N-GObject $device, num64 $axes, GdkAxisUse $use, num64 $value )
  returns int32
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_display:
=begin pod
=head2 [[gdk_] device_] get_display

Returns the B<Gnome::Gdk3::Display> to which I<device> pertains.

Returns: (transfer none): a B<Gnome::Gdk3::Display>. This memory is owned
by GTK+, and must not be freed or unreffed.

Since: 3.0

  method gdk_device_get_display ( --> N-GObject  )


=end pod

sub gdk_device_get_display ( N-GObject $device )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_associated_device:
=begin pod
=head2 [[gdk_] device_] get_associated_device

Returns the associated device to I<device>, if I<device> is of type
C<GDK_DEVICE_TYPE_MASTER>, it will return the paired pointer or
keyboard.

If I<device> is of type C<GDK_DEVICE_TYPE_SLAVE>, it will return
the master device to which I<device> is attached to.

If I<device> is of type C<GDK_DEVICE_TYPE_FLOATING>, C<Any> will be
returned, as there is no associated device.

Returns: (nullable) (transfer none): The associated device, or
C<Any>

Since: 3.0

  method gdk_device_get_associated_device ( --> N-GObject  )


=end pod

sub gdk_device_get_associated_device ( N-GObject $device )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_list_slave_devices:
=begin pod
=head2 [[gdk_] device_] list_slave_devices

If the device if of type C<GDK_DEVICE_TYPE_MASTER>, it will return
the list of slave devices attached to it, otherwise it will return
C<Any>

Returns: (nullable) (transfer container) (element-type B<Gnome::Gdk3::Device>):
the list of slave devices, or C<Any>. The list must be
freed with C<g_list_free()>, the contents of the list are
owned by GTK+ and should not be freed.

  method gdk_device_list_slave_devices ( --> N-GList  )


=end pod

sub gdk_device_list_slave_devices ( N-GObject $device )
  returns N-GList
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_device_type:
=begin pod
=head2 [[gdk_] device_] get_device_type

Returns the device type for I<device>.

Returns: the B<Gnome::Gdk3::DeviceType> for I<device>.

Since: 3.0

  method gdk_device_get_device_type ( --> GdkDeviceType  )


=end pod

sub gdk_device_get_device_type ( N-GObject $device )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_warp:
=begin pod
=head2 gdk_device_warp

Warps I<device> in I<display> to the point I<x>,I<y> on
the screen I<screen>, unless the device is confined
to a window by a grab, in which case it will be moved
as far as allowed by the grab. Warping the pointer
creates events as if the user had moved the mouse
instantaneously to the destination.

Note that the pointer should normally be under the
control of the user. This function was added to cover
some rare use cases like keyboard navigation support
for the color picker in the B<Gnome::Gtk3::ColorSelectionDialog>.

Since: 3.0

  method gdk_device_warp ( N-GObject $screen, Int $x, Int $y )

=item N-GObject $screen; the screen to warp I<device> to.
=item Int $x; the X coordinate of the destination.
=item Int $y; the Y coordinate of the destination.

=end pod

sub gdk_device_warp ( N-GObject $device, N-GObject $screen, int32 $x, int32 $y )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_last_event_window:
=begin pod
=head2 [[gdk_] device_] get_last_event_window

Gets information about which window the given pointer device is in, based on events
that have been received so far from the display server. If another application
has a pointer grab, or this application has a grab with owner_events = C<0>,
C<Any> may be returned even if the pointer is physically over one of this
application's windows.

Returns: (transfer none) (allow-none): the last window the device

Since: 3.12

  method gdk_device_get_last_event_window ( --> N-GObject  )


=end pod

sub gdk_device_get_last_event_window ( N-GObject $device )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_vendor_id:
=begin pod
=head2 [[gdk_] device_] get_vendor_id

Returns the vendor ID of this device, or C<Any> if this information couldn't
be obtained. This ID is retrieved from the device, and is thus constant for
it.

This function, together with C<gdk_device_get_product_id()>, can be used to eg.
compose B<GSettings> paths to store settings for this device.

|[<!-- language="C" -->
static GSettings *
get_device_settings (B<Gnome::Gdk3::Device> *device)
{
const gchar *vendor, *product;
GSettings *settings;
B<Gnome::Gdk3::Device> *device;
gchar *path;

vendor = gdk_device_get_vendor_id (device);
product = gdk_device_get_product_id (device);

path = g_strdup_printf ("/org/example/app/devices/C<s>:C<s>/", vendor, product);
settings = g_settings_new_with_path (DEVICE_SCHEMA, path);
g_free (path);

return settings;
}
]|

Returns: (nullable): the vendor ID, or C<Any>

Since: 3.16

  method gdk_device_get_vendor_id ( --> Str  )


=end pod

sub gdk_device_get_vendor_id ( N-GObject $device )
  returns Str
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_product_id:
=begin pod
=head2 [[gdk_] device_] get_product_id

Returns the product ID of this device, or C<Any> if this information couldn't
be obtained. This ID is retrieved from the device, and is thus constant for
it. See C<gdk_device_get_vendor_id()> for more information.

Returns: (nullable): the product ID, or C<Any>

Since: 3.16

  method gdk_device_get_product_id ( --> Str  )


=end pod

sub gdk_device_get_product_id ( N-GObject $device )
  returns Str
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_seat:
=begin pod
=head2 [[gdk_] device_] get_seat

Returns the B<Gnome::Gdk3::Seat> the device belongs to.

Returns: (transfer none): A B<Gnome::Gdk3::Seat>. This memory is owned by GTK+ and
must not be freed.

Since: 3.20

  method gdk_device_get_seat ( --> N-GObject  )


=end pod

sub gdk_device_get_seat ( N-GObject $device )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_device_get_axes:
=begin pod
=head2 [[gdk_] device_] get_axes

Returns the axes currently available on the device.

Since: 3.22

  method gdk_device_get_axes ( --> GdkAxisFlags  )


=end pod

sub gdk_device_get_axes ( N-GObject $device )
  returns GdkAxisFlags
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, N-GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:0:changed:
=head3 changed

The I<changed> signal is emitted either when the B<Gnome::Gdk3::Device>
has changed the number of either axes or keys. For example
In X this will normally happen when the slave device routing
events through the master device changes (for example, user
switches from the USB mouse to a tablet), in that case the
master device will change to reflect the new slave device
axes and keys.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($device),
    *%user-options
  );

=item $device; the B<Gnome::Gdk3::Device> that changed.


=comment #TS:0:tool-changed:
=head3 tool-changed

The I<tool-changed> signal is emitted on pen/eraser
B<Gnome::Gdk3::Devices> whenever tools enter or leave proximity.

Since: 3.22

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($device),
    *%user-options
  );

=item $device; the native object for B<Gnome::Gdk3::Device> that changed.

=item $tool; The new current tool


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=begin comment
=comment #TP:0:display:
=head3 Device Display

The B<Gnome::Gdk3::Display> the B<Gnome::Gdk3::Device> pertains to.
Since: 3.0
Widget type: GDK_TYPE_DISPLAY

The B<Gnome::GObject::Value> type of property I<display> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:device-manager:
=head3 Device manager


The B<Gnome::Gdk3::DeviceManager> the B<Gnome::Gdk3::Device> pertains to.
Since: 3.0
Widget type: GDK_TYPE_DEVICE_MANAGER

The B<Gnome::GObject::Value> type of property I<device-manager> is C<G_TYPE_OBJECT>.

=comment #TP:0:name:
=head3 Device name


The device name.
Since: 3.0

The B<Gnome::GObject::Value> type of property I<name> is C<G_TYPE_STRING>.

=comment #TP:0:type:
=head3 Device type


Device role in the device manager.
Since: 3.0
Widget type: GDK_TYPE_DEVICE_TYPE

The B<Gnome::GObject::Value> type of property I<type> is C<G_TYPE_ENUM>.


=begin comment
=comment #TP:0:associated-device:
=head3 Associated device


Associated pointer or keyboard with this device, if any. Devices of type B<GDK_DEVICE_TYPE_MASTER>
always come in keyboard/pointer pairs. Other device types will have a C<Any> associated device.
Since: 3.0
Widget type: GDK_TYPE_DEVICE

The B<Gnome::GObject::Value> type of property I<associated-device> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:input-source:
=head3 Input source


Source type for the device.
Since: 3.0
Widget type: GDK_TYPE_INPUT_SOURCE

The B<Gnome::GObject::Value> type of property I<input-source> is C<G_TYPE_ENUM>.

=comment #TP:0:input-mode:
=head3 Input mode for the device

Input mode for the device
Default value: False


The B<Gnome::GObject::Value> type of property I<input-mode> is C<G_TYPE_ENUM>.

=comment #TP:0:has-cursor:
=head3 Whether the device has a cursor


Whether the device is represented by a cursor on the screen. Devices of type
C<GDK_DEVICE_TYPE_MASTER> will have C<1> here.
Since: 3.0

The B<Gnome::GObject::Value> type of property I<has-cursor> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:n-axes:
=head3 Number of axes in the device


Number of axes in the device.
Since: 3.0

The B<Gnome::GObject::Value> type of property I<n-axes> is C<G_TYPE_UINT>.

=comment #TP:0:vendor-id:
=head3 Vendor ID


Vendor ID of this device, see C<gdk_device_get_vendor_id()>.
Since: 3.16

The B<Gnome::GObject::Value> type of property I<vendor-id> is C<G_TYPE_STRING>.

=comment #TP:0:product-id:
=head3 Product ID


Product ID of this device, see C<gdk_device_get_product_id()>.
Since: 3.16

The B<Gnome::GObject::Value> type of property I<product-id> is C<G_TYPE_STRING>.


=begin comment
=comment #TP:0:seat:
=head3 Seat


B<Gnome::Gdk3::Seat> of this device.
Since: 3.20
Widget type: GDK_TYPE_SEAT

The B<Gnome::GObject::Value> type of property I<seat> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:num-touches:
=head3 Number of concurrent touches


The maximal number of concurrent touches on a touch device.
Will be 0 if the device is not a touch device or if the number
of touches is unknown.
Since: 3.20

The B<Gnome::GObject::Value> type of property I<num-touches> is C<G_TYPE_UINT>.

=comment #TP:0:axes:
=head3 Axes


The axes currently available for this device.
Since: 3.22

The B<Gnome::GObject::Value> type of property I<axes> is C<G_TYPE_FLAGS>.

=comment #TP:0:tool:
=head3 Tool

The tool that is currently used with this device
Widget type: GDK_TYPE_DEVICE_TOOL


The B<Gnome::GObject::Value> type of property I<tool> is C<G_TYPE_OBJECT>.
=end pod
