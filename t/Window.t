use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::Window;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gdk3::Window $v .= new(:empty);
  isa-ok $v, Gnome::Gdk3::Window;
}

#-------------------------------------------------------------------------------
done-testing;
