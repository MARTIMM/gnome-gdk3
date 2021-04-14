use v6.c;
use lib './lib';

my @modules = <
  Screen Display Device Visual Window
>;

my %class;
for @modules -> $m {
  note "module $m";

#  quietly {
    CATCH { default { .message.say } }

    my Str $mod = "Gnome::Gdk3::$m";
    require ::($mod);
    %class{$m} := ::($mod);
#  }
}

#%class.gist.say;
say "Nil classes:";
for %class.kv -> $k, $v {
  print "$k => ";
  if $v === Nil {
    note 'Nil';
  }

  else {
    note $v;
  }
}


=finish
try require ::('Gnome::Gdk3::Screen');
if ::('Gnome::Gdk3::Screen') ~~ Failure {
  ::('Gnome::Gdk3::Screen').note;
}

my $s = ::('Gnome::Gdk3::Screen').new;
note $s.get-display.get-name;
