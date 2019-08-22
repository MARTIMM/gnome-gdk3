use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Object;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkscreen.h
# https://developer.gnome.org/gdk3/stable/GdkScreen.html
unit class Gnome::Gdk3::Screen:auth<github:MARTIMM>
  is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
sub gdk_screen_get_default ( )
  returns N-GObject         # GdkScreen
  is native(&gdk-lib)
  { * }

sub gdk_screen_get_display ( N-GObject $screen )
  returns N-GObject         # GdkDisplay
  is native(&gdk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<composited-changed monitors-changed size-changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk3::Screen';

  if ? %options<default> {
    self.native-gobject(gdk_screen_get_default());
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
  try { $s = &::("gdk_screen_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
