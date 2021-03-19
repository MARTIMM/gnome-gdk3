![gtk logo][logo]
<!--
[![License](http://martimm.github.io/label/License-label.svg)](http://www.perlfoundation.org/artistic_license_2_0)
-->
# Gnome Gdk - Low-level abstraction for the windowing system

![T][travis-svg] ![A][appveyor-svg] ![L][license-svg]

[travis-svg]: https://travis-ci.org/MARTIMM/gnome-gdk3.svg?branch=master
[travis-run]: https://travis-ci.org/MARTIMM/gnome-gdk3

[appveyor-svg]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-gdk3?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-run]: https://ci.appveyor.com/project/MARTIMM/gnome-gdk3/branch/master

[license-svg]: http://martimm.github.io/label/License-label.svg
[licence-lnk]: http://www.perlfoundation.org/artistic_license_2_0

# Documentation
* [ 🔗 Website](https://martimm.github.io/gnome-gtk3/content-docs/reference-gdk3.html)
* [ 🔗 Travis-ci run on master branch][travis-run]
* [ 🔗 Appveyor run on master branch][appveyor-run]
* [ 🔗 License document][licence-lnk]
* [ 🔗 Release notes][changes]
* [ 🔗 Issues](https://github.com/MARTIMM/gnome-gtk3/issues)

<!--
| Pdf from pod | Link to Gnome Developer |
|-------|--------------|
| Gnome::Gdk3::Display | [Controls a set of Screens and their associated input devices][GdkDisplay]
| [Gnome::Gdk3::Events][Gnome::Gdk3::Events pdf] | [Device events][GdkEventTypes]
| Gnome::Gdk3::Keysyms |
| Gnome::Gdk3::RGBA | [Red Green Blue and Opacity structure][GdkRGBA]
| Gnome::Gdk3::Screen | [Object representing a physical screen][GdkScreen]
| [Gnome::Gdk3::Types][Gnome::Gdk3::Types pdf] |
| Gnome::Gdk3::Window | [Windows][GdkWindow]

## Release notes
* [Release notes][changes]
-->

# Installation
Do not install this package on its own. Instead install `Gnome::Gtk3`.

`zef install Gnome::Gtk3`


# Author

Name: **Marcel Timmerman**
Github account name: **MARTIMM**

# Issues

There are always some problems! If you find one, please help by filing an issue at [my Gnome::Gtk3 github project][issues].

# Attribution
* The inventors of Raku, formerly known as Perl 6, of course and the writers of the documentation which helped me out every time again and again.
* The builders of the GTK+ library and the documentation.
* Other helpful modules for their insight and use.
* Icons used from www.iconfinder.com, humility icons, Andy Fitzsimon, licensed GPL.


[//]: # (---- [refs] ----------------------------------------------------------)
[changes]: https://github.com/MARTIMM/gnome-gdk/blob/master/CHANGES.md
[logo]: https://martimm.github.io/gnome-gtk3/content-docs/images/gtk-perl6.png
[issues]: https://github.com/MARTIMM/gnome-gtk3/issues

[GdkDisplay]: https://developer.gnome.org/gdk3/stable/GdkDisplay.html
[GdkEventTypes]: https://developer.gnome.org/gdk3/stable/gdk3-Event-Structures.html
[GdkRGBA]: https://developer.gnome.org/gdk3/stable/gdk3-RGBA-Colors.html
[GdkScreen]: https://developer.gnome.org/gdk3/stable/GdkScreen.html
[GdkWindow]: https://developer.gnome.org/gdk3/stable/gdk3-Windows.html


[Gnome::Gdk3::Events html]: https://nbviewer.jupyter.org/github/MARTIMM/gnome-gdk3/blob/master/doc/EventTypes.html
[Gnome::Gdk3::Events pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gnome-gdk3/blob/master/doc/EventTypes.pdf
[Gnome::Gdk3::Types html]: https://nbviewer.jupyter.org/github/MARTIMM/gnome-gdk3/blob/master/doc/Types.html
[Gnome::Gdk3::Types pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gnome-gdk3/blob/master/doc/Types.pdf
