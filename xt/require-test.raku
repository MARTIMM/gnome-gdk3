use v6.c;


try require ::('Gnome::Gdk3::Screen');
if ::('Gnome::Gdk3::Screen') ~~ Failure {
  ::('Gnome::Gdk3::Screen').note;
}

my $s = ::('Gnome::Gdk3::Screen').new;
note $s.get-display.get-name;
