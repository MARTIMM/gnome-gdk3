use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::Gdk3::Display;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::Display $d;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $d .= new(:default);
  isa-ok $d, Gnome::Gdk3::Display, '.new(:default)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
#  X::Gnome.debug(:on);

  throws-like
    { $d .= new; },
    X::Gnome, "No options used",
    :message('No options used to create or set the native widget');

  throws-like
    { $d .= new( :find, :search); },
    X::Gnome, "Wrong options used",
    :message(
      /:s Unsupported options for
          'Gnome::Gdk3::Display:'
          [(find||search) ',']+ /
    );

  $d .= new(:default);
  my Str $d-name = $d.get-name();
  like $d-name, /\: \d+/, '.get-name(): ' ~ $d-name;

  $d .= new( :open, :display-name($d-name));
  $d-name = $d.get-name();
  like $d-name, /\: \d+/, '.new( :open, :display-name): ' ~ $d-name;


  nok $d.is-closed, '.is-closed()';

#(Display.t:14631): Gdk-CRITICAL **: 16:41:06.574: gdk_display_is_closed: assertion 'GDK_IS_DISPLAY (display)' failed
  #$d.gdk-display-close;
  #ok $d.is-closed, '.is-closed()';

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
