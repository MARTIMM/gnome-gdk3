use v6;
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
  throws-like
    { $s .= new; },
    X::Gnome, "No options used",
    :message('No options used to create or set the native widget');

  throws-like
    { $s .= new( :find, :search); },
    X::Gnome, "Wrong options used",
    :message(
      /:s Unsupported options for
          'Gnome::Gdk3::Screen:'
          [(find||search) ',']+/
    );

  $s .= new(:default);
  isa-ok $s, Gnome::Gdk3::Screen, '.new(:default)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gdk3::Display $display .= new(:widget($s.get-display));
  my Str $display-name = $display.get-name();
  like $display-name, /\: \d+/,
       '.get-display(): display name has proper format: ' ~ $display-name;
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
