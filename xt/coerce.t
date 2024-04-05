use NativeCall;
use Test;
#use lib '../gnome-native/lib';

use Gnome::N::N-GObject:api<1>;
use Gnome::Gdk3::RGBA:api<1>;

#use Gnome::N::X:api<1>;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::RGBA() $r;
#-------------------------------------------------------------------------------
subtest 'Coerce to native', {
  $r .= new( :red(.5e0), :green('0.5'), :blue(0.5), :alpha(.5e0));

  my N-GObject() $no = $r;
#note 'no: ', $no.gist();
  $r = $no;
#note 'r: ', $r.WHAT, ', ', $no.WHAT;
  is $r.red, 5e-1, '.red()';
  is $no.(Gnome::Gdk3::RGBA).red, 5e-1, '.red()';
}
