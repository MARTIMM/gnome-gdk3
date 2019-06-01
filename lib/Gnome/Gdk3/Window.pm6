use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Object;
use Gnome::Gdk3::Types;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkwindow.h
# https://developer.gnome.org/gdk3/stable/gdk3-Windows.html
unit class Gnome::Gdk3::Window:auth<github:MARTIMM>
  is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
#class N-GObject
#  is repr('CPointer')
#  is export
#  { }

#-------------------------------------------------------------------------------
enum GdkWindowType is export <
  GDK_WINDOW_ROOT
  GDK_WINDOW_TOPLEVEL
  GDK_WINDOW_CHILD
  GDK_WINDOW_TEMP
  GDK_WINDOW_FOREIGN
  GDK_WINDOW_OFFSCREEN
  GDK_WINDOW_SUBSURFACE
>;

enum GdkWindowWindowClass is export <
  GDK_INPUT_OUTPUT
  GDK_INPUT_ONLY
>;

#`{{
class GdkWindowAttr is repr('CStruct') {
  has Str $.title;
  has int32 $.event_mask;
  has int32 $.x;
  has int32 $.y;
  has int32 $.width;
  has int32 $.height;
  has GdkWindowWindowClass $.wclass;
  has GdkVisual $.visual;
  has GdkWindowType $.window_type;
  has GdkCursor $.cursor;
  has gchar $.wmclass_name;
  has gchar $.wmclass_class;
  has gboolean $.override_redirect;
  has GdkWindowTypeHint $.type_hint;
}
}}

#-------------------------------------------------------------------------------
#`{{
sub gdk_window_new (
  N-GObject $parent, GdkWindowAttr $attributes, uint32 attributes_mask
) returns N-GObject
  is native(&gdk-lib)
  { * }
}}

sub gdk_window_get_origin (
  N-GObject $window, int32 $x is rw, int32 $y is rw
) returns int32
  is native(&gdk-lib)
  { * }

sub gdk_window_destroy ( N-GObject $window )
  is native(&gdk-lib)
  { * }

sub gdk_window_get_window_type ( N-GObject $window )
  returns int32             # GdkWindowType
  is native(&gdk-lib)
  { * }

sub gdk_get_default_root_window ( )
  returns N-GObject         # GdkWindow
  is native(&gdk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :int2<create-surface>,
    :num2ptr2<from-embedder to-embedder>,
    :ptr2bln2<moved-to-rect>,
    :num2<pick-embedded-child>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk3::Window';

  if ? %options<default> {
    self.native-gobject(gdk_get_default_root_window());
  }

  elsif ? %options<widget> || ? %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gdk_window_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
