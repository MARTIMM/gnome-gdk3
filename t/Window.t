use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::Window;

#use Gnome::N::X;
#X::Gnome.debug(:on);



#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gdk3::Window $window .= new(:empty);
  isa-ok $window, Gnome::Gdk3::Window;

  my Int $wtype = $window.get-window-type;
note $wtype;
  is GdkWindowType($wtype), GDK_WINDOW_ROOT, 'root window type';
}

#`{{

class X is export is repr('CStruct') {
  has str $.title is rw;
}

my X $x .= new(:title('x'));
}}

#-------------------------------------------------------------------------------
done-testing;
