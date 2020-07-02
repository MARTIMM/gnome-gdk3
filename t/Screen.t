use v6;
#use lib '../gnome-gobject/lib', '../gnome-native/lib';
use Test;

use Gnome::N::N-GObject;
use Gnome::GObject::Object;
use Gnome::Gdk3::Display;
use Gnome::Gdk3::Screen;


#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::Screen $s;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $s .= new;
  isa-ok $s, Gnome::Gdk3::Screen, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gdk3::Display $display .= new(:native-object($s.get-display));
  my Str $display-name = $display.get-name();
  ok ?$display-name, '.get-display(): ' ~ "'$display-name'";
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}


#-------------------------------------------------------------------------------
done-testing;
