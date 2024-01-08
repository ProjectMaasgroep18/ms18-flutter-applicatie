import 'package:flutter/material.dart';

class Search<T> extends StatelessWidget {
  final ValueNotifier<String> searchValue;
  final List<T> items;
  final String Function(T item) getSearchValue;
  final Widget Function(List<T> items) builder;

  const Search(
      {super.key,
      required this.searchValue,
      required this.getSearchValue,
      required this.items,
      required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: searchValue,
      builder: (context, value, child) {
        // Return all items if the search field is empty
        if (value == '') {
          return builder(items);
        }

        final List<T> filterdItems = [];

        // Getting the words in the search term
        List<String> searchTerms = value.toLowerCase().split(' ');

        // Looping though the items to check if there is a match
        for (T item in items) {
          // Getting the search value from the item to lowercase so the search is more generic
          String itemSearchValue = getSearchValue(item).toLowerCase();

          // Checking for a match
          for (String term in searchTerms) {
            if (itemSearchValue.contains(term)) {
              filterdItems.add(item);
            }
          }
        }

        return builder(filterdItems);
      },
    );
  }
}
