use v6;
#use lib '../gnome-gobject/lib';

use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gdk3::RGBA $r;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $r .= new( :red(.5e0), :green('0.5'), :blue(0.5), :alpha(.5e0));
  isa-ok $r, Gnome::Gdk3::RGBA, '.new(:red,...)';
  ok $r.is-valid, 'r,g,b,a is valid';

  my Gnome::Gdk3::RGBA $c1 .= new(:native-object($r._get-native-object));
  isa-ok $c1, Gnome::Gdk3::RGBA, '.new(:native-object(N-GdkRGBA))';
  is $c1.to-string, 'rgba(128,128,128,0.5)', 'compare string ok';
  ok $r.is-valid, 'rgba is valid';

  $c1 .= new(:native-object($r));
  isa-ok $c1, Gnome::Gdk3::RGBA, '.new(:native-object(Gnome::Gdk3::RGBA))';
  is $c1.to-string, 'rgba(128,128,128,0.5)', 'compare string ok';

  $c1 .= new(:rgba<#ff0>);
  isa-ok $c1, Gnome::Gdk3::RGBA, '.new(:rgba(Str))';
  is $c1.to-string, 'rgb(255,255,0)', 'compare string ok';

  $c1.clear-object;
  nok $c1.is-valid, '.clear-object()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $r.to-string, 'rgba(128,128,128,0.5)', '.to-string()';

  my Gnome::Gdk3::RGBA $r2 .= new(:native-object($r.copy));
  is $r2.to-string, 'rgba(128,128,128,0.5)', '.copy()';

  $r .= new( :red(.6e0), :green(.4e0), :blue(.3e0), :alpha(1e0));
  my UInt $key = $r.hash;

  ok $key > 0, '.hash(Gnome::Gdk3::RGBA)';
  my Gnome::Gdk3::RGBA $r3 .= new(:native-object($r2.hash($key)));
  is $r.to-string, $r3.to-string, '.hash(UInt)';

  ok $r.equal($r3), '.equal(): =';
  nok $r2.equal($r3), '.equal(): ≠';

  ok $r.parse('#8f0'), '.parse("#rgb")';
  is $r.to-string, 'rgb(136,255,0)', 'compare rgb string ok';
  ok $r.parse('rgba(127,255,0,0.5)'), '.parse("rgba()")';
  is $r.to-string, 'rgba(127,255,0,0.5)', 'compare string ok';

  is $r.red.round(0.1), 0.5, '.red()';
  is $r.green, 1.0, '.green()';
  is $r.blue, 0, '.blue()';
  is $r.alpha, 0.5, '.alpha()';

  $r.red(1e0);
  is $r.to-string, 'rgba(255,255,0,0.5)', 'red changed';
  $r.blue(1e0);
  is $r.to-string, 'rgba(255,255,255,0.5)', 'blue changed';
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

=finish

use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;

#-------------------------------------------------------------------------------
subtest 'rgba set', {
  my Gnome::Gdk3::RGBA::GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );

  is $color.green, 0.5, 'green ok';
}

#-------------------------------------------------------------------------------
done-testing;
