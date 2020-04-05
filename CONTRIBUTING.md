# Contributing to Poliferie.io

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

The following is a list of items we need to address before the release.

## General

Style:
* Integrate custom icons package.
* Port all icons to the icons.dart file.

Navigation Bar:
* Get icons from Beta design screens.
* Add code to use icons in terms of target platform.

Top Bar:
* Rounded box like here https://stackoverflow.com/questions/55826789/flutter-rounded-corners-in-sliverappbar.

User Data:
* Save user preferences with [this](https://pub.dev/packages/shared_preferences) flutter package.
* Exploit the same package to store user interactions data, such as last searches.

Onboarding:
* To be done from the design point of view.

## Home

* Fix copy.
* Integrate API to fetch data for the list view.

## Search

* Use a SliverAppBar for the search bar (so include it as in a normal
  app bar). Then pass the floating property to it. By doing in this way the
  SliverAppBar will be hide when we scroll down.
* Have the search bar in the second AppBar or SliverBar, examples from
  https://pub.dev/packages/floating_search_bar.

Filters:
* Retrieve filter list from BLoC.
* Define state for each filter and group them into a global filter state.
  This would serve to send the JSON request to the backend.
* Implement filter clear action.
* Implement filter bottom view content.

Searches:
* Check auto-complete.
* Provide search results.

## University

* Make widget for double row of icons and values, given as list....
* Use expandable card to show data or text, make it reusable for both
  universities and courses. Use this widget:
  https://pub.dev/packages/expandable.

## Courses
* To be done.

## Compare

* Use same code as Home for title and subtitle.
* Use TabBar approach as for Search to have a consistent view.
* Use TextField or FormField as in this example:
  https://pub.dev/packages/flutter_typeahead
  https://flutterawesome.com/an-autocomplete-textfield-for-flutter/.
* Floating action button as in search.