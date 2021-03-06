/// Set of configuration for project

abstract class Configs {
  // Firebase
  static const String firebaseItemsCollection = 'items';
  static const String firebaseSuggestionsCollection = 'suggestions';
  static const String firebaseCardsCollection = 'cards';
  static const String firebaseArticlesCollection = 'articles';
  static const int firebaseItemsLimit = 64;
  static const int firebaseSuggestionsLimit = 16;

  // Search
  static const int searchTextMinimumCharacters = 3;
}
