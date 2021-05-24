use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gdk3::Window

Onscreen display areas in the target window system

=head1 Description

A B<Gnome::Gdk3::Window> is a (usually) rectangular region on the screen. It’s a low-level object, used to implement high-level objects such as B<Gnome::Gtk3::Widget> and B<Gnome::Gtk3::Window> on the GTK+ level. A B<Gnome::Gtk3::Window> is a toplevel window, the thing a user might think of as a “window” with a titlebar and so on; a B<Gnome::Gtk3::Window> may contain many B<Gnome::Gdk3::Windows>. For example, each B<Gnome::Gtk3::Button> has a B<Gnome::Gdk3::Window> associated with it.


=head2 Composited Windows

Normally, the windowing system takes care of rendering the contents of a child window onto its parent window. This mechanism can be intercepted by calling C<gdk_window_set_composited()> on the child window. For a “composited” window it is the responsibility of the application to render the window contents at the right spot.


=head2 Offscreen Windows

Offscreen windows are more general than composited windows, since they allow not only to modify the rendering of the child window onto its parent, but also to apply coordinate transformations.

To integrate an offscreen window into a window hierarchy, one has to call C<gdk_offscreen_window_set_embedder()> and handle a number of signals. The  I<pick-embedded-child> signal on the embedder window is used to select an offscreen child at given coordinates, and the  I<to-embedder> and  I<from-embedder> signals on the offscreen window are used to translate coordinates between the embedder and the offscreen window.

For rendering an offscreen window onto its embedder, the contents of the offscreen window are available as a surface, via C<gdk_offscreen_window_get_surface()>.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gdk3::Window;
  also is Gnome::GObject::Object;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;

use Gnome::Glib::Error;
use Gnome::Glib::List;

use Gnome::GObject::Object;

use Gnome::Gdk3::Types;
use Gnome::Gdk3::Events;

#use Gnome::Cairo;
use Gnome::Cairo::Types;
use Gnome::Cairo::Enums;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gdk/gdkwindow.h
# https://developer.gnome.org/gdk3/stable/gdk3-Windows.html
unit class Gnome::Gdk3::Window:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkWindowWindowClass

I<GDK_INPUT_OUTPUT> windows are the standard kind of window you might expect.
Such windows receive events and are also displayed on screen.
I<GDK_INPUT_ONLY> windows are invisible; they are usually placed above other
windows in order to trap or filter the events. You can’t draw on
I<GDK_INPUT_ONLY> windows.


=item GDK_INPUT_OUTPUT: window for graphics and events
=item GDK_INPUT_ONLY: window for events only


=end pod

#TE:0:GdkWindowWindowClass:
enum GdkWindowWindowClass is export (
  'GDK_INPUT_OUTPUT', 'GDK_INPUT_ONLY'
);


#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkWindowType

Describes the kind of window.


=item GDK_WINDOW_ROOT: root window; this window has no parent, covers the entire screen, and is created by the window system
=item GDK_WINDOW_TOPLEVEL: toplevel window (used to implement C<Gnome::Gtk3::Window>)
=item GDK_WINDOW_CHILD: child window (used to implement e.g. C<Gnome::Gtk3::Entry>)
=item GDK_WINDOW_TEMP: override redirect temporary window (used to implement C<Gnome::Gtk3::Menu>)
=item GDK_WINDOW_FOREIGN: foreign window (see C<gdk_window_foreign_new()>)
=item GDK_WINDOW_OFFSCREEN: offscreen window (see [Offscreen Windows][OFFSCREEN-WINDOWS]). Since 2.18
=item GDK_WINDOW_SUBSURFACE: subsurface-based window; This window is visually tied to a toplevel, and is moved/stacked with it. Currently this window type is only implemented in Wayland. Since 3.14


=end pod

#TE:1:GdkWindowType:
enum GdkWindowType is export (
  'GDK_WINDOW_ROOT',
  'GDK_WINDOW_TOPLEVEL',
  'GDK_WINDOW_CHILD',
  'GDK_WINDOW_TEMP',
  'GDK_WINDOW_FOREIGN',
  'GDK_WINDOW_OFFSCREEN',
  'GDK_WINDOW_SUBSURFACE'
);


#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkWindowAttributesType

Used to indicate which fields in the C<Gnome::Gdk3::WindowAttr> struct should be honored. For example, if you filled in the “cursor” and “x” fields of C<Gnome::Gdk3::WindowAttr>, pass “I<GDK_WA_X> \| I<GDK_WA_CURSOR>” to C<gdk_window_new()>. Fields in C<Gnome::Gdk3::WindowAttr> not covered by a bit in this enum are required; for example, the I<width>/I<height>, I<wclass>, and I<window_type> fields are required, they have no corresponding flag in C<Gnome::Gdk3::WindowAttributesType>.


=item GDK_WA_TITLE: Honor the title field
=item GDK_WA_X: Honor the X coordinate field
=item GDK_WA_Y: Honor the Y coordinate field
=item GDK_WA_CURSOR: Honor the cursor field
=item GDK_WA_VISUAL: Honor the visual field
=item GDK_WA_WMCLASS: Honor the wmclass_class and wmclass_name fields
=item GDK_WA_NOREDIR: Honor the override_redirect field
=item GDK_WA_TYPE_HINT: Honor the type_hint field


=end pod

#TE:0:GdkWindowAttributesType:
enum GdkWindowAttributesType is export (
  'GDK_WA_TITLE'	   => 1 +< 1,
  'GDK_WA_X'	   => 1 +< 2,
  'GDK_WA_Y'	   => 1 +< 3,
  'GDK_WA_CURSOR'	   => 1 +< 4,
  'GDK_WA_VISUAL'	   => 1 +< 5,
  'GDK_WA_WMCLASS'   => 1 +< 6,
  'GDK_WA_NOREDIR'   => 1 +< 7,
  'GDK_WA_TYPE_HINT' => 1 +< 8
);


#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkWindowHints

Used to indicate which fields of a C<Gnome::Gdk3::Geometry> struct should be paid
attention to. Also, the presence/absence of I<GDK_HINT_POS>,
I<GDK_HINT_USER_POS>, and I<GDK_HINT_USER_SIZE> is significant, though they don't
directly refer to C<Gnome::Gdk3::Geometry> fields. I<GDK_HINT_USER_POS> will be set
automatically by C<Gnome::Gtk3::Window> if you call C<gtk_window_move()>.
I<GDK_HINT_USER_POS> and I<GDK_HINT_USER_SIZE> should be set if the user
specified a size/position using a --geometry command-line argument;
C<gtk_window_parse_geometry()> automatically sets these flags.


=item GDK_HINT_POS: indicates that the program has positioned the window
=item GDK_HINT_MIN_SIZE: min size fields are set
=item GDK_HINT_MAX_SIZE: max size fields are set
=item GDK_HINT_BASE_SIZE: base size fields are set
=item GDK_HINT_ASPECT: aspect ratio fields are set
=item GDK_HINT_RESIZE_INC: resize increment fields are set
=item GDK_HINT_WIN_GRAVITY: window gravity field is set
=item GDK_HINT_USER_POS: indicates that the window’s position was explicitly set by the user
=item GDK_HINT_USER_SIZE: indicates that the window’s size was explicitly set by the user


=end pod

#TE:0:GdkWindowHints:
enum GdkWindowHints is export (
  'GDK_HINT_POS'	       => 1 +< 0,
  'GDK_HINT_MIN_SIZE'    => 1 +< 1,
  'GDK_HINT_MAX_SIZE'    => 1 +< 2,
  'GDK_HINT_BASE_SIZE'   => 1 +< 3,
  'GDK_HINT_ASPECT'      => 1 +< 4,
  'GDK_HINT_RESIZE_INC'  => 1 +< 5,
  'GDK_HINT_WIN_GRAVITY' => 1 +< 6,
  'GDK_HINT_USER_POS'    => 1 +< 7,
  'GDK_HINT_USER_SIZE'   => 1 +< 8
);


#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkWMDecoration

These are hints originally defined by the Motif toolkit.
The window manager can use them when determining how to decorate
the window. The hint must be set before mapping the window.


=item GDK_DECOR_ALL: all decorations should be applied.
=item GDK_DECOR_BORDER: a frame should be drawn around the window.
=item GDK_DECOR_RESIZEH: the frame should have resize handles.
=item GDK_DECOR_TITLE: a titlebar should be placed above the window.
=item GDK_DECOR_MENU: a button for opening a menu should be included.
=item GDK_DECOR_MINIMIZE: a minimize button should be included.
=item GDK_DECOR_MAXIMIZE: a maximize button should be included.


=end pod

#TE:0:GdkWMDecoration:
enum GdkWMDecoration is export (
  'GDK_DECOR_ALL'		=> 1 +< 0,
  'GDK_DECOR_BORDER'	=> 1 +< 1,
  'GDK_DECOR_RESIZEH'	=> 1 +< 2,
  'GDK_DECOR_TITLE'	=> 1 +< 3,
  'GDK_DECOR_MENU'	=> 1 +< 4,
  'GDK_DECOR_MINIMIZE'	=> 1 +< 5,
  'GDK_DECOR_MAXIMIZE'	=> 1 +< 6
);


#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkWMFunction

These are hints originally defined by the Motif toolkit. The window manager
can use them when determining the functions to offer for the window. The
hint must be set before mapping the window.


=item GDK_FUNC_ALL: all functions should be offered.
=item GDK_FUNC_RESIZE: the window should be resizable.
=item GDK_FUNC_MOVE: the window should be movable.
=item GDK_FUNC_MINIMIZE: the window should be minimizable.
=item GDK_FUNC_MAXIMIZE: the window should be maximizable.
=item GDK_FUNC_CLOSE: the window should be closable.


=end pod

#TE:0:GdkWMFunction:
enum GdkWMFunction is export (
  'GDK_FUNC_ALL'		=> 1 +< 0,
  'GDK_FUNC_RESIZE'	=> 1 +< 1,
  'GDK_FUNC_MOVE'		=> 1 +< 2,
  'GDK_FUNC_MINIMIZE'	=> 1 +< 3,
  'GDK_FUNC_MAXIMIZE'	=> 1 +< 4,
  'GDK_FUNC_CLOSE'	=> 1 +< 5
);


#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkGravity

Defines the reference point of a window and the meaning of coordinates
passed to C<gtk_window_move()>. See C<gtk_window_move()> and the "implementation
notes" section of the
[Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec)
specification for more details.


=item GDK_GRAVITY_NORTH_WEST: the reference point is at the top left corner.
=item GDK_GRAVITY_NORTH: the reference point is in the middle of the top edge.
=item GDK_GRAVITY_NORTH_EAST: the reference point is at the top right corner.
=item GDK_GRAVITY_WEST: the reference point is at the middle of the left edge.
=item GDK_GRAVITY_CENTER: the reference point is at the center of the window.
=item GDK_GRAVITY_EAST: the reference point is at the middle of the right edge.
=item GDK_GRAVITY_SOUTH_WEST: the reference point is at the lower left corner.
=item GDK_GRAVITY_SOUTH: the reference point is at the middle of the lower edge.
=item GDK_GRAVITY_SOUTH_EAST: the reference point is at the lower right corner.
=item GDK_GRAVITY_STATIC: the reference point is at the top left corner of the window itself, ignoring window manager decorations.


=end pod

#TE:0:GdkGravity:
enum GdkGravity is export (
  'GDK_GRAVITY_NORTH_WEST' => 1,
  'GDK_GRAVITY_NORTH',
  'GDK_GRAVITY_NORTH_EAST',
  'GDK_GRAVITY_WEST',
  'GDK_GRAVITY_CENTER',
  'GDK_GRAVITY_EAST',
  'GDK_GRAVITY_SOUTH_WEST',
  'GDK_GRAVITY_SOUTH',
  'GDK_GRAVITY_SOUTH_EAST',
  'GDK_GRAVITY_STATIC'
);


#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkAnchorHints

Positioning hints for aligning a window relative to a rectangle.

These hints determine how the window should be positioned in the case that
the window would fall off-screen if placed in its ideal position.

For example, C<GDK_ANCHOR_FLIP_X> will replace C<GDK_GRAVITY_NORTH_WEST> with
C<GDK_GRAVITY_NORTH_EAST> and vice versa if the window extends beyond the left
or right edges of the monitor.

If C<GDK_ANCHOR_SLIDE_X> is set, the window can be shifted horizontally to fit
on-screen. If C<GDK_ANCHOR_RESIZE_X> is set, the window can be shrunken
horizontally to fit.

In general, when multiple flags are set, flipping should take precedence over
sliding, which should take precedence over resizing.

Stability: Unstable


=item GDK_ANCHOR_FLIP_X: allow flipping anchors horizontally
=item GDK_ANCHOR_FLIP_Y: allow flipping anchors vertically
=item GDK_ANCHOR_SLIDE_X: allow sliding window horizontally
=item GDK_ANCHOR_SLIDE_Y: allow sliding window vertically
=item GDK_ANCHOR_RESIZE_X: allow resizing window horizontally
=item GDK_ANCHOR_RESIZE_Y: allow resizing window vertically
=item GDK_ANCHOR_FLIP: allow flipping anchors on both axes
=item GDK_ANCHOR_SLIDE: allow sliding window on both axes
=item GDK_ANCHOR_RESIZE: allow resizing window on both axes


=end pod

#TE:0:GdkAnchorHints:
enum GdkAnchorHints is export (
  'GDK_ANCHOR_FLIP_X'   => 1 +< 0,
  'GDK_ANCHOR_FLIP_Y'   => 1 +< 1,
  'GDK_ANCHOR_SLIDE_X'  => 1 +< 2,
  'GDK_ANCHOR_SLIDE_Y'  => 1 +< 3,
  'GDK_ANCHOR_RESIZE_X' => 1 +< 4,
  'GDK_ANCHOR_RESIZE_Y' => 1 +< 5,

#  'GDK_ANCHOR_FLIP'     => GDK_ANCHOR_FLIP_X +| GDK_ANCHOR_FLIP_Y,
#  'GDK_ANCHOR_SLIDE'    => GDK_ANCHOR_SLIDE_X +| GDK_ANCHOR_SLIDE_Y,
#  'GDK_ANCHOR_RESIZE'   => GDK_ANCHOR_RESIZE_X +| GDK_ANCHOR_RESIZE_Y
  'GDK_ANCHOR_FLIP'     => 1 +< 0 +| 1 +< 1,
  'GDK_ANCHOR_SLIDE'    => 1 +< 2 +| 1 +< 3,
  'GDK_ANCHOR_RESIZE'   => 1 +< 4 +| 1 +< 5
);


#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkWindowEdge

Determines a window edge or corner.


=item GDK_WINDOW_EDGE_NORTH_WEST: the top left corner.
=item GDK_WINDOW_EDGE_NORTH: the top edge.
=item GDK_WINDOW_EDGE_NORTH_EAST: the top right corner.
=item GDK_WINDOW_EDGE_WEST: the left edge.
=item GDK_WINDOW_EDGE_EAST: the right edge.
=item GDK_WINDOW_EDGE_SOUTH_WEST: the lower left corner.
=item GDK_WINDOW_EDGE_SOUTH: the lower edge.
=item GDK_WINDOW_EDGE_SOUTH_EAST: the lower right corner.


=end pod

#TE:0:GdkWindowEdge:
enum GdkWindowEdge is export (
  'GDK_WINDOW_EDGE_NORTH_WEST',
  'GDK_WINDOW_EDGE_NORTH',
  'GDK_WINDOW_EDGE_NORTH_EAST',
  'GDK_WINDOW_EDGE_WEST',
  'GDK_WINDOW_EDGE_EAST',
  'GDK_WINDOW_EDGE_SOUTH_WEST',
  'GDK_WINDOW_EDGE_SOUTH',
  'GDK_WINDOW_EDGE_SOUTH_EAST'
);


#-------------------------------------------------------------------------------
=begin pod
=head2 enum GdkFullscreenMode

Indicates which monitor (in a multi-head setup) a window should span over
when in fullscreen mode.



=item GDK_FULLSCREEN_ON_CURRENT_MONITOR: Fullscreen on current monitor only.
=item GDK_FULLSCREEN_ON_ALL_MONITORS: Span across all monitors when fullscreen.


=end pod

#TE:0:GdkFullscreenMode:
enum GdkFullscreenMode is export (
  'GDK_FULLSCREEN_ON_CURRENT_MONITOR',
  'GDK_FULLSCREEN_ON_ALL_MONITORS'
);


#-------------------------------------------------------------------------------
=begin pod
=head2 class GdkWindowAttr

Attributes to use for a newly-created window.

=item Str $.title: title of the window (for toplevel windows)
=item Int $.event_mask: event mask (see C<gdk_window_set_events()>)
=item Int $.x: X coordinate relative to parent window (see C<gdk_window_move()>)
=item Int $.y: Y coordinate relative to parent window (see C<gdk_window_move()>)
=item Int $.width: width of window
=item Int $.height: height of window
=item enum C<WindowWindowClass> $.wclass: C<GDK_INPUT_OUTPUT> (normal window) or C<GDK_INPUT_ONLY> (invisible window that receives events)
=item N-GObject $.visual: C<Gnome::Gdk3::Visual> for window
=item enum C<GdkWindowType> $.window_type: type of window
=item N-GObject $.cursor: cursor for the window (see C<gdk_window_set_cursor()>)
=item Str $.wmclass_name: don’t use (see C<gtk_window_set_wmclass()>)
=item Str $.wmclass_class: don’t use (see C<gtk_window_set_wmclass()>)
=item Int $.override_redirect: C<1> to bypass the window manager
=item C<Gnome::Gdk3::WindowTypeHint> $.type_hint: a hint of the function of the window
=end pod



#TT:0:N-GdkWindowAttr:
class GdkWindowAttr is export is repr('CStruct') {
  has str $.title;
  has int32 $.event_mask;         # required
  has int32 $.x;
  has int32 $.y;
  has int32 $.width;              # required
  has int32 $.height;             # required
  has int32 $.wclass;             # required enum GdkWindowWindowClass
  has Pointer $.visual;           #          Gnome::Gdk3::Visual
  has int32 $.window_type;        # required enum GdkWindowType
  has Pointer $.cursor;           #          Gnome::Gdk3::Cursor
  has str $.wmclass_name;
  has str $.wmclass_class;
  has int32 $.override_redirect;  # required
  has int32 $.type_hint;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class GdkGeometry

The C<Gnome::Gdk3::Geometry> struct gives the window manager information about
a window’s geometry constraints. Normally you would set these on
the GTK+ level using C<gtk_window_set_geometry_hints()>. C<Gnome::Gtk3::Window>
then sets the hints on the C<Gnome::Gdk3::Window> it creates.

C<gdk_window_set_geometry_hints()> expects the hints to be fully valid already
and simply passes them to the window manager; in contrast,
C<gtk_window_set_geometry_hints()> performs some interpretation. For example,
C<Gnome::Gtk3::Window> will apply the hints to the geometry widget instead of the
toplevel window, if you set a geometry widget. Also, the
I<min_width>/I<min_height>/I<max_width>/I<max_height> fields may be set to -1, and
C<Gnome::Gtk3::Window> will substitute the size request of the window or geometry widget.
If the minimum size hint is not provided, C<Gnome::Gtk3::Window> will use its requisition
as the minimum size. If the minimum size is provided and a geometry widget is
set, C<Gnome::Gtk3::Window> will take the minimum size as the minimum size of the
geometry widget rather than the entire window. The base size is treated
similarly.

The canonical use-case for C<gtk_window_set_geometry_hints()> is to get a
terminal widget to resize properly. Here, the terminal text area should be
the geometry widget; C<Gnome::Gtk3::Window> will then automatically set the base size to
the size of other widgets in the terminal window, such as the menubar and
scrollbar. Then, the I<width_inc> and I<height_inc> fields should be set to the
size of one character in the terminal. Finally, the base size should be set
to the size of one character. The net effect is that the minimum size of the
terminal will have a 1x1 character terminal area, and only terminal sizes on
the “character grid” will be allowed.

Here’s an example of how the terminal example would be implemented, assuming
a terminal area widget called “terminal” and a toplevel window “toplevel”:

|[<!-- language="C" -->
C<Gnome::Gdk3::Geometry> hints;

hints.base_width = terminal->char_width;
hints.base_height = terminal->char_height;
hints.min_width = terminal->char_width;
hints.min_height = terminal->char_height;
hints.width_inc = terminal->char_width;
hints.height_inc = terminal->char_height;

gtk_window_set_geometry_hints (GTK_WINDOW (toplevel),
GTK_WIDGET (terminal),
&hints,
GDK_HINT_RESIZE_INC |
GDK_HINT_MIN_SIZE |
GDK_HINT_BASE_SIZE);
]|

The other useful fields are the I<min_aspect> and I<max_aspect> fields; these
contain a width/height ratio as a floating point number. If a geometry widget
is set, the aspect applies to the geometry widget rather than the entire
window. The most common use of these hints is probably to set I<min_aspect> and
I<max_aspect> to the same value, thus forcing the window to keep a constant
aspect ratio.


=item Int $.min_width: minimum width of window (or -1 to use requisition, with C<Gnome::Gtk3::Window> only)
=item Int $.min_height: minimum height of window (or -1 to use requisition, with C<Gnome::Gtk3::Window> only)
=item Int $.max_width: maximum width of window (or -1 to use requisition, with C<Gnome::Gtk3::Window> only)
=item Int $.max_height: maximum height of window (or -1 to use requisition, with C<Gnome::Gtk3::Window> only)
=item Int $.base_width: allowed window widths are I<base_width> + I<width_inc> * N where N is any integer (-1 allowed with C<Gnome::Gtk3::Window>)
=item Int $.base_height: allowed window widths are I<base_height> + I<height_inc> * N where N is any integer (-1 allowed with C<Gnome::Gtk3::Window>)
=item Int $.width_inc: width resize increment
=item Int $.height_inc: height resize increment
=item Num $.min_aspect: minimum width/height ratio
=item Num $.max_aspect: maximum width/height ratio
=item enum C<GdkGravity> $.win_gravity: window gravity, see C<gtk_window_set_gravity()>


=end pod

#TT:0:N-GdkGeometry:
class GdkGeometry is export is repr('CStruct') {
  has int32 $.min_width;
  has int32 $.min_height;
  has int32 $.max_width;
  has int32 $.max_height;
  has int32 $.base_width;
  has int32 $.base_height;
  has int32 $.width_inc;
  has int32 $.height_inc;
  has num64 $.min_aspect;
  has num64 $.max_aspect;
  has int32 $.win_gravity;      # GdkGravity
}

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=begin comment
=head3 new( :event_mask, :wclass, :window_type, :override_redirect)

Creates a new B<Gnome::Gdk3::Window> using the attributes from I<attributes>. See B<Gnome::Gdk3::WindowAttr> and B<Gnome::Gdk3::WindowAttributesType> for
more details.  Note: to use this on displays other than the default
display, I<parent> must be specified.

Returns: (transfer full): the new B<Gnome::Gdk3::Window>

  method gdk_window_new ( GdkWindowAttr $attributes, Int $attributes_mask --> N-GObject  )

=item GdkWindowAttr $attributes; attributes of the new window
=item Int $attributes_mask; (type B<Gnome::Gdk3::WindowAttributesType>): mask indicating which fields in I<attributes> are valid
=end comment
=end pod

#TM:1:new():
#TM:0:new(:):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w2<pick-embedded-child create-surface>,
    :w4<to-embedder from-embedder moved-to-rect>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  if self.^name eq 'Gnome::Gdk3::Window' #`{{ or %options<GdkWindow> }} {

    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists { }

    else {
      my $no;

      if ? %options<empty> {
        Gnome::N::deprecate( '.new(:empty)', '.new()', '0.15.1', '0.18.0');

        # GDK_WINDOW_ROOT cannot be used because it covers the entire
        # screen, and is created by the window system. (there can only be one!).
        my GdkWindowAttr $attrs .= new(
          :event_mask(0), :wclass(GDK_INPUT_OUTPUT),
          :window_type(GDK_WINDOW_TOPLEVEL), :override_redirect(0)
        );

        # No parent, no extra attributes, toplevel
        $no = _gdk_window_new( Any, $attrs, 0);
      }

      elsif ? %options<window> {
        Gnome::N::deprecate(
          '.new(:window)', '.new(:native-object)', '0.16.0', '0.18.0'
        );

        $no = %options<window>;
        $no .= get-native-object-no-reffing
          if $no.^can('get-native-object-no-reffing');
      }

      elsif %options.keys.elems {
        die X::Gnome.new(
          :message('Unsupported options for ' ~ self.^name ~
                   ': ' ~ %options.keys.join(', ')
                  )
        );
      }

      else { #if ? %options<empty> {

        # GDK_WINDOW_ROOT cannot be used because it covers the entire
        # screen, and is created by the window system. (there can only be one!).
        my GdkWindowAttr $attrs .= new(
          :event_mask(0), :wclass(GDK_INPUT_OUTPUT),
          :window_type(GDK_WINDOW_TOPLEVEL), :override_redirect(0)
        );

        # No parent, no extra attributes, toplevel
        $no = _gdk_window_new( Any, $attrs, 0);
      }

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GdkWindow');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gdk_window_$native-sub"); };
  try { $s = &::("gdk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gdk_' /;

  self.set-class-name-of-sub('GdkWindow');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:_gdk_window_new:new()
#`{{
=begin pod
=head2 gdk_window_new

Creates a new B<Gnome::Gdk3::Window> using the attributes from
I<attributes>. See B<Gnome::Gdk3::WindowAttr> and B<Gnome::Gdk3::WindowAttributesType> for
more details.  Note: to use this on displays other than the default
display, I<parent> must be specified.

Returns: (transfer full): the new B<Gnome::Gdk3::Window>

  method gdk_window_new ( GdkWindowAttr $attributes, Int $attributes_mask --> N-GObject  )

=item GdkWindowAttr $attributes; attributes of the new window
=item Int $attributes_mask; (type B<Gnome::Gdk3::WindowAttributesType>): mask indicating which fields in I<attributes> are valid

=end pod
}}

sub _gdk_window_new ( N-GObject $parent, GdkWindowAttr $attributes, int32 $attributes_mask --> N-GObject)
  is native(&gdk-lib)
  is symbol('gdk_window_new')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_destroy:
=begin pod
=head2 gdk_window_destroy

Internal function to destroy a window. Like C<gdk_window_destroy()>,
but does not drop the reference count created by C<gdk_window_new()>.

  method gdk_window_destroy ( )


=end pod

sub gdk_window_destroy ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_window_get_window_type:
=begin pod
=head2 [[gdk_] window_] get_window_type

Gets the type of the window. See B<Gnome::Gdk3::WindowType>.

Returns: type of window

  method gdk_window_get_window_type ( --> GdkWindowType  )


=end pod

sub gdk_window_get_window_type ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_is_destroyed:
=begin pod
=head2 [[gdk_] window_] is_destroyed

Check to see if a window is destroyed..

Returns: C<1> if the window is destroyed


  method gdk_window_is_destroyed ( --> Int  )


=end pod

sub gdk_window_is_destroyed ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_visual:
=begin pod
=head2 [[gdk_] window_] get_visual

Gets the B<Gnome::Gdk3::Visual> describing the pixel format of I<window>.


  method gdk_window_get_visual ( --> N-GObject  )


=end pod

sub gdk_window_get_visual ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_screen:
=begin pod
=head2 [[gdk_] window_] get_screen

Gets the B<Gnome::Gdk3::Screen> associated with a B<Gnome::Gdk3::Window>.


  method gdk_window_get_screen ( --> N-GObject  )


=end pod

sub gdk_window_get_screen ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_display:
=begin pod
=head2 [[gdk_] window_] get_display

Gets the B<Gnome::Gdk3::Display> associated with a B<Gnome::Gdk3::Window>.

Returns: (transfer none): the B<Gnome::Gdk3::Display> associated with I<window>


  method gdk_window_get_display ( --> N-GObject  )


=end pod

sub gdk_window_get_display ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_show:
=begin pod
=head2 gdk_window_show

Like C<gdk_window_show_unraised()>, but also raises the window to the
top of the window stack (moves the window to the front of the
Z-order).

This function maps a window so it’s visible onscreen. Its opposite
is C<gdk_window_hide()>.

When implementing a B<Gnome::Gtk3::Widget>, you should call this function on the widget's B<Gnome::Gdk3::Window> as part of the “map” method.

  method gdk_window_show ( )


=end pod

sub gdk_window_show ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_hide:
=begin pod
=head2 gdk_window_hide

For toplevel windows, withdraws them, so they will no longer be
known to the window manager; for all windows, unmaps them, so
they won’t be displayed. Normally done automatically as
part of C<gtk_widget_hide()>.

  method gdk_window_hide ( )


=end pod

sub gdk_window_hide ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_withdraw:
=begin pod
=head2 gdk_window_withdraw

Withdraws a window (unmaps it and asks the window manager to forget about it).
This function is not really useful as C<gdk_window_hide()> automatically
withdraws toplevel windows before hiding them.

  method gdk_window_withdraw ( )


=end pod

sub gdk_window_withdraw ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_show_unraised:
=begin pod
=head2 [[gdk_] window_] show_unraised

Shows a B<Gnome::Gdk3::Window> onscreen, but does not modify its stacking
order. In contrast, C<gdk_window_show()> will raise the window
to the top of the window stack.

On the X11 platform, in Xlib terms, this function calls
C<XMapWindow()> (it also updates some internal GDK state, which means
that you can’t really use C<XMapWindow()> directly on a GDK window).

  method gdk_window_show_unraised ( )


=end pod

sub gdk_window_show_unraised ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_window_move:
=begin pod
=head2 gdk_window_move

Repositions a window relative to its parent window.
For toplevel windows, window managers may ignore or modify the move;
you should probably use C<gtk_window_move()> on a B<Gnome::Gtk3::Window> widget
anyway, instead of using GDK functions. For child windows,
the move will reliably succeed.

If you’re also planning to resize the window, use C<gdk_window_move_resize()>
to both move and resize simultaneously, for a nicer visual effect.

  method gdk_window_move ( Int $x, Int $y )

=item Int $x; X coordinate relative to window’s parent
=item Int $y; Y coordinate relative to window’s parent

=end pod

sub gdk_window_move ( N-GObject $window, int32 $x, int32 $y )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_window_resize:
=begin pod
=head2 gdk_window_resize

Resizes I<window>; for toplevel windows, asks the window manager to resize
the window. The window manager may not allow the resize. When using GTK+,
use C<gtk_window_resize()> instead of this low-level GDK function.

Windows may not be resized below 1x1.

If you’re also planning to move the window, use C<gdk_window_move_resize()>
to both move and resize simultaneously, for a nicer visual effect.

  method gdk_window_resize ( Int $width, Int $height )

=item Int $width; new width of the window
=item Int $height; new height of the window

=end pod

sub gdk_window_resize ( N-GObject $window, int32 $width, int32 $height )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_move_resize:
=begin pod
=head2 [[gdk_] window_] move_resize

Equivalent to calling C<gdk_window_move()> and C<gdk_window_resize()>,
except that both operations are performed at once, avoiding strange
visual effects. (i.e. the user may be able to see the window first
move, then resize, if you don’t use C<gdk_window_move_resize()>.)

  method gdk_window_move_resize ( Int $x, Int $y, Int $width, Int $height )

=item Int $x; new X position relative to window’s parent
=item Int $y; new Y position relative to window’s parent
=item Int $width; new width
=item Int $height; new height

=end pod

sub gdk_window_move_resize ( N-GObject $window, int32 $x, int32 $y, int32 $width, int32 $height )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_move_to_rect:
=begin pod
=head2 [[gdk_] window_] move_to_rect

Moves I<window> to I<rect>, aligning their anchor points.

I<rect> is relative to the top-left corner of the window that I<window> is
transient for. I<rect_anchor> and I<window_anchor> determine anchor points on
I<rect> and I<window> to pin together. I<rect>'s anchor point can optionally be
offset by I<rect_anchor_dx> and I<rect_anchor_dy>, which is equivalent to
offsetting the position of I<window>.

I<anchor_hints> determines how I<window> will be moved if the anchor points cause
it to move off-screen. For example, C<GDK_ANCHOR_FLIP_X> will replace
C<GDK_GRAVITY_NORTH_WEST> with C<GDK_GRAVITY_NORTH_EAST> and vice versa if
I<window> extends beyond the left or right edges of the monitor.

Connect to the  I<moved-to-rect> signal to find out how it was
actually positioned.

Stability: Private

  method gdk_window_move_to_rect ( N-GObject $rect, GdkGravity $rect_anchor, GdkGravity $window_anchor, GdkAnchorHints $anchor_hints, Int $rect_anchor_dx, Int $rect_anchor_dy )

=item N-GObject $rect; (not nullable): the destination B<Gnome::Gdk3::Rectangle> to align I<window> with
=item GdkGravity $rect_anchor; the point on I<rect> to align with I<window>'s anchor point
=item GdkGravity $window_anchor; the point on I<window> to align with I<rect>'s anchor point
=item GdkAnchorHints $anchor_hints; positioning hints to use when limited on space
=item Int $rect_anchor_dx; horizontal offset to shift I<window>, i.e. I<rect>'s anchor point
=item Int $rect_anchor_dy; vertical offset to shift I<window>, i.e. I<rect>'s anchor point

=end pod

sub gdk_window_move_to_rect ( N-GObject $window, N-GObject $rect, int32 $rect_anchor, int32 $window_anchor, int32 $anchor_hints, int32 $rect_anchor_dx, int32 $rect_anchor_dy )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_reparent:
=begin pod
=head2 gdk_window_reparent

Reparents I<window> into the given I<new_parent>. The window being
reparented will be unmapped as a side effect.


  method gdk_window_reparent ( N-GObject $new_parent, Int $x, Int $y )

=item N-GObject $new_parent; new parent to move I<window> into
=item Int $x; X location inside the new parent
=item Int $y; Y location inside the new parent

=end pod

sub gdk_window_reparent ( N-GObject $window, N-GObject $new_parent, int32 $x, int32 $y )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_raise:
=begin pod
=head2 gdk_window_raise

Raises I<window> to the top of the Z-order (stacking order), so that
other windows with the same parent window appear below I<window>.
This is true whether or not the windows are visible.

If I<window> is a toplevel, the window manager may choose to deny the
request to move the window in the Z-order, C<gdk_window_raise()> only
requests the restack, does not guarantee it.

  method gdk_window_raise ( )


=end pod

sub gdk_window_raise ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_lower:
=begin pod
=head2 gdk_window_lower

Lowers I<window> to the bottom of the Z-order (stacking order), so that
other windows with the same parent window appear above I<window>.
This is true whether or not the other windows are visible.

If I<window> is a toplevel, the window manager may choose to deny the
request to move the window in the Z-order, C<gdk_window_lower()> only
requests the restack, does not guarantee it.

Note that C<gdk_window_show()> raises the window again, so don’t call this
function before C<gdk_window_show()>. (Try C<gdk_window_show_unraised()>.)

  method gdk_window_lower ( )


=end pod

sub gdk_window_lower ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_restack:
=begin pod
=head2 gdk_window_restack

Changes the position of  I<window> in the Z-order (stacking order), so that
it is above I<sibling> (if I<above> is C<1>) or below I<sibling> (if I<above> is
C<0>).

If I<sibling> is C<Any>, then this either raises (if I<above> is C<1>) or
lowers the window.

If I<window> is a toplevel, the window manager may choose to deny the
request to move the window in the Z-order, C<gdk_window_restack()> only
requests the restack, does not guarantee it.


  method gdk_window_restack ( N-GObject $sibling, Int $above )

=item N-GObject $sibling; (allow-none): a B<Gnome::Gdk3::Window> that is a sibling of I<window>, or C<Any>
=item Int $above; a boolean

=end pod

sub gdk_window_restack ( N-GObject $window, N-GObject $sibling, int32 $above )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_focus:
=begin pod
=head2 gdk_window_focus

Sets keyboard focus to I<window>. In most cases, C<gtk_window_present()>
should be used on a B<Gnome::Gtk3::Window>, rather than calling this function.


  method gdk_window_focus ( UInt $timestamp )

=item UInt $timestamp; timestamp of the event triggering the window focus

=end pod

sub gdk_window_focus ( N-GObject $window, uint32 $timestamp )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_user_data:
=begin pod
=head2 [[gdk_] window_] set_user_data

For most purposes this function is deprecated in favor of
C<g_object_set_data()>. However, for historical reasons GTK+ stores
the B<Gnome::Gtk3::Widget> that owns a B<Gnome::Gdk3::Window> as user data on the
B<Gnome::Gdk3::Window>. So, custom widget implementations should use
this function for that. If GTK+ receives an event for a B<Gnome::Gdk3::Window>,
and the user data for the window is non-C<Any>, GTK+ will assume the
user data is a B<Gnome::Gtk3::Widget>, and forward the event to that widget.


  method gdk_window_set_user_data ( Pointer $user_data )

=item Pointer $user_data; (allow-none) (type GObject.Object): user data

=end pod

sub gdk_window_set_user_data ( N-GObject $window, Pointer $user_data )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_override_redirect:
=begin pod
=head2 [[gdk_] window_] set_override_redirect

An override redirect window is not under the control of the window manager.
This means it won’t have a titlebar, won’t be minimizable, etc. - it will
be entirely under the control of the application. The window manager
can’t see the override redirect window at all.

Override redirect should only be used for short-lived temporary
windows, such as popup menus. B<Gnome::Gtk3::Menu> uses an override redirect
window in its implementation, for example.


  method gdk_window_set_override_redirect ( Int $override_redirect )

=item Int $override_redirect; C<1> if window should be override redirect

=end pod

sub gdk_window_set_override_redirect ( N-GObject $window, int32 $override_redirect )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_accept_focus:
=begin pod
=head2 [[gdk_] window_] get_accept_focus

Determines whether or not the desktop environment shuld be hinted that
the window does not want to receive input focus.

Returns: whether or not the window should receive input focus.


  method gdk_window_get_accept_focus ( --> Int  )


=end pod

sub gdk_window_get_accept_focus ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_accept_focus:
=begin pod
=head2 [[gdk_] window_] set_accept_focus

Setting I<accept_focus> to C<0> hints the desktop environment that the
window doesn’t want to receive input focus.

On X, it is the responsibility of the window manager to interpret this
hint. ICCCM-compliant window manager usually respect it.


  method gdk_window_set_accept_focus ( Int $accept_focus )

=item Int $accept_focus; C<1> if the window should receive input focus

=end pod

sub gdk_window_set_accept_focus ( N-GObject $window, int32 $accept_focus )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_focus_on_map:
=begin pod
=head2 [[gdk_] window_] get_focus_on_map

Determines whether or not the desktop environment should be hinted that the
window does not want to receive input focus when it is mapped.

Returns: whether or not the window wants to receive input focus when
it is mapped.


  method gdk_window_get_focus_on_map ( --> Int  )


=end pod

sub gdk_window_get_focus_on_map ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_focus_on_map:
=begin pod
=head2 [[gdk_] window_] set_focus_on_map

Setting I<focus_on_map> to C<0> hints the desktop environment that the
window doesn’t want to receive input focus when it is mapped.
focus_on_map should be turned off for windows that aren’t triggered
interactively (such as popups from network activity).

On X, it is the responsibility of the window manager to interpret
this hint. Window managers following the freedesktop.org window
manager extension specification should respect it.


  method gdk_window_set_focus_on_map ( Int $focus_on_map )

=item Int $focus_on_map; C<1> if the window should receive input focus when mapped

=end pod

sub gdk_window_set_focus_on_map ( N-GObject $window, int32 $focus_on_map )
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_window_add_filter:
=begin pod
=head2 [[gdk_] window_] add_filter

Adds an event filter to I<window>, allowing you to intercept events
before they reach GDK. This is a low-level operation and makes it
easy to break GDK and/or GTK+, so you have to know what you're
doing. Pass C<Any> for I<window> to get all events for all windows,
instead of events for a specific window.

If you are interested in X GenericEvents, bear in mind that
C<XGetEventData()> has been already called on the event, and
C<XFreeEventData()> must not be called within I<function>.

  method gdk_window_add_filter ( GdkFilterFunc $function, Pointer $data )

=item GdkFilterFunc $function; filter callback
=item Pointer $data; data to pass to filter callback

=end pod

sub gdk_window_add_filter ( N-GObject $window, GdkFilterFunc $function, Pointer $data )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_remove_filter:
=begin pod
=head2 [[gdk_] window_] remove_filter

Remove a filter previously added with C<gdk_window_add_filter()>.

  method gdk_window_remove_filter ( GdkFilterFunc $function, Pointer $data )

=item GdkFilterFunc $function; previously-added filter function
=item Pointer $data; user data for previously-added filter function

=end pod

sub gdk_window_remove_filter ( N-GObject $window, GdkFilterFunc $function, Pointer $data )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_window_scroll:
=begin pod
=head2 gdk_window_scroll

Scroll the contents of I<window>, both pixels and children, by the
given amount. I<window> itself does not move. Portions of the window
that the scroll operation brings in from offscreen areas are
invalidated. The invalidated region may be bigger than what would
strictly be necessary.

For X11, a minimum area will be invalidated if the window has no
subwindows, or if the edges of the window’s parent do not extend
beyond the edges of the window. In other cases, a multi-step process
is used to scroll the window which may produce temporary visual
artifacts and unnecessary invalidations.

  method gdk_window_scroll ( Int $dx, Int $dy )

=item Int $dx; Amount to scroll in the X direction
=item Int $dy; Amount to scroll in the Y direction

=end pod

sub gdk_window_scroll ( N-GObject $window, int32 $dx, int32 $dy )
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_window_move_region:
=begin pod
=head2 [[gdk_] window_] move_region

Move the part of I<window> indicated by I<region> by I<dy> pixels in the Y
direction and I<dx> pixels in the X direction. The portions of I<region>
that not covered by the new position of I<region> are invalidated.

Child windows are not moved.


  method gdk_window_move_region ( cairo_region_t $region, Int $dx, Int $dy )

=item cairo_region_t $region; The B<cairo_region_t> to move
=item Int $dx; Amount to move in the X direction
=item Int $dy; Amount to move in the Y direction

=end pod

sub gdk_window_move_region ( N-GObject $window, cairo_region_t $region, int32 $dx, int32 $dy )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_window_ensure_native:
=begin pod
=head2 [[gdk_] window_] ensure_native

Tries to ensure that there is a window-system native window for this
B<Gnome::Gdk3::Window>. This may fail in some situations, returning C<0>.

Offscreen window and children of them can never have native windows.

Some backends may not support native child windows.

Returns: C<1> if the window has a native window, C<0> otherwise


  method gdk_window_ensure_native ( --> Int  )


=end pod

sub gdk_window_ensure_native ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_window_shape_combine_region:
=begin pod
=head2 [[gdk_] window_] shape_combine_region

Makes pixels in I<window> outside I<shape_region> be transparent,
so that the window may be nonrectangular.

If I<shape_region> is C<Any>, the shape will be unset, so the whole
window will be opaque again. I<offset_x> and I<offset_y> are ignored
if I<shape_region> is C<Any>.

On the X11 platform, this uses an X server extension which is
widely available on most common platforms, but not available on
very old X servers, and occasionally the implementation will be
buggy. On servers without the shape extension, this function
will do nothing.

This function works on both toplevel and child windows.

  method gdk_window_shape_combine_region ( cairo_region_t $shape_region, Int $offset_x, Int $offset_y )

=item cairo_region_t $shape_region; (allow-none): region of window to be non-transparent
=item Int $offset_x; X position of I<shape_region> in I<window> coordinates
=item Int $offset_y; Y position of I<shape_region> in I<window> coordinates

=end pod

sub gdk_window_shape_combine_region ( N-GObject $window, cairo_region_t $shape_region, int32 $offset_x, int32 $offset_y )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_child_shapes:
=begin pod
=head2 [[gdk_] window_] set_child_shapes

Sets the shape mask of I<window> to the union of shape masks
for all children of I<window>, ignoring the shape mask of I<window>
itself. Contrast with C<gdk_window_merge_child_shapes()> which includes
the shape mask of I<window> in the masks to be merged.

  method gdk_window_set_child_shapes ( )


=end pod

sub gdk_window_set_child_shapes ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_merge_child_shapes:
=begin pod
=head2 [[gdk_] window_] merge_child_shapes

Merges the shape masks for any child windows into the
shape mask for I<window>. i.e. the union of all masks
for I<window> and its children will become the new mask
for I<window>. See C<gdk_window_shape_combine_region()>.

This function is distinct from C<gdk_window_set_child_shapes()>
because it includes I<window>’s shape mask in the set of shapes to
be merged.

  method gdk_window_merge_child_shapes ( )


=end pod

sub gdk_window_merge_child_shapes ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_window_input_shape_combine_region:
=begin pod
=head2 [[gdk_] window_] input_shape_combine_region

Like C<gdk_window_shape_combine_region()>, but the shape applies
only to event handling. Mouse events which happen while
the pointer position corresponds to an unset bit in the
mask will be passed on the window below I<window>.

An input shape is typically used with RGBA windows.
The alpha channel of the window defines which pixels are
invisible and allows for nicely antialiased borders,
and the input shape controls where the window is
“clickable”.

On the X11 platform, this requires version 1.1 of the
shape extension.

On the Win32 platform, this functionality is not present and the
function does nothing.


  method gdk_window_input_shape_combine_region ( cairo_region_t $shape_region, Int $offset_x, Int $offset_y )

=item cairo_region_t $shape_region; region of window to be non-transparent
=item Int $offset_x; X position of I<shape_region> in I<window> coordinates
=item Int $offset_y; Y position of I<shape_region> in I<window> coordinates

=end pod

sub gdk_window_input_shape_combine_region ( N-GObject $window, cairo_region_t $shape_region, int32 $offset_x, int32 $offset_y )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_child_input_shapes:
=begin pod
=head2 [[gdk_] window_] set_child_input_shapes

Sets the input shape mask of I<window> to the union of input shape masks
for all children of I<window>, ignoring the input shape mask of I<window>
itself. Contrast with C<gdk_window_merge_child_input_shapes()> which includes
the input shape mask of I<window> in the masks to be merged.


  method gdk_window_set_child_input_shapes ( )


=end pod

sub gdk_window_set_child_input_shapes ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_merge_child_input_shapes:
=begin pod
=head2 [[gdk_] window_] merge_child_input_shapes

Merges the input shape masks for any child windows into the
input shape mask for I<window>. i.e. the union of all input masks
for I<window> and its children will become the new input mask
for I<window>. See C<gdk_window_input_shape_combine_region()>.

This function is distinct from C<gdk_window_set_child_input_shapes()>
because it includes I<window>’s input shape mask in the set of
shapes to be merged.


  method gdk_window_merge_child_input_shapes ( )


=end pod

sub gdk_window_merge_child_input_shapes ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_pass_through:
=begin pod
=head2 [[gdk_] window_] set_pass_through

Sets whether input to the window is passed through to the window
below.

The default value of this is C<0>, which means that pointer
events that happen inside the window are send first to the window,
but if the event is not selected by the event mask then the event
is sent to the parent window, and so on up the hierarchy.

If I<pass_through> is C<1> then such pointer events happen as if the
window wasn't there at all, and thus will be sent first to any
windows below I<window>. This is useful if the window is used in a
transparent fashion. In the terminology of the web this would be called
"pointer-events: none".

Note that a window with I<pass_through> C<1> can still have a subwindow
without pass through, so you can get events on a subset of a window. And in
that cases you would get the in-between related events such as the pointer
enter/leave events on its way to the destination window.


  method gdk_window_set_pass_through ( Int $pass_through )

=item Int $pass_through; a boolean

=end pod

sub gdk_window_set_pass_through ( N-GObject $window, int32 $pass_through )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_pass_through:
=begin pod
=head2 [[gdk_] window_] get_pass_through

Returns whether input to the window is passed through to the window
below.

See C<gdk_window_set_pass_through()> for details


  method gdk_window_get_pass_through ( --> Int  )


=end pod

sub gdk_window_get_pass_through ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_is_visible:
=begin pod
=head2 [[gdk_] window_] is_visible

Checks whether the window has been mapped (with C<gdk_window_show()> or
C<gdk_window_show_unraised()>).

Returns: C<1> if the window is mapped

  method gdk_window_is_visible ( --> Int  )


=end pod

sub gdk_window_is_visible ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_is_viewable:
=begin pod
=head2 [[gdk_] window_] is_viewable

Check if the window and all ancestors of the window are
mapped. (This is not necessarily "viewable" in the X sense, since
we only check as far as we have GDK window parents, not to the root
window.)

Returns: C<1> if the window is viewable

  method gdk_window_is_viewable ( --> Int  )


=end pod

sub gdk_window_is_viewable ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_is_input_only:
=begin pod
=head2 [[gdk_] window_] is_input_only

Determines whether or not the window is an input only window.

Returns: C<1> if I<window> is input only


  method gdk_window_is_input_only ( --> Int  )


=end pod

sub gdk_window_is_input_only ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_is_shaped:
=begin pod
=head2 [[gdk_] window_] is_shaped

Determines whether or not the window is shaped.

Returns: C<1> if I<window> is shaped


  method gdk_window_is_shaped ( --> Int  )


=end pod

sub gdk_window_is_shaped ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_state:
=begin pod
=head2 [[gdk_] window_] get_state

Gets the bitwise OR of the currently active window state flags,
from the B<Gnome::Gdk3::WindowState> enumeration.

Returns: window state bitfield

  method gdk_window_get_state ( --> GdkWindowState  )


=end pod

sub gdk_window_get_state ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_invalidate_handler:
=begin pod
=head2 [[gdk_] window_] set_invalidate_handler

Registers an invalidate handler for a specific window. This
will get called whenever a region in the window or its children
is invalidated.

This can be used to record the invalidated region, which is
useful if you are keeping an offscreen copy of some region
and want to keep it up to date. You can also modify the
invalidated region in case you’re doing some effect where
e.g. a child widget appears in multiple places.


  method gdk_window_set_invalidate_handler ( GdkWindowInvalidateHandlerFunc $handler )

=item GdkWindowInvalidateHandlerFunc $handler; a B<Gnome::Gdk3::WindowInvalidateHandlerFunc> callback function

=end pod

sub gdk_window_set_invalidate_handler ( N-GObject $window, GdkWindowInvalidateHandlerFunc $handler )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_window_has_native:
=begin pod
=head2 [[gdk_] window_] has_native

Checks whether the window has a native window or not. Note that
you can use C<gdk_window_ensure_native()> if a native window is needed.

Returns: C<1> if the I<window> has a native window, C<0> otherwise.


  method gdk_window_has_native ( --> Int  )


=end pod

sub gdk_window_has_native ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_type_hint:
=begin pod
=head2 [[gdk_] window_] set_type_hint

The application can use this call to provide a hint to the window
manager about the functionality of a window. The window manager
can use this information when determining the decoration and behaviour
of the window.

The hint must be set before the window is mapped.

  method gdk_window_set_type_hint ( GdkWindowTypeHint32 $hint )

=item GdkWindowTypeHint32 $hint; A hint of the function this window will have

=end pod

sub gdk_window_set_type_hint ( N-GObject $window, int32 $hint )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_type_hint:
=begin pod
=head2 [[gdk_] window_] get_type_hint

This function returns the type hint set for a window.

Returns: The type hint set for I<window>


  method gdk_window_get_type_hint ( --> GdkWindowTypeHint32  )


=end pod

sub gdk_window_get_type_hint ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_modal_hint:
=begin pod
=head2 [[gdk_] window_] get_modal_hint

Determines whether or not the window manager is hinted that I<window>
has modal behaviour.

Returns: whether or not the window has the modal hint set.


  method gdk_window_get_modal_hint ( --> Int  )


=end pod

sub gdk_window_get_modal_hint ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_modal_hint:
=begin pod
=head2 [[gdk_] window_] set_modal_hint

The application can use this hint to tell the window manager
that a certain window has modal behaviour. The window manager
can use this information to handle modal windows in a special
way.

You should only use this on windows for which you have
previously called C<gdk_window_set_transient_for()>

  method gdk_window_set_modal_hint ( Int $modal )

=item Int $modal; C<1> if the window is modal, C<0> otherwise.

=end pod

sub gdk_window_set_modal_hint ( N-GObject $window, int32 $modal )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_skip_taskbar_hint:
=begin pod
=head2 [[gdk_] window_] set_skip_taskbar_hint

Toggles whether a window should appear in a task list or window
list. If a window’s semantic type as specified with
C<gdk_window_set_type_hint()> already fully describes the window, this
function should not be called in addition,
instead you should allow the window to be treated according to
standard policy for its semantic type.


  method gdk_window_set_skip_taskbar_hint ( Int $skips_taskbar )

=item Int $skips_taskbar; C<1> to skip the taskbar

=end pod

sub gdk_window_set_skip_taskbar_hint ( N-GObject $window, int32 $skips_taskbar )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_skip_pager_hint:
=begin pod
=head2 [[gdk_] window_] set_skip_pager_hint

Toggles whether a window should appear in a pager (workspace
switcher, or other desktop utility program that displays a small
thumbnail representation of the windows on the desktop). If a
window’s semantic type as specified with C<gdk_window_set_type_hint()>
already fully describes the window, this function should
not be called in addition, instead you should
allow the window to be treated according to standard policy for
its semantic type.


  method gdk_window_set_skip_pager_hint ( Int $skips_pager )

=item Int $skips_pager; C<1> to skip the pager

=end pod

sub gdk_window_set_skip_pager_hint ( N-GObject $window, int32 $skips_pager )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_urgency_hint:
=begin pod
=head2 [[gdk_] window_] set_urgency_hint

Toggles whether a window needs the user's
urgent attention.


  method gdk_window_set_urgency_hint ( Int $urgent )

=item Int $urgent; C<1> if the window is urgent

=end pod

sub gdk_window_set_urgency_hint ( N-GObject $window, int32 $urgent )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_geometry_hints:
=begin pod
=head2 [[gdk_] window_] set_geometry_hints

Sets the geometry hints for I<window>. Hints flagged in I<geom_mask>
are set, hints not flagged in I<geom_mask> are unset.
To unset all hints, use a I<geom_mask> of 0 and a I<geometry> of C<Any>.

This function provides hints to the windowing system about
acceptable sizes for a toplevel window. The purpose of
this is to constrain user resizing, but the windowing system
will typically  (but is not required to) also constrain the
current size of the window to the provided values and
constrain programatic resizing via C<gdk_window_resize()> or
C<gdk_window_move_resize()>.

Note that on X11, this effect has no effect on windows
of type C<GDK_WINDOW_TEMP> or windows where override redirect
has been turned on via C<gdk_window_set_override_redirect()>
since these windows are not resizable by the user.

Since you can’t count on the windowing system doing the
constraints for programmatic resizes, you should generally
call C<gdk_window_constrain_size()> yourself to determine
appropriate sizes.


  method gdk_window_set_geometry_hints ( GdkGeometry $geometry, GdkWindowHints $geom_mask )

=item GdkGeometry $geometry; geometry hints
=item GdkWindowHints $geom_mask; bitmask indicating fields of I<geometry> to pay attention to

=end pod

sub gdk_window_set_geometry_hints ( N-GObject $window, GdkGeometry $geometry, int32 $geom_mask )
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_clip_region:
=begin pod
=head2 [[gdk_] window_] get_clip_region

Computes the region of a window that potentially can be written
to by drawing primitives. This region may not take into account
other factors such as if the window is obscured by other windows,
but no area outside of this region will be affected by drawing
primitives.

Returns: a B<cairo_region_t>. This must be freed with C<cairo_region_destroy()>
when you are done.

  method gdk_window_get_clip_region ( --> cairo_region_t  )


=end pod

sub gdk_window_get_clip_region ( N-GObject $window )
  returns cairo_region_t
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_visible_region:
=begin pod
=head2 [[gdk_] window_] get_visible_region

Computes the region of the I<window> that is potentially visible.
This does not necessarily take into account if the window is
obscured by other windows, but no area outside of this region
is visible.

Returns: a B<cairo_region_t>. This must be freed with C<cairo_region_destroy()>
when you are done.

  method gdk_window_get_visible_region ( --> cairo_region_t  )


=end pod

sub gdk_window_get_visible_region ( N-GObject $window )
  returns cairo_region_t
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_mark_paint_from_clip:
=begin pod
=head2 [[gdk_] window_] mark_paint_from_clip

If you call this during a paint (e.g. between C<gdk_window_begin_paint_region()>
and C<gdk_window_end_paint()> then GDK will mark the current clip region of the
window as being drawn. This is required when mixing GL rendering via
C<gdk_cairo_draw_from_gl()> and cairo rendering, as otherwise GDK has no way
of knowing when something paints over the GL-drawn regions.

This is typically called automatically by GTK+ and you don't need
to care about this.


  method gdk_window_mark_paint_from_clip ( cairo_t $cr )

=item cairo_t $cr; a B<cairo_t>

=end pod

sub gdk_window_mark_paint_from_clip ( N-GObject $window, cairo_t $cr )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_begin_draw_frame:
=begin pod
=head2 [[gdk_] window_] begin_draw_frame

Indicates that you are beginning the process of redrawing I<region>
on I<window>, and provides you with a B<Gnome::Gdk3::DrawingContext>.

If I<window> is a top level B<Gnome::Gdk3::Window>, backed by a native window
implementation, a backing store (offscreen buffer) large enough to
contain I<region> will be created. The backing store will be initialized
with the background color or background surface for I<window>. Then, all
drawing operations performed on I<window> will be diverted to the
backing store. When you call C<gdk_window_end_frame()>, the contents of
the backing store will be copied to I<window>, making it visible
on screen. Only the part of I<window> contained in I<region> will be
modified; that is, drawing operations are clipped to I<region>.

The net result of all this is to remove flicker, because the user
sees the finished product appear all at once when you call
C<gdk_window_end_draw_frame()>. If you draw to I<window> directly without
calling C<gdk_window_begin_draw_frame()>, the user may see flicker
as individual drawing operations are performed in sequence.

When using GTK+, the widget system automatically places calls to
C<gdk_window_begin_draw_frame()> and C<gdk_window_end_draw_frame()> around
emissions of the `B<Gnome::Gtk3::Widget>::draw` signal. That is, if you’re
drawing the contents of the widget yourself, you can assume that the
widget has a cleared background, is already set as the clip region,
and already has a backing store. Therefore in most cases, application
code in GTK does not need to call C<gdk_window_begin_draw_frame()>
explicitly.

Returns: (transfer none): a B<Gnome::Gdk3::DrawingContext> context that should be
used to draw the contents of the window; the returned context is owned
by GDK.


  method gdk_window_begin_draw_frame ( cairo_region_t $region --> N-GObject  )

=item cairo_region_t $region; a Cairo region

=end pod

sub gdk_window_begin_draw_frame ( N-GObject $window, cairo_region_t $region )
  returns N-GObject
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_window_end_draw_frame:
=begin pod
=head2 [[gdk_] window_] end_draw_frame

Indicates that the drawing of the contents of I<window> started with
C<gdk_window_begin_frame()> has been completed.

This function will take care of destroying the B<Gnome::Gdk3::DrawingContext>.

It is an error to call this function without a matching
C<gdk_window_begin_frame()> first.


  method gdk_window_end_draw_frame ( N-GObject $context )

=item N-GObject $context; the B<Gnome::Gdk3::DrawingContext> created by C<gdk_window_begin_draw_frame()>

=end pod

sub gdk_window_end_draw_frame ( N-GObject $window, N-GObject $context )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_title:
=begin pod
=head2 [[gdk_] window_] set_title

Sets the title of a toplevel window, to be displayed in the titlebar.
If you haven’t explicitly set the icon name for the window
(using C<gdk_window_set_icon_name()>), the icon name will be set to
I<title> as well. I<title> must be in UTF-8 encoding (as with all
user-readable strings in GDK/GTK+). I<title> may not be C<Any>.

  method gdk_window_set_title ( Str $title )

=item Str $title; title of I<window>

=end pod

sub gdk_window_set_title ( N-GObject $window, Str $title )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_role:
=begin pod
=head2 [[gdk_] window_] set_role

When using GTK+, typically you should use C<gtk_window_set_role()> instead
of this low-level function.

The window manager and session manager use a window’s role to
distinguish it from other kinds of window in the same application.
When an application is restarted after being saved in a previous
session, all windows with the same title and role are treated as
interchangeable.  So if you have two windows with the same title
that should be distinguished for session management purposes, you
should set the role on those windows. It doesn’t matter what string
you use for the role, as long as you have a different role for each
non-interchangeable kind of window.


  method gdk_window_set_role ( Str $role )

=item Str $role; a string indicating its role

=end pod

sub gdk_window_set_role ( N-GObject $window, Str $role )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_startup_id:
=begin pod
=head2 [[gdk_] window_] set_startup_id

When using GTK+, typically you should use C<gtk_window_set_startup_id()>
instead of this low-level function.



  method gdk_window_set_startup_id ( Str $startup_id )

=item Str $startup_id; a string with startup-notification identifier

=end pod

sub gdk_window_set_startup_id ( N-GObject $window, Str $startup_id )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_transient_for:
=begin pod
=head2 [[gdk_] window_] set_transient_for

Indicates to the window manager that I<window> is a transient dialog
associated with the application window I<parent>. This allows the
window manager to do things like center I<window> on I<parent> and
keep I<window> above I<parent>.

See C<gtk_window_set_transient_for()> if you’re using B<Gnome::Gtk3::Window> or
B<Gnome::Gtk3::Dialog>.

  method gdk_window_set_transient_for ( N-GObject $parent )

=item N-GObject $parent; another toplevel B<Gnome::Gdk3::Window>

=end pod

sub gdk_window_set_transient_for ( N-GObject $window, N-GObject $parent )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_cursor:
=begin pod
=head2 [[gdk_] window_] set_cursor

Sets the default mouse pointer for a B<Gnome::Gdk3::Window>.

Note that I<cursor> must be for the same display as I<window>.

Use C<gdk_cursor_new_for_display()> or C<gdk_cursor_new_from_pixbuf()> to
create the cursor. To make the cursor invisible, use C<GDK_BLANK_CURSOR>.
Passing C<Any> for the I<cursor> argument to C<gdk_window_set_cursor()> means
that I<window> will use the cursor of its parent window. Most windows
should use this default.

  method gdk_window_set_cursor ( N-GObject $cursor )

=item N-GObject $cursor; (allow-none): a cursor

=end pod

sub gdk_window_set_cursor ( N-GObject $window, N-GObject $cursor )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_cursor:
=begin pod
=head2 [[gdk_] window_] get_cursor

Retrieves a B<Gnome::Gdk3::Cursor> pointer for the cursor currently set on the
specified B<Gnome::Gdk3::Window>, or C<Any>.  If the return value is C<Any> then
there is no custom cursor set on the specified window, and it is
using the cursor for its parent window.

Returns: (nullable) (transfer none): a B<Gnome::Gdk3::Cursor>, or C<Any>. The
returned object is owned by the B<Gnome::Gdk3::Window> and should not be
unreferenced directly. Use C<gdk_window_set_cursor()> to unset the
cursor of the window


  method gdk_window_get_cursor ( --> N-GObject  )


=end pod

sub gdk_window_get_cursor ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_device_cursor:
=begin pod
=head2 [[gdk_] window_] set_device_cursor

Sets a specific B<Gnome::Gdk3::Cursor> for a given device when it gets inside I<window>.
Use C<gdk_cursor_new_for_display()> or C<gdk_cursor_new_from_pixbuf()> to create
the cursor. To make the cursor invisible, use C<GDK_BLANK_CURSOR>. Passing
C<Any> for the I<cursor> argument to C<gdk_window_set_cursor()> means that
I<window> will use the cursor of its parent window. Most windows should
use this default.


  method gdk_window_set_device_cursor ( N-GObject $device, N-GObject $cursor )

=item N-GObject $device; a master, pointer B<Gnome::Gdk3::Device>
=item N-GObject $cursor; a B<Gnome::Gdk3::Cursor>

=end pod

sub gdk_window_set_device_cursor ( N-GObject $window, N-GObject $device, N-GObject $cursor )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_device_cursor:
=begin pod
=head2 [[gdk_] window_] get_device_cursor

Retrieves a B<Gnome::Gdk3::Cursor> pointer for the I<device> currently set on the
specified B<Gnome::Gdk3::Window>, or C<Any>.  If the return value is C<Any> then
there is no custom cursor set on the specified window, and it is
using the cursor for its parent window.

Returns: (nullable) (transfer none): a B<Gnome::Gdk3::Cursor>, or C<Any>. The
returned object is owned by the B<Gnome::Gdk3::Window> and should not be
unreferenced directly. Use C<gdk_window_set_cursor()> to unset the
cursor of the window


  method gdk_window_get_device_cursor ( N-GObject $device --> N-GObject  )

=item N-GObject $device; a master, pointer B<Gnome::Gdk3::Device>.

=end pod

sub gdk_window_get_device_cursor ( N-GObject $window, N-GObject $device )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_user_data:
=begin pod
=head2 [[gdk_] window_] get_user_data

Retrieves the user data for I<window>, which is normally the widget
that I<window> belongs to. See C<gdk_window_set_user_data()>.


  method gdk_window_get_user_data ( Pointer $data )

=item Pointer $data; (out): return location for user data

=end pod

sub gdk_window_get_user_data ( N-GObject $window, Pointer $data )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_geometry:
=begin pod
=head2 [[gdk_] window_] get_geometry

Any of the return location arguments to this function may be C<Any>,
if you aren’t interested in getting the value of that field.

The X and Y coordinates returned are relative to the parent window
of I<window>, which for toplevels usually means relative to the
window decorations (titlebar, etc.) rather than relative to the
root window (screen-size background window).

On the X11 platform, the geometry is obtained from the X server,
so reflects the latest position of I<window>; this may be out-of-sync
with the position of I<window> delivered in the most-recently-processed
B<Gnome::Gdk3::EventConfigure>. C<gdk_window_get_position()> in contrast gets the
position from the most recent configure event.

Note: If I<window> is not a toplevel, it is much better
to call C<gdk_window_get_position()>, C<gdk_window_get_width()> and
C<gdk_window_get_height()> instead, because it avoids the roundtrip to
the X server and because these functions support the full 32-bit
coordinate space, whereas C<gdk_window_get_geometry()> is restricted to
the 16-bit coordinates of X11.

  method gdk_window_get_geometry ( Int $x, Int $y, Int $width, Int $height )

=item Int $x; (out) (allow-none): return location for X coordinate of window (relative to its parent)
=item Int $y; (out) (allow-none): return location for Y coordinate of window (relative to its parent)
=item Int $width; (out) (allow-none): return location for width of window
=item Int $height; (out) (allow-none): return location for height of window

=end pod

sub gdk_window_get_geometry ( N-GObject $window, int32 $x, int32 $y, int32 $width, int32 $height )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_window_get_width:
=begin pod
=head2 [[gdk_] window_] get_width

Returns the width of the given I<window>.

On the X11 platform the returned size is the size reported in the
most-recently-processed configure event, rather than the current
size on the X server.

Returns: The width of I<window>


  method gdk_window_get_width ( --> int32  )


=end pod

sub gdk_window_get_width ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_window_get_height:
=begin pod
=head2 [[gdk_] window_] get_height

Returns the height of the given I<window>.

On the X11 platform the returned size is the size reported in the
most-recently-processed configure event, rather than the current
size on the X server.

Returns: The height of I<window>


  method gdk_window_get_height ( --> int32  )


=end pod

sub gdk_window_get_height ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_window_get_position:
=begin pod
=head2 [[gdk_] window_] get_position

Obtains the position of the window as reported in the
most-recently-processed B<Gnome::Gdk3::EventConfigure>. Contrast with
C<gdk_window_get_geometry()> which queries the X server for the
current window position, regardless of which events have been
received or processed.

The position coordinates are relative to the window’s parent window.


  method gdk_window_get_position ( --> List )

Returns a List with
=item Int $x; X coordinate of window
=item Int $y; Y coordinate of window

=end pod

sub gdk_window_get_position ( N-GObject $window --> List ) {
  _gdk_window_get_position( $window, my int32 $x, my int32 $y );
  ( $x, $y)
}

sub _gdk_window_get_position ( N-GObject $window, int32 $x is rw, int32 $y is rw )
  is native(&gdk-lib)
  is symbol('gdk_window_get_position')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_origin:
=begin pod
=head2 [[gdk_] window_] get_origin

Obtains the position of a window in root window coordinates.
(Compare with C<gdk_window_get_position()> and
C<gdk_window_get_geometry()> which return the position of a window
relative to its parent window.)

Returns: not meaningful, ignore

  method gdk_window_get_origin ( Int $x, Int $y --> Int  )

=item Int $x; (out) (allow-none): return location for X coordinate
=item Int $y; (out) (allow-none): return location for Y coordinate

=end pod

sub gdk_window_get_origin ( N-GObject $window, int32 $x, int32 $y )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_root_coords:
=begin pod
=head2 [[gdk_] window_] get_root_coords

Obtains the position of a window position in root
window coordinates. This is similar to
C<gdk_window_get_origin()> but allows you to pass
in any position in the window, not just the origin.


  method gdk_window_get_root_coords ( Int $x, Int $y, Int $root_x, Int $root_y )

=item Int $x; X coordinate in window
=item Int $y; Y coordinate in window
=item Int $root_x; (out): return location for X coordinate
=item Int $root_y; (out): return location for Y coordinate

=end pod

sub gdk_window_get_root_coords ( N-GObject $window, int32 $x, int32 $y, int32 $root_x, int32 $root_y )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_coords_to_parent:
=begin pod
=head2 [[gdk_] window_] coords_to_parent

Transforms window coordinates from a child window to its parent
window, where the parent window is the normal parent as returned by
C<gdk_window_get_parent()> for normal windows, and the window's
embedder as returned by C<gdk_offscreen_window_get_embedder()> for
offscreen windows.

For normal windows, calling this function is equivalent to adding
the return values of C<gdk_window_get_position()> to the child coordinates.
For offscreen windows however (which can be arbitrarily transformed),
this function calls the B<Gnome::Gdk3::Window>::to-embedder: signal to translate
the coordinates.

You should always use this function when writing generic code that
walks up a window hierarchy.

See also: C<gdk_window_coords_from_parent()>


  method gdk_window_coords_to_parent ( Num $x, Num $y, Num $parent_x, Num $parent_y )

=item Num $x; X coordinate in child’s coordinate system
=item Num $y; Y coordinate in child’s coordinate system
=item Num $parent_x; (out) (allow-none): return location for X coordinate in parent’s coordinate system, or C<Any>
=item Num $parent_y; (out) (allow-none): return location for Y coordinate in parent’s coordinate system, or C<Any>

=end pod

sub gdk_window_coords_to_parent ( N-GObject $window, num64 $x, num64 $y, num64 $parent_x, num64 $parent_y )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_coords_from_parent:
=begin pod
=head2 [[gdk_] window_] coords_from_parent

Transforms window coordinates from a parent window to a child
window, where the parent window is the normal parent as returned by
C<gdk_window_get_parent()> for normal windows, and the window's
embedder as returned by C<gdk_offscreen_window_get_embedder()> for
offscreen windows.

For normal windows, calling this function is equivalent to subtracting
the return values of C<gdk_window_get_position()> from the parent coordinates.
For offscreen windows however (which can be arbitrarily transformed),
this function calls the B<Gnome::Gdk3::Window>::from-embedder: signal to translate
the coordinates.

You should always use this function when writing generic code that
walks down a window hierarchy.

See also: C<gdk_window_coords_to_parent()>


  method gdk_window_coords_from_parent ( Num $parent_x, Num $parent_y, Num $x, Num $y )

=item Num $parent_x; X coordinate in parent’s coordinate system
=item Num $parent_y; Y coordinate in parent’s coordinate system
=item Num $x; (out) (allow-none): return location for X coordinate in child’s coordinate system
=item Num $y; (out) (allow-none): return location for Y coordinate in child’s coordinate system

=end pod

sub gdk_window_coords_from_parent ( N-GObject $window, num64 $parent_x, num64 $parent_y, num64 $x, num64 $y )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_root_origin:
=begin pod
=head2 [[gdk_] window_] get_root_origin

Obtains the top-left corner of the window manager frame in root
window coordinates.


  method gdk_window_get_root_origin ( Int $x, Int $y )

=item Int $x; (out): return location for X position of window frame
=item Int $y; (out): return location for Y position of window frame

=end pod

sub gdk_window_get_root_origin ( N-GObject $window, int32 $x, int32 $y )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_frame_extents:
=begin pod
=head2 [[gdk_] window_] get_frame_extents

Obtains the bounding box of the window, including window manager
titlebar/borders if any. The frame position is given in root window
coordinates. To get the position of the window itself (rather than
the frame) in root window coordinates, use C<gdk_window_get_origin()>.


  method gdk_window_get_frame_extents ( N-GObject $rect )

=item N-GObject $rect; (out): rectangle to fill with bounding box of the window frame

=end pod

sub gdk_window_get_frame_extents ( N-GObject $window, N-GObject $rect )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_scale_factor:
=begin pod
=head2 [[gdk_] window_] get_scale_factor

Returns the internal scale factor that maps from window coordiantes
to the actual device pixels. On traditional systems this is 1, but
on very high density outputs this can be a higher value (often 2).

A higher value means that drawing is automatically scaled up to
a higher resolution, so any code doing drawing will automatically look
nicer. However, if you are supplying pixel-based data the scale
value can be used to determine whether to use a pixel resource
with higher resolution data.

The scale of a window may change during runtime, if this happens
a configure event will be sent to the toplevel window.

Returns: the scale factor

  method gdk_window_get_scale_factor ( --> Int  )


=end pod

sub gdk_window_get_scale_factor ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_device_position:
=begin pod
=head2 [[gdk_] window_] get_device_position

Obtains the current device position and modifier state.
The position is given in coordinates relative to the upper left
corner of I<window>.

Use C<gdk_window_get_device_position_double()> if you need subpixel precision.

Returns: (nullable) (transfer none): The window underneath I<device>
(as with C<gdk_device_get_window_at_position()>), or C<Any> if the
window is not known to GDK.


  method gdk_window_get_device_position ( N-GObject $device, Int $x, Int $y, GdkModifierType $mask --> N-GObject  )

=item N-GObject $device; pointer B<Gnome::Gdk3::Device> to query to.
=item Int $x; (out) (allow-none): return location for the X coordinate of I<device>, or C<Any>.
=item Int $y; (out) (allow-none): return location for the Y coordinate of I<device>, or C<Any>.
=item GdkModifierType $mask; (out) (allow-none): return location for the modifier mask, or C<Any>.

=end pod

sub gdk_window_get_device_position ( N-GObject $window, N-GObject $device, int32 $x, int32 $y, int32 $mask )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_device_position_double:
=begin pod
=head2 [[gdk_] window_] get_device_position_double

Obtains the current device position in doubles and modifier state.
The position is given in coordinates relative to the upper left
corner of I<window>.

Returns: (nullable) (transfer none): The window underneath I<device>
(as with C<gdk_device_get_window_at_position()>), or C<Any> if the
window is not known to GDK.


  method gdk_window_get_device_position_double ( N-GObject $device, Num $x, Num $y, GdkModifierType $mask --> N-GObject  )

=item N-GObject $device; pointer B<Gnome::Gdk3::Device> to query to.
=item Num $x; (out) (allow-none): return location for the X coordinate of I<device>, or C<Any>.
=item Num $y; (out) (allow-none): return location for the Y coordinate of I<device>, or C<Any>.
=item GdkModifierType $mask; (out) (allow-none): return location for the modifier mask, or C<Any>.

=end pod

sub gdk_window_get_device_position_double ( N-GObject $window, N-GObject $device, num64 $x, num64 $y, int32 $mask )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_parent:
=begin pod
=head2 [[gdk_] window_] get_parent

Obtains the parent of I<window>, as known to GDK. Does not query the
X server; thus this returns the parent as passed to C<gdk_window_new()>,
not the actual parent. This should never matter unless you’re using
Xlib calls mixed with GDK calls on the X11 platform. It may also
matter for toplevel windows, because the window manager may choose
to reparent them.

Note that you should use C<gdk_window_get_effective_parent()> when
writing generic code that walks up a window hierarchy, because
C<gdk_window_get_parent()> will most likely not do what you expect if
there are offscreen windows in the hierarchy.

Returns: (transfer none): parent of I<window>

  method gdk_window_get_parent ( --> N-GObject  )


=end pod

sub gdk_window_get_parent ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_toplevel:
=begin pod
=head2 [[gdk_] window_] get_toplevel

Gets the toplevel window that’s an ancestor of I<window>.

Any window type but C<GDK_WINDOW_CHILD> is considered a
toplevel window, as is a C<GDK_WINDOW_CHILD> window that
has a root window as parent.

Note that you should use C<gdk_window_get_effective_toplevel()> when
you want to get to a window’s toplevel as seen on screen, because
C<gdk_window_get_toplevel()> will most likely not do what you expect
if there are offscreen windows in the hierarchy.

Returns: (transfer none): the toplevel window containing I<window>

  method gdk_window_get_toplevel ( --> N-GObject  )


=end pod

sub gdk_window_get_toplevel ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_effective_parent:
=begin pod
=head2 [[gdk_] window_] get_effective_parent

Obtains the parent of I<window>, as known to GDK. Works like
C<gdk_window_get_parent()> for normal windows, but returns the
window’s embedder for offscreen windows.

See also: C<gdk_offscreen_window_get_embedder()>

Returns: (transfer none): effective parent of I<window>


  method gdk_window_get_effective_parent ( --> N-GObject  )


=end pod

sub gdk_window_get_effective_parent ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_effective_toplevel:
=begin pod
=head2 [[gdk_] window_] get_effective_toplevel

Gets the toplevel window that’s an ancestor of I<window>.

Works like C<gdk_window_get_toplevel()>, but treats an offscreen window's
embedder as its parent, using C<gdk_window_get_effective_parent()>.

See also: C<gdk_offscreen_window_get_embedder()>

Returns: (transfer none): the effective toplevel window containing I<window>


  method gdk_window_get_effective_toplevel ( --> N-GObject  )


=end pod

sub gdk_window_get_effective_toplevel ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_children:
=begin pod
=head2 [[gdk_] window_] get_children

Gets the list of children of I<window> known to GDK.
This function only returns children created via GDK,
so for example it’s useless when used with the root window;
it only returns windows an application created itself.

The returned list must be freed, but the elements in the
list need not be.

Returns: (transfer container) (element-type B<Gnome::Gdk3::Window>):
list of child windows inside I<window>

  method gdk_window_get_children ( --> N-GList  )


=end pod

sub gdk_window_get_children ( N-GObject $window )
  returns N-GList
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_peek_children:
=begin pod
=head2 [[gdk_] window_] peek_children

Like C<gdk_window_get_children()>, but does not copy the list of
children, so the list does not need to be freed.

Returns: (transfer none) (element-type B<Gnome::Gdk3::Window>):
a reference to the list of child windows in I<window>

  method gdk_window_peek_children ( --> N-GList  )


=end pod

sub gdk_window_peek_children ( N-GObject $window )
  returns N-GList
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_children_with_user_data:
=begin pod
=head2 [[gdk_] window_] get_children_with_user_data

Gets the list of children of I<window> known to GDK with a
particular I<user_data> set on it.

The returned list must be freed, but the elements in the
list need not be.

The list is returned in (relative) stacking order, i.e. the
lowest window is first.

Returns: (transfer container) (element-type B<Gnome::Gdk3::Window>):
list of child windows inside I<window>


  method gdk_window_get_children_with_user_data ( Pointer $user_data --> N-GList  )

=item Pointer $user_data; user data to look for

=end pod

sub gdk_window_get_children_with_user_data ( N-GObject $window, Pointer $user_data )
  returns N-GList
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_events:
=begin pod
=head2 [[gdk_] window_] get_events

Gets the event mask for I<window> for all master input devices. See
C<gdk_window_set_events()>.

Returns: event mask for I<window>

  method gdk_window_get_events ( --> Int )

=end pod

sub gdk_window_get_events ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_events:
=begin pod
=head2 [[gdk_] window_] set_events

The event mask for a window determines which events will be reported for that window from all master input devices. For example, an event mask including B<GDK_BUTTON_PRESS_MASK> means the window should report button press events. The event mask is the bitwise OR of values from the B<Gnome::Gdk3::EventMask> enumeration.

See the [input handling overview][event-masks] for details.

  method gdk_window_set_events ( Int $event_mask )

=item Int $event_mask; event mask for I<window>. The values are from C<GdkEventMask>.

=end pod

sub gdk_window_set_events ( N-GObject $window, int32 $event_mask )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_device_events:
=begin pod
=head2 [[gdk_] window_] set_device_events

Sets the event mask for a given device (Normally a floating device, not
attached to any visible pointer) to I<window>. For example, an event mask
including B<GDK_BUTTON_PRESS_MASK> means the window should report button
press events. The event mask is the bitwise OR of values from the
B<Gnome::Gdk3::EventMask> enumeration.

See the [input handling overview][event-masks] for details.


  method gdk_window_set_device_events ( N-GObject $device, Int $event_mask )

=item N-GObject $device; B<Gnome::Gdk3::Device> to enable events for.
=item Int $event_mask; event mask for I<window>. Values are from GdkEventMask.

=end pod

sub gdk_window_set_device_events ( N-GObject $window, N-GObject $device, int32 $event_mask )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_device_events:
=begin pod
=head2 [[gdk_] window_] get_device_events

Returns the event mask for I<window> corresponding to an specific device.

Returns: device event mask for I<window> with mask values from GdkEventMask.

  method gdk_window_get_device_events ( N-GObject $device --> Int )

=item N-GObject $device; a B<Gnome::Gdk3::Device>.

=end pod

sub gdk_window_get_device_events ( N-GObject $window, N-GObject $device )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_source_events:
=begin pod
=head2 [[gdk_] window_] set_source_events

Sets the event mask for any floating device (i.e. not attached to any
visible pointer) that has the source defined as I<source>. This event
mask will be applied both to currently existing, newly added devices
after this call, and devices being attached/detached.


  method gdk_window_set_source_events ( GdkInputSource $source, Int $event_mask )

=item GdkInputSource $source; a B<Gnome::Gdk3::InputSource> to define the source class.
=item Int $event_mask; event mask for I<window>. Mask bit values are from GdkEventMask.

=end pod

sub gdk_window_set_source_events ( N-GObject $window, int32 $source, int32 $event_mask )
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_source_events:
=begin pod
=head2 [[gdk_] window_] get_source_events

Returns the event mask for I<window> corresponding to the device class specified
by I<source>.

Returns: source event mask for I<window>

  method gdk_window_get_source_events ( GdkInputSource $source --> Int )

=item GdkInputSource $source; a B<Gnome::Gdk3::InputSource> to define the source class.

=end pod

sub gdk_window_get_source_events ( N-GObject $window, int32 $source )
  returns int32
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_icon_list:
=begin pod
=head2 [[gdk_] window_] set_icon_list

Sets a list of icons for the window. One of these will be used
to represent the window when it has been iconified. The icon is
usually shown in an icon box or some sort of task bar. Which icon
size is shown depends on the window manager. The window manager
can scale the icon  but setting several size icons can give better
image quality since the window manager may only need to scale the
icon by a small amount or not at all.

Note that some platforms don't support window icons.

  method gdk_window_set_icon_list ( N-GList $pixbufs )

=item N-GList $pixbufs; (transfer none) (element-type B<Gnome::Gdk3::Pixbuf>): A list of pixbufs, of different sizes.

=end pod

sub gdk_window_set_icon_list ( N-GObject $window, N-GList $pixbufs )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_icon_name:
=begin pod
=head2 [[gdk_] window_] set_icon_name

Windows may have a name used while minimized, distinct from the
name they display in their titlebar. Most of the time this is a bad
idea from a user interface standpoint. But you can set such a name
with this function, if you like.

After calling this with a non-C<Any> I<name>, calls to C<gdk_window_set_title()>
will not update the icon title.

Using C<Any> for I<name> unsets the icon title; further calls to
C<gdk_window_set_title()> will again update the icon title as well.

Note that some platforms don't support window icons.

  method gdk_window_set_icon_name ( Str $name )

=item Str $name; (allow-none): name of window while iconified (minimized)

=end pod

sub gdk_window_set_icon_name ( N-GObject $window, Str $name )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_group:
=begin pod
=head2 [[gdk_] window_] set_group

Sets the group leader window for I<window>. By default,
GDK sets the group leader for all toplevel windows
to a global window implicitly created by GDK. With this function
you can override this default.

The group leader window allows the window manager to distinguish
all windows that belong to a single application. It may for example
allow users to minimize/unminimize all windows belonging to an
application at once. You should only set a non-default group window
if your application pretends to be multiple applications.

  method gdk_window_set_group ( N-GObject $leader )

=item N-GObject $leader; (allow-none): group leader window, or C<Any> to restore the default group leader window

=end pod

sub gdk_window_set_group ( N-GObject $window, N-GObject $leader )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_group:
=begin pod
=head2 [[gdk_] window_] get_group

Returns the group leader window for I<window>. See C<gdk_window_set_group()>.

Returns: (transfer none): the group leader window for I<window>


  method gdk_window_get_group ( --> N-GObject  )


=end pod

sub gdk_window_get_group ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_decorations:
=begin pod
=head2 [[gdk_] window_] set_decorations

“Decorations” are the features the window manager adds to a toplevel B<Gnome::Gdk3::Window>.
This function sets the traditional Motif window manager hints that tell the
window manager which decorations you would like your window to have.
Usually you should use C<gtk_window_set_decorated()> on a B<Gnome::Gtk3::Window> instead of
using the GDK function directly.

The I<decorations> argument is the logical OR of the fields in
the B<Gnome::Gdk3::WMDecoration> enumeration. If B<GDK_DECOR_ALL> is included in the
mask, the other bits indicate which decorations should be turned off.
If B<GDK_DECOR_ALL> is not included, then the other bits indicate
which decorations should be turned on.

Most window managers honor a decorations hint of 0 to disable all decorations,
but very few honor all possible combinations of bits.


  method gdk_window_set_decorations ( GdkWMDecoration $decorations )

=item GdkWMDecoration $decorations; decoration hint mask

=end pod

sub gdk_window_set_decorations ( N-GObject $window, int32 $decorations )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_decorations:
=begin pod
=head2 [[gdk_] window_] get_decorations

Returns the decorations set on the B<Gnome::Gdk3::Window> with
C<gdk_window_set_decorations()>.

Returns: C<1> if the window has decorations set, C<0> otherwise.

  method gdk_window_get_decorations ( GdkWMDecoration $decorations --> Int  )

=item GdkWMDecoration $decorations; (out): The window decorations will be written here

=end pod

sub gdk_window_get_decorations ( N-GObject $window, int32 $decorations )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_functions:
=begin pod
=head2 [[gdk_] window_] set_functions

Sets hints about the window management functions to make available
via buttons on the window frame.

On the X backend, this function sets the traditional Motif window
manager hint for this purpose. However, few window managers do
anything reliable or interesting with this hint. Many ignore it
entirely.

The I<functions> argument is the logical OR of values from the
B<WMFunction> enumeration. If the bitmask includes B<GDK_FUNC_ALL>,
then the other bits indicate which functions to disable; if
it doesn’t include B<GDK_FUNC_ALL>, it indicates which functions to
enable.


  method gdk_window_set_functions ( GdkWMFunction $functions )

=item GdkWMFunction $functions; bitmask of operations to allow on I<window>

=end pod

sub gdk_window_set_functions ( N-GObject $window, int32 $functions )
  is native(&gdk-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:1:gdk_window_create_similar_surface:
=begin pod
=head2 [[gdk_] window_] create_similar_surface

Create a new surface that is as compatible as possible with the given I<window>. For example the new surface will have the same fallback resolution and font options as I<window>. Generally, the new surface will also use the same backend as I<window>, unless that is not possible for some reason. The type of the returned surface may be examined with C<cairo_surface_get_type()>.

Initially the surface contents are all 0 (transparent if contents have transparency, black otherwise.)

=head3 Example

The next example shows how to get a surface from a B<Gnome::Gtk3::DrawingArea>. This code can be run as an initialization step when called from a I<realize> signal registered on the drawing area widget. This surface can then be saved in an attribute. Later, when a I<draw> signal is fired. the surface can be stored in the provided cairo context using C<.set-source-surface()> and used to paint the drawing.

  class X {
    has Gnome::Cairo::Surface $!surface;

    # called by signal 'realize'
    method make-drawing (
      Gnome::Gtk3::DrawingArea :widget($drawing-area)
      --> Int
    ) {

      my Int $width = $drawing-area.get-allocated-width;
      my Int $height = $drawing-area.get-allocated-height;

      my Gnome::Gdk3::Window $window .= new(
        :native-object($drawing-area.get-window)
      );

      $!surface .= new(
        :native-object(
          $window.create-similar-image-surface(
            CAIRO_CONTENT_COLOR, $width, $height
          )
        )
      );


      given Gnome::Cairo.new(:$!surface) {
        .set-source-rgb( 0.1, 0.1, 0.1);

        # select your own font if 'Z003' is not available
        .select-font-face(
          "Z003", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD
        );

        .set-font-size(18);

        # A bit of Natasha Beddingfield (your widget should be large enough!)
        for
           20, 30, "Most relationships seem so transitory",
           20, 60, "They're all good but not the permanent one",
           20, 120, "Who doesn't long for someone to hold",
           20, 150, "Who knows how to love you without being told",
           20, 180, "Somebody tell me why I'm on my own",
           20, 210, "If there's a soulmate for everyone"
           -> $x, $y, $text {

          .move-to( $x, $y);
          .show-text($text);
        }

        .clear-object;
      }

      1;
    }

    # Called by the draw signal after changing the window.
    method redraw ( cairo_t $n-cx, --> Int ) {

      # we have received a cairo context in which our surface must be set.
      my Gnome::Cairo $cairo-context .= new(:native-object($n-cx));
      $cairo-context.set-source-surface( $!surface, 0, 0);

      # just repaint the whole scenery
      $cairo-context.paint;

      1
    }
  }

Returns: a pointer to the newly allocated surface. The caller owns the surface and should call C<cairo_surface_destroy()> when done with it.

This function always returns a valid pointer, but it will return a pointer to a “nil” surface if the surface of this Window is already in an error state or any other error occurs.

  method gdk_window_create_similar_surface (
    cairo_content_t $content, int32 $width, int32 $height
    --> cairo_surface_t
  )

=item cairo_content_t $content; an enum describing the content for the new surface
=item int32 $width; width of the new surface
=item int32 $height; height of the new surface

=end pod

sub gdk_window_create_similar_surface (
  N-GObject $window, int32 $content, int32 $width, int32 $height
  --> cairo_surface_t
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gdk_window_create_similar_image_surface:
=begin pod
=head2 [[gdk_] window_] create_similar_image_surface

Create a new image surface that is efficient to draw on the given I<window>.

Initially the surface contents are all 0 (transparent if contents have transparency, black otherwise.)

The I<width> and I<height> of the new surface are not affected by the scaling factor of the I<window>, or by the I<scale> argument; they are the size of the surface in device pixels. If you wish to create an image surface capable of holding the contents of I<window> you can use:

=head3 Example

  my Gnome::Gtk3::DrawingArea $drawing-area;
  my Int $width = $drawing-area.get-allocated-width;
  my Int $height = $drawing-area.get-allocated-height;
  ny Int $scale = $drawing-area.get_scale_factor;

  my Gnome::Gdk3::Window $window .= new(:native-object(
    $drawing-area.get-window)
  );

  my Gnome::Cairo::Surface $surface .= new(
    :native-object(
      $window.create-similar-image-surface(
        CAIRO_FORMAT_ARGB32, $width, $height, $scale
      )
    )
  );

Returns: a pointer to the newly allocated surface. The caller owns the surface and should call C<cairo_surface_destroy()> when done with it.

This function always returns a valid pointer, but it will return a pointer to a “nil” surface if I<other> is already in an error state or any other error occurs.


  method gdk_window_create_similar_image_surface (
    cairo_format_t $format, int32 $width, int32 $height, int32 $scale
    --> cairo_surface_t
  )

=item cairo_format_t $format; the format for the new surface
=item int32 $width; width of the new surface
=item int32 $height; height of the new surface
=item int32 $scale; the scale of the new surface, or 0 to use same as I<window>

=end pod

sub gdk_window_create_similar_image_surface (
  N-GObject $window, int32 $format,
  int32 $width, int32 $height, int32 $scale
  --> cairo_surface_t
) is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_beep:
=begin pod
=head2 gdk_window_beep

Emits a short beep associated to I<window> in the appropriate
display, if supported. Otherwise, emits a short beep on
the display just as C<gdk_display_beep()>.


  method gdk_window_beep ( )


=end pod

sub gdk_window_beep ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_iconify:
=begin pod
=head2 gdk_window_iconify

Asks to iconify (minimize) I<window>. The window manager may choose
to ignore the request, but normally will honor it. Using
C<gtk_window_iconify()> is preferred, if you have a B<Gnome::Gtk3::Window> widget.

This function only makes sense when I<window> is a toplevel window.


  method gdk_window_iconify ( )


=end pod

sub gdk_window_iconify ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_deiconify:
=begin pod
=head2 gdk_window_deiconify

Attempt to deiconify (unminimize) I<window>. On X11 the window manager may
choose to ignore the request to deiconify. When using GTK+,
use C<gtk_window_deiconify()> instead of the B<Gnome::Gdk3::Window> variant. Or better yet,
you probably want to use C<gtk_window_present()>, which raises the window, focuses it,
unminimizes it, and puts it on the current desktop.


  method gdk_window_deiconify ( )


=end pod

sub gdk_window_deiconify ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_stick:
=begin pod
=head2 gdk_window_stick

“Pins” a window such that it’s on all workspaces and does not scroll
with viewports, for window managers that have scrollable viewports.
(When using B<Gnome::Gtk3::Window>, C<gtk_window_stick()> may be more useful.)

On the X11 platform, this function depends on window manager
support, so may have no effect with many window managers. However,
GDK will do the best it can to convince the window manager to stick
the window. For window managers that don’t support this operation,
there’s nothing you can do to force it to happen.


  method gdk_window_stick ( )


=end pod

sub gdk_window_stick ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_unstick:
=begin pod
=head2 gdk_window_unstick

Reverse operation for C<gdk_window_stick()>; see C<gdk_window_stick()>,
and C<gtk_window_unstick()>.


  method gdk_window_unstick ( )


=end pod

sub gdk_window_unstick ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_maximize:
=begin pod
=head2 gdk_window_maximize

Maximizes the window. If the window was already maximized, then
this function does nothing.

On X11, asks the window manager to maximize I<window>, if the window
manager supports this operation. Not all window managers support
this, and some deliberately ignore it or don’t have a concept of
“maximized”; so you can’t rely on the maximization actually
happening. But it will happen with most standard window managers,
and GDK makes a best effort to get it to happen.

On Windows, reliably maximizes the window.


  method gdk_window_maximize ( )


=end pod

sub gdk_window_maximize ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_unmaximize:
=begin pod
=head2 gdk_window_unmaximize

Unmaximizes the window. If the window wasn’t maximized, then this
function does nothing.

On X11, asks the window manager to unmaximize I<window>, if the
window manager supports this operation. Not all window managers
support this, and some deliberately ignore it or don’t have a
concept of “maximized”; so you can’t rely on the unmaximization
actually happening. But it will happen with most standard window
managers, and GDK makes a best effort to get it to happen.

On Windows, reliably unmaximizes the window.


  method gdk_window_unmaximize ( )


=end pod

sub gdk_window_unmaximize ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_fullscreen:
=begin pod
=head2 gdk_window_fullscreen

Moves the window into fullscreen mode. This means the
window covers the entire screen and is above any panels
or task bars.

If the window was already fullscreen, then this function does nothing.

On X11, asks the window manager to put I<window> in a fullscreen
state, if the window manager supports this operation. Not all
window managers support this, and some deliberately ignore it or
don’t have a concept of “fullscreen”; so you can’t rely on the
fullscreenification actually happening. But it will happen with
most standard window managers, and GDK makes a best effort to get
it to happen.


  method gdk_window_fullscreen ( )


=end pod

sub gdk_window_fullscreen ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_fullscreen_on_monitor:
=begin pod
=head2 [[gdk_] window_] fullscreen_on_monitor

Moves the window into fullscreen mode on the given monitor. This means
the window covers the entire screen and is above any panels or task bars.

If the window was already fullscreen, then this function does nothing.
Since: UNRELEASED

  method gdk_window_fullscreen_on_monitor ( Int $monitor )

=item Int $monitor; Which monitor to display fullscreen on.

=end pod

sub gdk_window_fullscreen_on_monitor ( N-GObject $window, int32 $monitor )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_fullscreen_mode:
=begin pod
=head2 [[gdk_] window_] set_fullscreen_mode

Specifies whether the I<window> should span over all monitors (in a multi-head
setup) or only the current monitor when in fullscreen mode.

The I<mode> argument is from the B<Gnome::Gdk3::FullscreenMode> enumeration.
If B<GDK_FULLSCREEN_ON_ALL_MONITORS> is specified, the fullscreen I<window> will
span over all monitors from the B<Gnome::Gdk3::Screen>.

On X11, searches through the list of monitors from the B<Gnome::Gdk3::Screen> the ones
which delimit the 4 edges of the entire B<Gnome::Gdk3::Screen> and will ask the window
manager to span the I<window> over these monitors.

If the XINERAMA extension is not available or not usable, this function
has no effect.

Not all window managers support this, so you can’t rely on the fullscreen
window to span over the multiple monitors when B<GDK_FULLSCREEN_ON_ALL_MONITORS>
is specified.


  method gdk_window_set_fullscreen_mode ( GdkFullscreenMode $mode )

=item GdkFullscreenMode $mode; fullscreen mode

=end pod

sub gdk_window_set_fullscreen_mode ( N-GObject $window, int32 $mode )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_fullscreen_mode:
=begin pod
=head2 [[gdk_] window_] get_fullscreen_mode

Obtains the B<Gnome::Gdk3::FullscreenMode> of the I<window>.

Returns: The B<Gnome::Gdk3::FullscreenMode> applied to the window when fullscreen.


  method gdk_window_get_fullscreen_mode ( --> GdkFullscreenMode  )


=end pod

sub gdk_window_get_fullscreen_mode ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_unfullscreen:
=begin pod
=head2 gdk_window_unfullscreen

Moves the window out of fullscreen mode. If the window was not
fullscreen, does nothing.

On X11, asks the window manager to move I<window> out of the fullscreen
state, if the window manager supports this operation. Not all
window managers support this, and some deliberately ignore it or
don’t have a concept of “fullscreen”; so you can’t rely on the
unfullscreenification actually happening. But it will happen with
most standard window managers, and GDK makes a best effort to get
it to happen.


  method gdk_window_unfullscreen ( )


=end pod

sub gdk_window_unfullscreen ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_keep_above:
=begin pod
=head2 [[gdk_] window_] set_keep_above

Set if I<window> must be kept above other windows. If the
window was already above, then this function does nothing.

On X11, asks the window manager to keep I<window> above, if the window
manager supports this operation. Not all window managers support
this, and some deliberately ignore it or don’t have a concept of
“keep above”; so you can’t rely on the window being kept above.
But it will happen with most standard window managers,
and GDK makes a best effort to get it to happen.


  method gdk_window_set_keep_above ( Int $setting )

=item Int $setting; whether to keep I<window> above other windows

=end pod

sub gdk_window_set_keep_above ( N-GObject $window, int32 $setting )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_keep_below:
=begin pod
=head2 [[gdk_] window_] set_keep_below

Set if I<window> must be kept below other windows. If the
window was already below, then this function does nothing.

On X11, asks the window manager to keep I<window> below, if the window
manager supports this operation. Not all window managers support
this, and some deliberately ignore it or don’t have a concept of
“keep below”; so you can’t rely on the window being kept below.
But it will happen with most standard window managers,
and GDK makes a best effort to get it to happen.


  method gdk_window_set_keep_below ( Int $setting )

=item Int $setting; whether to keep I<window> below other windows

=end pod

sub gdk_window_set_keep_below ( N-GObject $window, int32 $setting )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_opacity:
=begin pod
=head2 [[gdk_] window_] set_opacity

Set I<window> to render as partially transparent,
with opacity 0 being fully transparent and 1 fully opaque. (Values
of the opacity parameter are clamped to the [0,1] range.)

For toplevel windows this depends on support from the windowing system
that may not always be there. For instance, On X11, this works only on
X screens with a compositing manager running. On Wayland, there is no
per-window opacity value that the compositor would apply. Instead, use
`gdk_window_set_opaque_region (window, NULL)` to tell the compositor
that the entire window is (potentially) non-opaque, and draw your content
with alpha, or use C<gtk_widget_set_opacity()> to set an overall opacity
for your widgets.

For child windows this function only works for non-native windows.

For setting up per-pixel alpha topelevels, see C<gdk_screen_get_rgba_visual()>,
and for non-toplevels, see C<gdk_window_set_composited()>.

Support for non-toplevel windows was added in 3.8.


  method gdk_window_set_opacity ( Num $opacity )

=item Num $opacity; opacity

=end pod

sub gdk_window_set_opacity ( N-GObject $window, num64 $opacity )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_register_dnd:
=begin pod
=head2 [[gdk_] window_] register_dnd

Registers a window as a potential drop destination.

  method gdk_window_register_dnd ( )


=end pod

sub gdk_window_register_dnd ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_drag_protocol:
=begin pod
=head2 [[gdk_] window_] get_drag_protocol

Finds out the DND protocol supported by a window.

Returns: the supported DND protocol.


  method gdk_window_get_drag_protocol ( N-GObject $target --> GdkDragProtocol  )

=item N-GObject $target; (out) (allow-none) (transfer full): location of the window where the drop should happen. This may be I<window> or a proxy window, or C<Any> if I<window> does not support Drag and Drop.

=end pod

sub gdk_window_get_drag_protocol ( N-GObject $window, N-GObject $target )
  returns GdkDragProtocol
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_window_begin_resize_drag:
=begin pod
=head2 [[gdk_] window_] begin_resize_drag

Begins a window resize operation (for a toplevel window).

This function assumes that the drag is controlled by the
client pointer device, use C<gdk_window_begin_resize_drag_for_device()>
to begin a drag with a different device.

  method gdk_window_begin_resize_drag ( GdkWindowEdge $edge, Int $button, Int $root_x, Int $root_y, UInt $timestamp )

=item GdkWindowEdge $edge; the edge or corner from which the drag is started
=item Int $button; the button being used to drag, or 0 for a keyboard-initiated drag
=item Int $root_x; root window X coordinate of mouse click that began the drag
=item Int $root_y; root window Y coordinate of mouse click that began the drag
=item UInt $timestamp; timestamp of mouse click that began the drag (use C<gdk_event_get_time()>)

=end pod

sub gdk_window_begin_resize_drag ( N-GObject $window, int32 $edge, int32 $button, int32 $root_x, int32 $root_y, uint32 $timestamp )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_begin_resize_drag_for_device:
=begin pod
=head2 [[gdk_] window_] begin_resize_drag_for_device

Begins a window resize operation (for a toplevel window).
You might use this function to implement a “window resize grip,” for
example; in fact B<Gnome::Gtk3::Statusbar> uses it. The function works best
with window managers that support the
[Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec)
but has a fallback implementation for other window managers.


  method gdk_window_begin_resize_drag_for_device ( GdkWindowEdge $edge, N-GObject $device, Int $button, Int $root_x, Int $root_y, UInt $timestamp )

=item GdkWindowEdge $edge; the edge or corner from which the drag is started
=item N-GObject $device; the device used for the operation
=item Int $button; the button being used to drag, or 0 for a keyboard-initiated drag
=item Int $root_x; root window X coordinate of mouse click that began the drag
=item Int $root_y; root window Y coordinate of mouse click that began the drag
=item UInt $timestamp; timestamp of mouse click that began the drag (use C<gdk_event_get_time()>)

=end pod

sub gdk_window_begin_resize_drag_for_device ( N-GObject $window, int32 $edge, N-GObject $device, int32 $button, int32 $root_x, int32 $root_y, uint32 $timestamp )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_begin_move_drag:
=begin pod
=head2 [[gdk_] window_] begin_move_drag

Begins a window move operation (for a toplevel window).

This function assumes that the drag is controlled by the
client pointer device, use C<gdk_window_begin_move_drag_for_device()>
to begin a drag with a different device.

  method gdk_window_begin_move_drag ( Int $button, Int $root_x, Int $root_y, UInt $timestamp )

=item Int $button; the button being used to drag, or 0 for a keyboard-initiated drag
=item Int $root_x; root window X coordinate of mouse click that began the drag
=item Int $root_y; root window Y coordinate of mouse click that began the drag
=item UInt $timestamp; timestamp of mouse click that began the drag

=end pod

sub gdk_window_begin_move_drag ( N-GObject $window, int32 $button, int32 $root_x, int32 $root_y, uint32 $timestamp )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_begin_move_drag_for_device:
=begin pod
=head2 [[gdk_] window_] begin_move_drag_for_device

Begins a window move operation (for a toplevel window).
You might use this function to implement a “window move grip,” for
example. The function works best with window managers that support the
[Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec)
but has a fallback implementation for other window managers.


  method gdk_window_begin_move_drag_for_device ( N-GObject $device, Int $button, Int $root_x, Int $root_y, UInt $timestamp )

=item N-GObject $device; the device used for the operation
=item Int $button; the button being used to drag, or 0 for a keyboard-initiated drag
=item Int $root_x; root window X coordinate of mouse click that began the drag
=item Int $root_y; root window Y coordinate of mouse click that began the drag
=item UInt $timestamp; timestamp of mouse click that began the drag

=end pod

sub gdk_window_begin_move_drag_for_device ( N-GObject $window, N-GObject $device, int32 $button, int32 $root_x, int32 $root_y, uint32 $timestamp )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_invalidate_rect:
=begin pod
=head2 [[gdk_] window_] invalidate_rect

A convenience wrapper around C<gdk_window_invalidate_region()> which
invalidates a rectangular region. See
C<gdk_window_invalidate_region()> for details.

  method gdk_window_invalidate_rect ( N-GObject $rect, Int $invalidate_children )

=item N-GObject $rect; (allow-none): rectangle to invalidate or C<Any> to invalidate the whole window
=item Int $invalidate_children; whether to also invalidate child windows

=end pod

sub gdk_window_invalidate_rect ( N-GObject $window, N-GObject $rect, int32 $invalidate_children )
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_window_invalidate_region:
=begin pod
=head2 [[gdk_] window_] invalidate_region

Adds I<region> to the update area for I<window>. The update area is the
region that needs to be redrawn, or “dirty region.” The call
C<gdk_window_process_updates()> sends one or more expose events to the
window, which together cover the entire update area. An
application would normally redraw the contents of I<window> in
response to those expose events.

GDK will call C<gdk_window_process_all_updates()> on your behalf
whenever your program returns to the main loop and becomes idle, so
normally there’s no need to do that manually, you just need to
invalidate regions that you know should be redrawn.

The I<invalidate_children> parameter controls whether the region of
each child window that intersects I<region> will also be invalidated.
If C<0>, then the update area for child windows will remain
unaffected. See gdk_window_invalidate_maybe_recurse if you need
fine grained control over which children are invalidated.

  method gdk_window_invalidate_region ( cairo_region_t $region, Int $invalidate_children )

=item cairo_region_t $region; a B<cairo_region_t>
=item Int $invalidate_children; C<1> to also invalidate child windows

=end pod

sub gdk_window_invalidate_region ( N-GObject $window, cairo_region_t $region, int32 $invalidate_children )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_invalidate_maybe_recurse:
=begin pod
=head2 [[gdk_] window_] invalidate_maybe_recurse

Adds I<region> to the update area for I<window>. The update area is the
region that needs to be redrawn, or “dirty region.” The call
C<gdk_window_process_updates()> sends one or more expose events to the
window, which together cover the entire update area. An
application would normally redraw the contents of I<window> in
response to those expose events.

GDK will call C<gdk_window_process_all_updates()> on your behalf
whenever your program returns to the main loop and becomes idle, so
normally there’s no need to do that manually, you just need to
invalidate regions that you know should be redrawn.

The I<child_func> parameter controls whether the region of
each child window that intersects I<region> will also be invalidated.
Only children for which I<child_func> returns B<TRUE> will have the area
invalidated.

  method gdk_window_invalidate_maybe_recurse ( cairo_region_t $region, GdkWindowChildFunc $child_func, Pointer $user_data )

=item cairo_region_t $region; a B<cairo_region_t>
=item GdkWindowChildFunc $child_func; (scope call) (allow-none): function to use to decide if to recurse to a child, C<Any> means never recurse.
=item Pointer $user_data; data passed to I<child_func>

=end pod

sub gdk_window_invalidate_maybe_recurse ( N-GObject $window, cairo_region_t $region, GdkWindowChildFunc $child_func, Pointer $user_data )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_update_area:
=begin pod
=head2 [[gdk_] window_] get_update_area

Transfers ownership of the update area from I<window> to the caller
of the function. That is, after calling this function, I<window> will
no longer have an invalid/dirty region; the update area is removed
from I<window> and handed to you. If a window has no update area,
C<gdk_window_get_update_area()> returns C<Any>. You are responsible for
calling C<cairo_region_destroy()> on the returned region if it’s non-C<Any>.

Returns: the update area for I<window>

  method gdk_window_get_update_area ( --> cairo_region_t  )


=end pod

sub gdk_window_get_update_area ( N-GObject $window )
  returns cairo_region_t
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_window_freeze_updates:
=begin pod
=head2 [[gdk_] window_] freeze_updates

Temporarily freezes a window such that it won’t receive expose
events.  The window will begin receiving expose events again when
C<gdk_window_thaw_updates()> is called. If C<gdk_window_freeze_updates()>
has been called more than once, C<gdk_window_thaw_updates()> must be called
an equal number of times to begin processing exposes.

  method gdk_window_freeze_updates ( )


=end pod

sub gdk_window_freeze_updates ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_thaw_updates:
=begin pod
=head2 [[gdk_] window_] thaw_updates

Thaws a window frozen with C<gdk_window_freeze_updates()>.

  method gdk_window_thaw_updates ( )


=end pod

sub gdk_window_thaw_updates ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_constrain_size:
=begin pod
=head2 [[gdk_] window_] constrain_size

Constrains a desired width and height according to a
set of geometry hints (such as minimum and maximum size).

  method gdk_window_constrain_size ( GdkGeometry $geometry, GdkWindowHints $flags, Int $width, Int $height, Int $new_width, Int $new_height )

=item GdkGeometry $geometry; a B<Gnome::Gdk3::Geometry> structure
=item GdkWindowHints $flags; a mask indicating what portions of I<geometry> are set
=item Int $width; desired width of window
=item Int $height; desired height of the window
=item Int $new_width; (out): location to store resulting width
=item Int $new_height; (out): location to store resulting height

=end pod

sub gdk_window_constrain_size ( GdkGeometry $geometry, int32 $flags, int32 $width, int32 $height, int32 $new_width, int32 $new_height )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_get_default_root_window:
=begin pod
=head2 gdk_get_default_root_window

Obtains the root window (parent all other windows are inside)
for the default display and screen.

Returns: (transfer none): the default root window

  method gdk_get_default_root_window ( --> N-GObject  )


=end pod

sub gdk_get_default_root_window (  )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_offscreen_window_get_surface:
=begin pod
=head2 gdk_offscreen_window_get_surface



  method gdk_offscreen_window_get_surface ( --> cairo_surface_t  )


=end pod

sub gdk_offscreen_window_get_surface ( N-GObject $window )
  returns cairo_surface_t
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_offscreen_window_set_embedder:
=begin pod
=head2 gdk_offscreen_window_set_embedder



  method gdk_offscreen_window_set_embedder ( N-GObject $embedder )

=item N-GObject $embedder;

=end pod

sub gdk_offscreen_window_set_embedder ( N-GObject $window, N-GObject $embedder )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_offscreen_window_get_embedder:
=begin pod
=head2 gdk_offscreen_window_get_embedder



  method gdk_offscreen_window_get_embedder ( --> N-GObject  )


=end pod

sub gdk_offscreen_window_get_embedder ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_geometry_changed:
=begin pod
=head2 [[gdk_] window_] geometry_changed

This function informs GDK that the geometry of an embedded
offscreen window has changed. This is necessary for GDK to keep
track of which offscreen window the pointer is in.


  method gdk_window_geometry_changed ( )


=end pod

sub gdk_window_geometry_changed ( N-GObject $window )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_support_multidevice:
=begin pod
=head2 [[gdk_] window_] set_support_multidevice

This function will enable multidevice features in I<window>.

Multidevice aware windows will need to handle properly multiple,
per device enter/leave events, device grabs and grab ownerships.


  method gdk_window_set_support_multidevice ( Int $support_multidevice )

=item Int $support_multidevice; C<1> to enable multidevice support in I<window>.

=end pod

sub gdk_window_set_support_multidevice ( N-GObject $window, int32 $support_multidevice )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_support_multidevice:
=begin pod
=head2 [[gdk_] window_] get_support_multidevice

Returns C<1> if the window is aware of the existence of multiple
devices.

Returns: C<1> if the window handles multidevice features.


  method gdk_window_get_support_multidevice ( --> Int  )


=end pod

sub gdk_window_get_support_multidevice ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_frame_clock:
=begin pod
=head2 [[gdk_] window_] get_frame_clock

Gets the frame clock for the window. The frame clock for a window
never changes unless the window is reparented to a new toplevel
window.

Returns: (transfer none): the frame clock

  method gdk_window_get_frame_clock ( --> N-GObject  )


=end pod

sub gdk_window_get_frame_clock ( N-GObject $window )
  returns N-GObject
  is native(&gdk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_opaque_region:
=begin pod
=head2 [[gdk_] window_] set_opaque_region

For optimisation purposes, compositing window managers may
like to not draw obscured regions of windows, or turn off blending
during for these regions. With RGB windows with no transparency,
this is just the shape of the window, but with ARGB32 windows, the
compositor does not know what regions of the window are transparent
or not.

This function only works for toplevel windows.

GTK+ will update this property automatically if
the I<window> background is opaque, as we know where the opaque regions
are. If your window background is not opaque, please update this
property in your  I<style-updated> handler.


  method gdk_window_set_opaque_region ( cairo_region_t $region )

=item cairo_region_t $region; (allow-none):  a region, or C<Any>

=end pod

sub gdk_window_set_opaque_region ( N-GObject $window, cairo_region_t $region )
  is native(&gdk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_event_compression:
=begin pod
=head2 [[gdk_] window_] set_event_compression

Determines whether or not extra unprocessed motion events in
the event queue can be discarded. If C<1> only the most recent
event will be delivered.

Some types of applications, e.g. paint programs, need to see all
motion events and will benefit from turning off event compression.

By default, event compression is enabled.


  method gdk_window_set_event_compression ( Int $event_compression )

=item Int $event_compression; C<1> if motion events should be compressed

=end pod

sub gdk_window_set_event_compression ( N-GObject $window, int32 $event_compression )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_get_event_compression:
=begin pod
=head2 [[gdk_] window_] get_event_compression

Get the current event compression setting for this window.

Returns: C<1> if motion events will be compressed


  method gdk_window_get_event_compression ( --> Int  )


=end pod

sub gdk_window_get_event_compression ( N-GObject $window )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_set_shadow_width:
=begin pod
=head2 [[gdk_] window_] set_shadow_width

Newer GTK+ windows using client-side decorations use extra geometry
around their frames for effects like shadows and invisible borders.
Window managers that want to maximize windows or snap to edges need
to know where the extents of the actual frame lie, so that users
don’t feel like windows are snapping against random invisible edges.

Note that this property is automatically updated by GTK+, so this
function should only be used by applications which do not use GTK+
to create toplevel windows.


  method gdk_window_set_shadow_width ( Int $left, Int $right, Int $top, Int $bottom )

=item Int $left; The left extent
=item Int $right; The right extent
=item Int $top; The top extent
=item Int $bottom; The bottom extent

=end pod

sub gdk_window_set_shadow_width ( N-GObject $window, int32 $left, int32 $right, int32 $top, int32 $bottom )
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_show_window_menu:
=begin pod
=head2 [[gdk_] window_] show_window_menu

Asks the windowing system to show the window menu. The window menu
is the menu shown when right-clicking the titlebar on traditional
windows managed by the window manager. This is useful for windows
using client-side decorations, activating it with a right-click
on the window decorations.

Returns: C<1> if the window menu was shown and C<0> otherwise.


  method gdk_window_show_window_menu ( N-GdkEvent $event --> Int  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event> to show the menu for

=end pod

sub gdk_window_show_window_menu ( N-GObject $window, N-GdkEvent $event )
  returns int32
  is native(&gdk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gdk_window_create_gl_context:
=begin pod
=head2 [[gdk_] window_] create_gl_context

Creates a new B<Gnome::Gdk3::GLContext> matching the
framebuffer format to the visual of the B<Gnome::Gdk3::Window>. The context
is disconnected from any particular window or surface.

If the creation of the B<Gnome::Gdk3::GLContext> failed, I<error> will be set.

Before using the returned B<Gnome::Gdk3::GLContext>, you will need to
call C<gdk_gl_context_make_current()> or C<gdk_gl_context_realize()>.

Returns: (transfer full): the newly created B<Gnome::Gdk3::GLContext>, or
C<Any> on error


  method gdk_window_create_gl_context ( N-GError $error --> N-GObject  )

=item N-GError $error; return location for an error

=end pod

sub gdk_window_create_gl_context ( N-GObject $window, N-GError $error )
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


=comment #TS:0:pick-embedded-child:
=head3 pick-embedded-child

The I<pick-embedded-child> signal is emitted to find an embedded
child at the given position.

Returns: (nullable) (transfer none): the B<Gnome::Gdk3::Window> of the
embedded child at I<x>, I<y>, or C<Any>


  method handler (
    num64 $x,
    num64 $y,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($window),
    *%user-options
    --> Unknown type GDK_TYPE_WINDOW
  );

=item $window; the window on which the signal is emitted

=item $x; x coordinate in the window

=item $y; y coordinate in the window

=begin comment
=comment #TS:0:to-embedder:
=head3 to-embedder

The I<to-embedder> signal is emitted to translate coordinates
in an offscreen window to its embedder.

See also  I<from-embedder>.


  method handler (
    num64 $offscreen_x,
    num64 $offscreen_y,
    Unknown type G_TYPE_POINTER $embedder_x,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget(bedder_y,
    Gnome::GObject::Object :widget($window),
    *%user-options
  );

=item $window; the offscreen window on which the signal is emitted

=item $offscreen_x; x coordinate in the offscreen window

=item $offscreen_y; y coordinate in the offscreen window

=item $embedder_x; (out) (type double): return location for the x
coordinate in the embedder window
=item $embedder_y; (out) (type double): return location for the y
coordinate in the embedder window
=end comment

=begin comment
=comment #TS:0:from-embedder:
=head3 from-embedder

The I<from-embedder> signal is emitted to translate coordinates
in the embedder of an offscreen window to the offscreen window.

See also  I<to-embedder>.


  method handler (
    num64 $embedder_x,
    num64 $embedder_y,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget(fscreen_x,
    Unknown type G_TYPE_POINTER $offscreen_y,
    Gnome::GObject::Object :widget($window),
    *%user-options
  );

=item $window; the offscreen window on which the signal is emitted

=item $embedder_x; x coordinate in the embedder window

=item $embedder_y; y coordinate in the embedder window

=item $offscreen_x; (out) (type double): return location for the x
coordinate in the offscreen window
=item $offscreen_y; (out) (type double): return location for the y
coordinate in the offscreen window
=end comment

=begin comment
=comment #TS:0:create-surface:
=head3 create-surface

The I<create-surface> signal is emitted when an offscreen window
needs its surface (re)created, which happens either when the
window is first drawn to, or when the window is being
resized. The first signal handler that returns a non-C<Any>
surface will stop any further signal emission, and its surface
will be used.

Note that it is not possible to access the window's previous
surface from within any callback of this signal. Calling
C<gdk_offscreen_window_get_surface()> will lead to a crash.

Returns: the newly created B<cairo_surface_t> for the offscreen window


  meInt :$_handler_id,
    Gnome::GObject::Object :_widget(
    Int $width,
    Int $height,
    Gnome::GObject::Object :widget($window),
    *%user-options
    --> Unknown type CAIRO_GOBJECT_TYPE_SURFACE
  );

=item $window; the offscreen window on which the signal is emitted

=item $width; the width of the offscreen surface to create

=item $height; the height of the offscreen surface to create
=end comment


=comment #TS:0:moved-to-rect:
=head3 moved-to-rect

Emitted when the position of I<window> is finalized after being moved to a
destination rectangle.

I<window> might be flipped over the destination rectangle in order to keep
it on-screen, in which case I<flipped_x> and I<flipped_y> will be set to C<1>
accordingly.

I<flipped_rect> is the ideal position of I<window> after any possible
flipping, but before any possible sliding. I<final_rect> is I<flipped_rect>,
but possibly translated in the case that flipping is still ineffective in
keeping I<window> on-screen.

Stability: Private

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget(ipped_rect,
    Unknown type G_TYPE_POINTER $final_rect,
    Int $flipped_x,
    Int $flipped_y,
    Gnome::GObject::Object :widget($window),
    *%user-options
  );

=item $window; the B<Gnome::Gdk3::Window> that moved

=item $flipped_rect; (nullable): the position of I<window> after any possible
flipping or C<Any> if the backend can't obtain it
=item $final_rect; (nullable): the final position of I<window> or C<Any> if the
backend can't obtain it
=item $flipped_x; C<1> if the anchors were flipped horizontally

=item $flipped_y; C<1> if the anchors were flipped vertically


=end pod
