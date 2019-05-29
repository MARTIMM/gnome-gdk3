use v6;
use NativeCall;

use Gnome::X::N;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Object;
#use Gnome::Gdk::Types;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkdevice.h
# https://developer.gnome.org/gdk3/stable/GdkDevice.html
unit class Gnome::Gdk::Device:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
sub gdk_device_get_name ( N-GObject $device )
  returns Str
  is native(&gdk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<changed>,
    :GdkDeviceTool<tool-changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gdk::Device';

  if ? %options<widget> || ? %options<build-id> {
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
  try { $s = &::("gdk_device_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
