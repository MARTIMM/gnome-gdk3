use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::Events;
ok 1, 'load module ok';

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::Events $e;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $e .= new(:type(GDK_KEY_PRESS));
  isa-ok $e, Gnome::Gdk3::Events, '.new(:type)';
}


#-------------------------------------------------------------------------------
done-testing;

=finish





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
