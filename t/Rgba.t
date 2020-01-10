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

  my Gnome::Gdk3::RGBA $c1 .= new(:rgba($r()));
  isa-ok $c1, Gnome::Gdk3::RGBA, '.new(:rgba(N-GdkRGBA))';
  is $c1.to-string, 'rgba(128,128,128,0.5)', 'compare string ok';

  $c1 .= new(:rgba($r));
  isa-ok $c1, Gnome::Gdk3::RGBA, '.new(:rgba(Gnome::Gdk3::RGBA))';
  is $c1.to-string, 'rgba(128,128,128,0.5)', 'compare string ok';

  $c1 = Gnome::Gdk3::RGBA.new(:rgba<#ff0>);
  isa-ok $c1, Gnome::Gdk3::RGBA, '.new(:rgba(Str))';
  is $c1.to-string, 'rgb(255,255,0)', 'compare string ok';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $r.to-string, 'rgba(128,128,128,0.5)', '.to-string()';

  my Gnome::Gdk3::RGBA $r2 .= new(:rgba($r.gdk-rgba-copy));
  is $r2.to-string, 'rgba(128,128,128,0.5)', '.gdk-rgba-copy()';


  $r .= new( :red(.6e0), :green(.4e0), :blue(.3e0), :alpha(1e0));
  my UInt $key = $r.gdk-rgba-hash;
#note "k: $key";
  ok $key > 0, '.gdk-rgba-hash(Gnome::Gdk3::RGBA)';
  my Gnome::Gdk3::RGBA $r3 .= new(:rgba($r2.gdk-rgba-hash($key)));
  is $r.to-string, $r3.to-string, '.gdk-rgba-hash(UInt)';

  ok $r.gdk-rgba-equal($r3), '.gdk-rgba-equal(): =';
  nok $r2.gdk-rgba-equal($r3), '.gdk-rgba-equal(): ≠';

  ok $r.gdk-rgba-parse('#8f0'), '.gdk-rgba-parse("#rgb")';
  is $r.to-string, 'rgb(136,255,0)', 'compare rgb string ok';
  ok $r.gdk-rgba-parse('rgba(127,255,0,0.5)'), '.gdk-rgba-parse("rgba()")';
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
