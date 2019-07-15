use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::Events;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'Events ISA test', {
  my Gnome::Gdk3::Events $be .= new;
  isa-ok $be, Gnome::Gdk3::Events;
}

#-------------------------------------------------------------------------------
done-testing;
