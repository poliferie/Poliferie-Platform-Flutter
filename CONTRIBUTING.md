# Contributing to Poliferie.io

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

The following is a list of items we need to address before the release.

## To-do

General:
* Port all icons to icons.dart file.
* Adapt padding and margin based on media queries.

Navigation Bar:
* Get icons from Beta design screens
* Add code to use icons in terms of target platform

Top Bar:
* Use red as background color
* Use white as text color
* Use settings icon in every screens
* Rounded box like here https://stackoverflow.com/questions/55826789/flutter-rounded-corners-in-sliverappbar

Home Screen:
* Use Discover Screen as Home Screen
* Update squared card with only illustration and title
* Make squared card reusable in terms of width
* Include only "Courses" and "University" cards
* Include infinite scrollable list of full size cards

Search Screen:
* Use a SliverAppBar for the search bar (so include it as in a normal
  app bar). Then pass the floating property to it. By doing in this way the
  SliverAppBar will be hide when we scroll down.
* Have the search bar in the second AppBar or SliverBar, examples from
  https://pub.dev/packages/floating_search_bar
* Or propose text plus icon as here https://flutter.dev/docs/catalog/samples/TabBar
* Make Tab Bar more like buttons, examples here:
  -> https://medium.com/better-programming/flutter-tabbar-with-buttons-as-tabs-ios-style-4dff5ae6c055
* Add "Scopri" floating button as https://api.flutter.dev/flutter/material/FloatingActionButton-class.html,
  use the extended version
* Add internal TabBar view for Filters and Searches

Filters:
* Create filter cards with simple overlay widow to select their values
* Define state for each filter and group them into a global filter state.
  This would serve to send the JSON request to the backend.

Searches:
* Modify results card, make it flexible for both courses and universities

University:
* Use a SliverAppBar with university image with same approach then in the
  Search Screen. 
* Make widget for double row of icons and values, given as list....
* Use expandable card to show data or text, make it reusable for both
  universities and courses. Use this widget:
  https://pub.dev/packages/expandable

Compare Selection:
* Use same code as Home for title and subtitle
* Use TabBar approach as for Search to have a consistent view
* Use TextField or FormField as in this example:
  https://pub.dev/packages/flutter_typeahead
  https://flutterawesome.com/an-autocomplete-textfield-for-flutter/
* Floating action button as in search

Backend:
* Add support for Google Firebase as fallback solution.