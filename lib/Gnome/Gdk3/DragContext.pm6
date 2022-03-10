#TL:1:Gnome::Gdk3::DragContext:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::DragContext

Functions for controlling lower level drag and drop handling

=comment ![](images/X.png)

=head1 Description

These functions provide a low level interface for drag and drop. The X backend of GDK supports both the Xdnd and Motif drag and drop protocols transparently, the Win32 backend supports the WM-DROPFILES protocol.

GTK+ provides a higher level abstraction based on top of these functions, and so they are not normally needed in GTK+ applications.
=comment See the [Drag and Drop][gtk3-Drag-and-Drop] section of the GTK+ documentation for more information.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::DragContext;
  also is Gnome::GObject::Object;


=head1 See Also
=item Gnome::Gdk3::Atom
=item Gnome::Gtk3::DragDest
=item Gnome::Gtk3::DragSource
=item Gnome::Gtk3::SelectionData
=item Gnome::Gtk3::TargetEntry
=item Gnome::Gtk3::TargetList
=comment item Gnome::Gtk3::Targets
=comment item Gnome::Gtk3::TargetTable


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::List;

use Gnome::GObject::Object;

use Gnome::Gdk3::Atom;
use Gnome::Gdk3::Window;
use Gnome::Gdk3::Device;

#-------------------------------------------------------------------------------
unit class Gnome::Gdk3::DragContext:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkDragAction

Used in B<Gnome::Gdk3::DragContext> to indicate what the destination should do with the dropped data.

=item GDK_ACTION_NONE: (=0) in some methods used to terminate or refuse action. Can only be used on its own. Combined (ored) with other values for an action mask is obviously not very helpful.
=comment item GDK-ACTION-DEFAULT: Means nothing, and should not be used.
=item GDK-ACTION-COPY: Copy the data.
=item GDK-ACTION-MOVE: Move the data, i.e. first copy it, then delete it from the source using the DELETE target of the X selection protocol.
=item GDK-ACTION-LINK: Add a link to the data. Note that this is only useful if source and destination agree on what it means.
=item GDK-ACTION-PRIVATE: Special action which tells the source that the destination will do something that the source doesn’t understand.
=item GDK-ACTION-ASK: Ask the user what to do with the data.
=end pod

#TE:1:GdkDragAction:
enum GdkDragAction is export (
  'GDK_ACTION_NONE' => 0,
  'GDK_ACTION_DEFAULT' => 1 +< 0,
  'GDK_ACTION_COPY'    => 1 +< 1,   # XdndActionCopy (freedesktop.org note)
  'GDK_ACTION_MOVE'    => 1 +< 2,   # XdndActionMove
  'GDK_ACTION_LINK'    => 1 +< 3,   # XdndActionLink
  'GDK_ACTION_PRIVATE' => 1 +< 4,   # XdndActionPrivate
  'GDK_ACTION_ASK'     => 1 +< 5    # XdndActionAsk
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkDragCancelReason

Used in B<Gnome::Gdk3::DragContext> to the reason of a cancelled DND operation.

=item GDK-DRAG-CANCEL-NO-TARGET: There is no suitable drop target.
=item GDK-DRAG-CANCEL-USER-CANCELLED: Drag cancelled by the user
=item GDK-DRAG-CANCEL-ERROR: Unspecified error.

=end pod

#TE:0:GdkDragCancelReason:
enum GdkDragCancelReason is export (
  'GDK_DRAG_CANCEL_NO_TARGET',
  'GDK_DRAG_CANCEL_USER_CANCELLED',
  'GDK_DRAG_CANCEL_ERROR'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkDragProtocol

Used here to indicate the protocol according to which DND is done.

=item GDK-DRAG-PROTO-NONE: no protocol.
=item GDK-DRAG-PROTO-MOTIF: The Motif DND protocol. No longer supported
=item GDK-DRAG-PROTO-XDND: The Xdnd protocol.
=item GDK-DRAG-PROTO-ROOTWIN: An extension to the Xdnd protocol for unclaimed root window drops.
=item GDK-DRAG-PROTO-WIN32-DROPFILES: The simple WM-DROPFILES protocol.
=item GDK-DRAG-PROTO-OLE2: The complex OLE2 DND protocol (not implemented).
=item GDK-DRAG-PROTO-LOCAL: Intra-application DND.
=item GDK-DRAG-PROTO-WAYLAND: Wayland DND protocol.

=end pod

#TE:0:GdkDragProtocol:
enum GdkDragProtocol is export (
  'GDK_DRAG_PROTO_NONE' => 0,
  'GDK_DRAG_PROTO_MOTIF',
  'GDK_DRAG_PROTO_XDND',
  'GDK_DRAG_PROTO_ROOTWIN',
  'GDK_DRAG_PROTO_WIN32_DROPFILES',
  'GDK_DRAG_PROTO_OLE2',
  'GDK_DRAG_PROTO_LOCAL',
  'GDK_DRAG_PROTO_WAYLAND'
);

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :window, :targets

Starts a drag and creates a new drag context for it. This function assumes that the drag is controlled by the client pointer device, use C<new(:$window, :$targets, :$device)> to begin a drag with a different device.

This function is called by the drag source.

  multi method new ( :$window!, :$targets! )

=item N-GObject $window; the source window for this drag
=item N-GList $targets; the offered targets, as list of native Gnome::Gdk3::Atom.


=head3 :window, :targets, :device

Starts a drag with a different device and creates a new drag context for it.

This function is called by the drag source.

  multi method new ( :$window!, :$targets!, :$device! )

=item N-GObject $window; the source window for this drag
=item N-GObject $device; the device that controls this drag
=item N-GList $targets; the offered targets, as list of native Gnome::Gdk3::Atom.


=head3 :window, :targets, :device, :x, :y

Starts a drag with a different device and creates a new drag context for it.

This function is called by the drag source.

  multi method new (
    :$window!, :$targets!, :$device!, Int() $x, Int() $y
  )

=item N-GObject $window; the source window for this drag
=item N-GObject $device; the device that controls this drag
=item N-GList $targets; the offered targets, as list of native Gnome::Gdk3::Atom.
=item Int() $x; the x coordinate where the drag nominally started
=item Int() $y; the y coordinate where the drag nominally started


=head3 :native-object

Create a Drag object using a native object from elsewhere. This is the most used way to initialize this object because you will get the context when a signal arrives and calls a handler for it.

  multi method new ( N-GObject :$native-object! )

=head4 Example

An example of a handler to process the C<drag-motion> event.

  method motion (
    N-GObject $context, Int $x, Int $y, UInt $time
    --> Bool
  ) {
    …
    my Gnome::Gdk3::DragContext $drag-context .= new(
      :native-object($context)
    );
    $drag-context.status( GDK_ACTION_COPY, $time);
    …
  }


=end pod

#TM:1:new():
#TM:0:new(:window,:targets)
#TM:0:new(:window,:targets,:device)
#TM:0:new(:window,:targets,:device,:x,:y)
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gdk3::DragContext' {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my N-GObject() $no;
      if ? %options<window> and %options<targets>:exists {
        my N-GObject() $no1 = %options<window>;
#        $no1 .= _get-native-object-no-reffing unless $no1 ~~ N-GObject;
        my $no2 = %options<targets>;
        $no2 .= _get-native-object-no-reffing unless $no2 ~~ N-GList;

        if ? %options<device> {
          my N-GObject() $no3 = %options<device>;
 #          $no3 .= _get-native-object-no-reffing unless $no3 ~~ N-GObject;

          if %options<x>:exists and %options<y>:exists {
            $no =_gdk_drag_begin_from_point(
              $no1, $no3, $no2, %options<x>.Int, %options<y>.Int
            );
          }

          else {
            $no =_gdk_drag_begin_for_device( $no1, $no3, $no2);
          }
        }

        else {
          $no = _gdk_drag_begin( $no1, $no2);
        }
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
        $no = _gdk_drag_new();
      }
      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GdkDrag');
  }
}

#-------------------------------------------------------------------------------
#TM:0:abort:
=begin pod
=head2 abort

Aborts a drag without dropping.

This function is called by the drag source.

This function does not need to be called in managed drag and drop operations.
=comment See C<manage-dnd()> for more information.

  method abort ( UInt $time )

=item $time; the timestamp for this operation
=end pod

method abort ( UInt $time ) {
  gdk_drag_abort( self._get-native-object-no-reffing, $time);
}

sub gdk_drag_abort (
  N-GObject $context, guint32 $time
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gdk_drag_begin:
#`{{
=begin pod
=head2 begin

Starts a drag and creates a new drag context for it. This function assumes that the drag is controlled by the client pointer device, use C<begin_for_device()> to begin a drag with a different device.

This function is called by the drag source.

  method begin ( N-GObject() $window, N-GList $targets --> N-GObject )

=item $window;
=item $targets;
=end pod

method begin ( N-GObject() $window, $targets is copy --> N-GObject ) {
  $targets .= _get-native-object-no-reffing unless $targets ~~ N-GList;
  gdk_drag_begin( $window, $targets)
}
}}

sub _gdk_drag_begin (
  N-GObject $window, N-GList $targets --> N-GObject
) is native(&gdk-lib)
  is symbol('gdk_drag_begin')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_drag_begin_for_device:
#`{{
=begin pod
=head2 begin-for-device

Starts a drag and creates a new drag context for it.

This function is called by the drag source.

  method begin-for-device (
    N-GObject() $window, N-GObject() $device, N-GList $targets
    --> N-GObject
  )

=item $window;
=item $device;
=item $targets;
=end pod

method begin-for-device (
  N-GObject() $window, N-GObject() $device, $targets --> N-GObject ) {
  $targets .= _get-native-object-no-reffing unless $targets ~~ N-GList;

  gdk_drag_begin_for_device(
    self._get-native-object-no-reffing, $window, $device, $targets
  )
}
}}

sub _gdk_drag_begin_for_device (
  N-GObject $window, N-GObject $device, N-GList $targets --> N-GObject
) is native(&gdk-lib)
  is symbol('gdk_drag_begin_for_device')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gdk_drag_begin_from_point:
#`{{
=begin pod
=head2 begin-from-point

Starts a drag and creates a new drag context for it.

This function is called by the drag source.

  method begin-from-point (
    N-GObject() $window, N-GObject() $device, N-GList $targets,
    Int() $x_root, Int() $y_root
    --> N-GObject
  )

=item $window;
=item $device;
=item $targets;
=item $x_root;
=item $y_root;
=end pod

method begin-from-point (
  N-GObject() $window, N-GObject() $device, $targets is copy,
  Int() $x_root, Int() $y_root
  --> N-GObject
) {
  $targets .= _get-native-object-no-reffing unless $targets ~~ N-GList;
  gdk_drag_begin_from_point(
    self._get-native-object-no-reffing, $window, $device, $targets, $x_root, $y_root
  )
}
}}

sub _gdk_drag_begin_from_point (
  N-GObject $window, N-GObject $device, N-GList $targets, gint $x_root, gint $y_root --> N-GObject
) is native(&gdk-lib)
  is symbol('gdk_drag_begin_from_point')
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-actions:
=begin pod
=head2 get-actions

Determines the bitmask of actions proposed by the source if C<get-suggested-action()> returns C<GDK-ACTION-ASK>.

Returns: the C<GdkDragAction> flags

  method get-actions ( --> Int )

=end pod

method get-actions ( --> Int ) {
  gdk_drag_context_get_actions(self._get-native-object-no-reffing)
}

sub gdk_drag_context_get_actions (
  N-GObject $context --> GFlag
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-dest-window:
=begin pod
=head2 get-dest-window

Returns the destination window for the DND operation, a B<Gnome::Gdk3::Window>

  method get-dest-window ( --> Gnome::Gdk3::Window )

=end pod

method get-dest-window ( --> N-GObject ) {
  Gnome::Gdk3::Window.new(
    :native-object(
      gdk_drag_context_get_dest_window(self._get-native-object-no-reffing)
    )
  )
}

sub gdk_drag_context_get_dest_window (
  N-GObject $context --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-device:
=begin pod
=head2 get-device

Returns the B<Gnome::Gdk3::Device> associated to the drag context.

  method get-device ( --> Gnome::Gdk3::Device )

=end pod

method get-device ( --> Gnome::Gdk3::Device ) {
  Gnome::Gdk3::Device.new(
    :native-object(
      gdk_drag_context_get_device(self._get-native-object-no-reffing)
    )
  )
}

sub gdk_drag_context_get_device (
  N-GObject $context --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-drag-window:
=begin pod
=head2 get-drag-window

Returns the window on which the drag icon should be rendered during the drag operation. Note that the window may not be available until the drag operation has begun. GDK will move the window in accordance with the ongoing drag operation. The window is owned by I<context> and will be destroyed when the drag operation is over.

Returns: the drag window, or C<undefined>

  method get-drag-window ( --> Gnome::Gdk3::Window )

=end pod

method get-drag-window ( --> Gnome::Gdk3::Window ) {
  Gnome::Gdk3::Window.new(
    :native-object(
      gdk_drag_context_get_drag_window(self._get-native-object-no-reffing)
    )
  )
}

sub gdk_drag_context_get_drag_window (
  N-GObject $context --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-protocol:
=begin pod
=head2 get-protocol

Returns the drag protocol that is used by this context.

Returns: the drag protocol

  method get-protocol ( --> GdkDragProtocol )

=end pod

method get-protocol ( --> GdkDragProtocol ) {
  GdkDragProtocol(
    gdk_drag_context_get_protocol(self._get-native-object-no-reffing)
  )
}

sub gdk_drag_context_get_protocol (
  N-GObject $context --> GEnum
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-selected-action:
=begin pod
=head2 get-selected-action

Determines the action chosen by the drag destination.

Returns: a C<GdkDragAction> enum value.

  method get-selected-action ( --> GdkDragAction )

=end pod

method get-selected-action ( --> GdkDragAction ) {
  GdkDragAction(
    gdk_drag_context_get_selected_action(self._get-native-object-no-reffing)
  )
}

sub gdk_drag_context_get_selected_action (
  N-GObject $context --> GFlag
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-source-window:
=begin pod
=head2 get-source-window

Returns the B<Gnome::Gdk3::Window> where the DND operation started.

  method get-source-window ( --> Gnome::Gdk3::Window )

=end pod

method get-source-window ( --> Gnome::Gdk3::Window ) {
  Gnome::Gdk3::Window.new(
    :native-object(
      gdk_drag_context_get_source_window(self._get-native-object-no-reffing)
    )
  )
}

sub gdk_drag_context_get_source_window (
  N-GObject $context --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-suggested-action:
=begin pod
=head2 get-suggested-action

Determines the suggested drag action of the context.

Returns: a C<GdkDragAction> value

  method get-suggested-action ( --> GdkDragAction )

=end pod

method get-suggested-action ( --> GdkDragAction ) {
  GdkDragAction(
    gdk_drag_context_get_suggested_action(self._get-native-object-no-reffing)
  )
}

sub gdk_drag_context_get_suggested_action (
  N-GObject $context --> GFlag
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:list-targets:gnome-gtk3/xt/dnd-source-targets-view.raku
=begin pod
=head2 list-targets

Retrieves the list of targets of the context.

Returns: (element-type Gnome::Gdk3::Atom): a B<Gnome::Glib::List> of targets

  method list-targets ( --> Gnome::Glib::List )

=end pod

method list-targets ( --> Gnome::Glib::List ) {
  Gnome::Glib::List.new(
    :native-object(
      gdk_drag_context_list_targets(self._get-native-object-no-reffing)
    )
  )
}

sub gdk_drag_context_list_targets (
  N-GObject $context --> N-GList
) is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:manage-dnd:
=begin pod
=head2 manage-dnd

Requests the drag and drop operation to be managed by I<context>. When a drag and drop operation becomes managed, the B<Gnome::Gdk3::DragContext> will internally handle all input and source-side B<Gnome::Gdk3::EventDND> events as required by the windowing system.

Once the drag and drop operation is managed, the drag context will emit the following signals:
=item The  I<action-changed> signal whenever the final action to be performed by the drag and drop operation changes.
=item The  I<drop-performed> signal after the user performs the drag and drop gesture (typically by releasing the mouse button).
=item The  I<dnd-finished> signal after the drag and drop operation concludes (after all B<Gnome::Gdk3::Selection> transfers happen).
=item The  I<cancel> signal if the drag and drop operation is finished but doesn't happen over an accepting destination, or is cancelled through other means.

Returns: B<TRUE> if the drag and drop operation is managed.

  method manage-dnd ( N-GObject() $ipc_window, GdkDragAction $actions --> Bool )

=item $ipc_window; Window to use for IPC messaging/events
=item $actions; the actions supported by the drag source
=end pod

method manage-dnd (
  N-GObject() $ipc_window, GdkDragAction $actions --> Bool
) {
  $ipc_window .= _get-native-object-no-reffing unless $ipc_window ~~ N-GObject;

  gdk_drag_context_manage_dnd(
    self._get-native-object-no-reffing, $ipc_window, $actions
  ).Bool
}

sub gdk_drag_context_manage_dnd (
  N-GObject $context, N-GObject $ipc_window, GFlag $actions --> gboolean
) is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:set-device:
=begin pod
=head2 set-device

Associates a B<Gnome::Gdk3::Device> to I<context>, so all Drag and Drop events for I<context> are emitted as if they came from this device.

  method set-device ( N-GObject() $device )

=item $device; a B<Gnome::Gdk3::Device>
=end pod

method set-device ( N-GObject() $device ) {
  gdk_drag_context_set_device( self._get-native-object-no-reffing, $device);
}

sub gdk_drag_context_set_device (
  N-GObject $context, N-GObject $device
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-hotspot:
=begin pod
=head2 set-hotspot

Sets the position of the drag window that will be kept under the cursor hotspot. Initially, the hotspot is at the top left corner of the drag window.

  method set-hotspot ( Int() $hot_x, Int() $hot_y )

=item $hot_x; x coordinate of the drag window hotspot
=item $hot_y; y coordinate of the drag window hotspot
=end pod

method set-hotspot ( Int() $hot_x, Int() $hot_y ) {
  gdk_drag_context_set_hotspot(
    self._get-native-object-no-reffing, $hot_x, $hot_y
  );
}

sub gdk_drag_context_set_hotspot (
  N-GObject $context, gint $hot_x, gint $hot_y
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:drop:
=begin pod
=head2 drop

Drops on the current destination.

This function is called by the drag source.

This function does not need to be called in managed drag and drop operations.
=comment See C<manage-dnd()> for more information.

  method drop ( UInt $time )

=item $time; the timestamp for this operation
=end pod

method drop ( UInt $time ) {
  gdk_drag_drop( self._get-native-object-no-reffing, $time
  );
}

sub gdk_drag_drop (
  N-GObject $context, guint32 $time
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:drop-done:
=begin pod
=head2 drop-done

Inform GDK if the drop ended successfully. Passing C<False> for I<$success> may trigger a drag cancellation animation.

This function is called by the drag source, and should be the last call before dropping the reference to the I<context>.

The B<Gnome::Gdk3::DragContext> will only take the first C<drop-done()> call as effective, if this function is called multiple times, all subsequent calls will be ignored.

  method drop-done ( Bool $success )

=item $success; whether the drag was ultimatively successful
=end pod

method drop-done ( Bool $success ) {
  gdk_drag_drop_done(
    self._get-native-object-no-reffing, $success
  );
}

sub gdk_drag_drop_done (
  N-GObject $context, gboolean $success
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:drop-succeeded:
=begin pod
=head2 drop-succeeded

Returns whether the dropped data has been successfully transferred. This function is intended to be used while handling a C<GDK-DROP-FINISHED> event, its return value is meaningless at other times.

Returns: C<True> if the drop was successful.

  method drop-succeeded ( --> Bool )

=end pod

method drop-succeeded ( --> Bool ) {
  gdk_drag_drop_succeeded(self._get-native-object-no-reffing).Bool
}

sub gdk_drag_drop_succeeded (
  N-GObject $context --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:find-window-for-screen:
=begin pod
=head2 find-window-for-screen

Finds the destination window and DND protocol to use at the given pointer position.

This function is called by the drag source to obtain the I<dest-window> and I<protocol> parameters for C<motion()>.

  method find-window-for-screen (
    N-GObject() $drag_window, N-GObject() $screen,
    Int() $x_root, Int() $y_root, N-GObject() $dest_window,
    GdkDragProtocol $protocol
  )

=item $drag_window; a window which may be at the pointer position, but should be ignored, since it is put up by the drag source as an icon
=item $screen; the screen where the destination window is sought
=item $x_root; the x position of the pointer in root coordinates
=item $y_root; the y position of the pointer in root coordinates
=item $dest_window; location to store the destination window in
=item $protocol; location to store the DND protocol in
=end pod

method find-window-for-screen (
  N-GObject() $drag_window, N-GObject() $screen, Int() $x_root, Int() $y_root,
  N-GObject() $dest_window, GdkDragProtocol $protocol
) {
  gdk_drag_find_window_for_screen(
    self._get-native-object-no-reffing, $drag_window, $screen, $x_root,
    $y_root, $dest_window, $protocol
  );
}

sub gdk_drag_find_window_for_screen (
  N-GObject $context, N-GObject $drag_window, N-GObject $screen, gint $x_root, gint $y_root, N-GObject $dest_window, GEnum $protocol
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk-drop-finish:
=begin pod
=head2 gdk-drop-finish

Ends the drag operation after a drop.

This function is called by the drag destination.

  method gdk-drop-finish ( Bool $success, UInt $time )

=item $success; C<True> if the data was successfully received
=item $time; the timestamp for this operation
=end pod

method gdk-drop-finish ( Bool $success, UInt $time ) {

  gdk_drop_finish(
    self._get-native-object-no-reffing, $success, $time
  );
}

sub gdk_drop_finish (
  N-GObject $context, gboolean $success, guint32 $time
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk-drop-reply:
=begin pod
=head2 gdk-drop-reply

Accepts or rejects a drop.

This function is called by the drag destination in response to a drop initiated by the drag source.

  method gdk-drop-reply ( Bool $accepted, UInt $time )

=item $accepted; C<True> if the drop is accepted
=item $time; the timestamp for this operation
=end pod

method gdk-drop-reply ( Bool $accepted, UInt $time ) {
  gdk_drop_reply(
    self._get-native-object-no-reffing, $accepted, $time
  );
}

sub gdk_drop_reply (
  N-GObject $context, gboolean $accepted, guint32 $time
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-selection:
=begin pod
=head2 get-selection

Returns the selection atom for the current source window.

Returns: the selection atom, or C<GDK-NONE>

  method get-selection ( --> Gnome::Gdk3::Atom )

=end pod

method get-selection ( --> Gnome::Gdk3::Atom ) {
  Gnome::Gdk3::Atom.new(
    :native-object(
      gdk_drag_get_selection(self._get-native-object-no-reffing)
    )
  )
}

sub gdk_drag_get_selection (
  N-GObject $context --> N-GObject
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:motion:
=begin pod
=head2 motion

Updates the drag context when the pointer moves or the set of actions changes.

This function is called by the drag source.

This function does not need to be called in managed drag and drop operations.
=comment See C<manage-dnd()> for more information.

Returns:

  method motion (
    N-GObject() $dest_window, GdkDragProtocol $protocol,
    Int() $x_root, Int() $y_root, GdkDragAction $suggested_action,
    GdkDragAction $possible_actions, UInt $time
    --> Bool
  )

=item $dest_window; the new destination window, obtained by C<find-window()>
=item $protocol; the DND protocol in use, obtained by C<find-window()>
=item $x_root; the x position of the pointer in root coordinates
=item $y_root; the y position of the pointer in root coordinates
=item $suggested_action; the suggested action
=item $possible_actions; the possible actions
=item $time; the timestamp for this operation
=end pod

method motion (
  N-GObject() $dest_window, GdkDragProtocol $protocol, Int() $x_root,
  Int() $y_root, GFlag $suggested_action, GdkDragAction $possible_actions,
  UInt $time
  --> Bool
) {
  gdk_drag_motion(
    self._get-native-object-no-reffing, $dest_window, $protocol,
    $x_root, $y_root, $suggested_action, $possible_actions, $time
  ).Bool
}

sub gdk_drag_motion (
  N-GObject $context, N-GObject $dest_window, GEnum $protocol, gint $x_root, gint $y_root, GFlag $suggested_action, GFlag $possible_actions, guint32 $time --> gboolean
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:status:
=begin pod
=head2 status

Selects one of the actions offered by the drag source.

This function is called by the drag destination in response to C<motion()> called by the drag source.

  method status ( GdkDragAction $action, UInt $time )

=item $action; the selected action which will be taken when a drop happens, or GDK_ACTION_NONE to indicate that a drop will not be accepted
=item $time; the timestamp for this operation
=end pod

method status ( GdkDragAction $action, UInt $time ) {
  gdk_drag_status( self._get-native-object-no-reffing, $action, $time);
}

sub gdk_drag_status (
  N-GObject $context, GFlag $action, guint32 $time
) is native(&gdk-lib)
  { * }
