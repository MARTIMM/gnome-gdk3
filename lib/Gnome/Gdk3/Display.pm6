use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Object;
#use Gnome::Gdk3::Screen;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkscreen.h
# https://developer.gnome.org/gdk3/stable/GdkDisplay.html
unit class Gnome::Gdk3::Display:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<opened>,
    :nativewidget<monitor-added monitor-removed seat-added seat-removed>,
    :bool<closed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk3::Display';

  if ? %options<default> {
    self.native-gobject(gdk_display_get_default()).defined;
  }

  elsif ? %options<open> {
    self.native-gobject(gdk_display_open(%options<string>));
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
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gdk_display_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}

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
