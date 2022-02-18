use v6.d;
use NativeCall;

use Gnome::N::GlibToRakuTypes;
use Gnome::N::N-GObject;
use Gnome::N::X;
Gnome::N::debug(:on);

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;

use Gnome::Gdk3::Display;
use Gnome::Gdk3::Window;
use Gnome::Gdk3::Events;

use Gnome::Glib::MainLoop;

#class N-GObject is repr('CPointer') is export { }

class N-EvBttn is export is repr('CStruct') {
  has GEnum $.type;
  has N-GObject $.window;
  has gdouble $.x;
  has gdouble $.y;

  submethod BUILD ( :$type, :$x, :$y ) {
    $!type = $type.value;
    $!x = ($x // 0).Num;
    $!y = ($y // 0).Num;
  }

  submethod TWEAK ( N-GObject() :$window ) {
    $!window := $window if ?$window;
  }
}

my Gnome::Gtk3::Button $b .= new(:label<Start>);
with my Gnome::Gtk3::Window $gtk-window .= new {
  .set-title('test events');
  .add($b);
  .show-all;
}


my $no = N-EvBttn.new(
  :type(GDK_BUTTON_PRESS), :x(20e0), :y(20e0), :time(time),
  :window($gtk-window.get-window)
);

note "event: $no.gist()";









=finish
class X {
  method set-event ( Gnome::Gtk3::Window :$gtk-window ) {

    state Int $count = 0;
#    my Gnome::Gdk3::Display $display = $gtk-window.get-display-rk;
#    my N-GObject $gdk-window-no = $gtk-window.get-window;

    my $no = N-EvBttn.new(
      :type(GDK_BUTTON_PRESS), :x(20e0), :y(20e0), :time(time),
      :window($gtk-window.get-window)
    );

note "event: $no.gist()";
    if $count++ > 10 {
      G_SOURCE_REMOVE
    }

    else {
      G_SOURCE_CONTINUE
    }
  }
}


my Gnome::Gtk3::Button $b .= new(:label<Start>);
with my Gnome::Gtk3::Window $gtk-window .= new {
  .set-title('test events');
  .add($b);
  .show-all;
}

my Gnome::Glib::MainLoop $loop .= new;

my Int $esid = $loop.timeout-add(
  1000, X.new, 'set-event', :$gtk-window
);
$loop.run;
