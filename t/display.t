use v6;
#use lib '../perl6-gnome-native/lib', '../perl6-gnome-gobject/lib';
use Test;

use Gnome::N::N-GObject;
use Gnome::Gdk::Display;

#TODO auto init
use GTK::V3::Gtk::GtkMain;
my GTK::V3::Gtk::GtkMain $m .= new;

#-------------------------------------------------------------------------------
subtest 'Manage display', {
#  X::Gnome.debug(:on);

  my Gnome::Gdk::Display $display;
  throws-like
    { $display .= new; },
    X::Gnome, "No options used",
    :message('No options used to create or set the native widget');

  throws-like
    { $display .= new( :find, :search); },
    X::Gnome, "Wrong options used",
    :message(
      /:s Unsupported options for
          'Gnome::Gdk::Display:'
          [(find||search) ',']+ /
    );

  $display .= new(:default);
  isa-ok $display, Gnome::Gdk::Display;
  isa-ok $display(), N-GObject;

  my Str $display-name = $display.get-name();
  like $display-name, /\: \d+/, 'name has proper format: ' ~ $display-name;
}

#-------------------------------------------------------------------------------
done-testing;
