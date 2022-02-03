## Release notes
* 2022-02-02 0.19.2:
  * Doc changes for **Gnome::Gdk3::Events**. Quite a few methods were defined uncorrectly and therefore unusable.

* 2021-12-12 0.19.1:
  * Changes for renamed methods in **Gnome::N::TopLevelClassSupport**.

* 2021-05-24 0.19.0:
  * Added modules **Gnome::Gdk3::DragContext** and **Gnome::Gdk3::Atom** for drag and drop support.

* 2021-04-25 0.18.1:
  * Changed  **Gnome::Gdk3::Screen** and **Gnome::Gdk3::Visual** for remarks made in release notes of Gtk3.

* 2021-04-11 0.18.0:
  * Add module **Gnome::Gdk3::Visual**.
  * Bugfixes in **Gnome::Gdk3::Screen**. option `:native-object` for `.new()` was not recognized.

* 2021-04-01 0.17.3:
  * Enumerated type `N-GdkEventMask` has a wrong name and is renamed to `GdkEventMask`. All enumerated types are without the leading N-. The N- prefix is used for native structures and classes like `N-GObject`, `N-GError`, `N-GdkRectangle`, etcetera. It won't break anything because it is not used as a type on parameters. It is mainly used for its members which are or'ed into a mask and sent/received as an `Int`.
  * Window was using the N-GdkEventMask parameter wrongly. It must use `Int` because it is a mask of flags from the now renamed enum `GdkEventMask`.

* 2020-12-16 0.17.2:
  * Also this package is now tested on Travis-ci and Appveyor.

* 2020-07-16 0.17.1:
  * Modified the structure types of `GdkEvent*`into `N-GdkEvent*`. The older types are deprecated and are removed in version 0.20.0.

* 2020-07-10 0.17.0:
  * Introduction to Cairo
  * Added `gdk_window_create_similar_surface()` and `gdk_window_create_similar_image_surface()` to **Gnome::Gdk3::Window**.
  * Added `new(:window)` and `new(:surface)` to **Gnome::Gdk3::Pixbuf**.

* 2020-04-22 0.15.6:
  * Modified and extended **Gnome::Gdk3::Pixbuf**.

* 2020-04-15 0.15.5:
  * Added `gdk_pixbuf_get_type()` to support a missing type GDK_TYPE_PIXBUF. This cannot be encoded because it is not a fundamental type like G_TYPE_INT.

* 2020-03-25 0.15.4:
  * Added native-object-ref and native-object-unref in Rgba after changes in Gnome::GObject::Boxed.

* 2020-03-07 0.15.3:
  * Bugfixes in test programs

* 2020-01-27 0.15.2:
  * Changes from **Gnome::Glib::Error** incorporated

* 2020-01-18 0.15.1:
  * Renaming calls to `*native-gobject()` and `*native-gboxed()`.
  * Rename `:widget` to `:native-object`.
  * Remove `:empty` and use empty options hash instead
  * Removed partly `:rgba` in Rgba
  * Add `clear-object()` and `is-valid()` in Rgba

* 2020-01-10 0.15.0.1:
  * Repo renaming. Perl6 to Raku.

* 2019-12-09 0.15.0:
  * New module Pixbuf

* 2019-12-03 0.14.15:
  * Documentation changes

* 2019-11-24 0.14.14
  * Modified `_fallback()` routines to change order of tests

* 2019-11-17 0.14.13
  * bugfixed in RGBA. Any should have defaults of 1.0.

* 2019-11-07 0.14.12
  * Convenience additions to RGBA. The object can now be initialized using Int, Num, Rat or Str types instead of Num only.

* 2019-10-13 0.14.11
  * all classes reviewed caused by changes in signalling system, also modules are extended and documented. Tests are added too.

* 2019-08-22 0.14.10
  * All `fallback()` method renamed to `_fallback()`

* 2019-07-31 0.14.9 sic
* 2019-07-31 0.14.8
  * Packaging error. Had to repackage with newer version.

* 2019-07-29 0.14.7
  * Bug fix; unneeded `use Gnome::Gtk3::Main` in some of the tests. This was needed when there was no automatic init and the test needed to do that.

* 2019-07-15 0.14.6
  * small pod doc changes

* 2019-07-15 0.14.5
  * Extended EventTypes and renamed to Events.

* 2019-06-07 0.14.4
  * modified multiple return values of several native subs into a List.

* 2019-06-07 0.14.3
  * extended Window

* 2019-06-07 0.14.2
  * bugfixes

* 2019-06-07 0.14.1
  * Extended Gnome::Gdk3::Window

* 2019-06-07 0.14.0
  * Added RGBA structure

* 2019-05-28 0.13.3
  * Updating docs

* 2019-06-01 0.13.2
  * Class names are changed into Gnome::Gdk3 because there is also for Gdk a version 3 and version 4 series. See also docs at the [Gnome Developer Center](https://developer.gnome.org/references)

* 2019-05-28 0.13.1
  * Refactored from project GTK::V3 at version 0.13.1
  * Modified class names by removing the first 'G' from the name. E.g. GBoxed becomes Boxed.
