import 'package:flutter/material.dart';
import '../widgets/search_results.dart';

class WallpaperSearch extends SearchDelegate<void> {
  final ThemeData themeData;

  WallpaperSearch({this.themeData});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = themeData.copyWith(
        hintColor: themeData.accentColor,
        cursorColor: themeData.accentColor,
        primaryColor: themeData.primaryColor,
        textTheme: TextTheme(
          headline6: themeData.textTheme.bodyText1,
        ));
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: themeData.textTheme.bodyText2.color,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: themeData.textTheme.bodyText2.color,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResults(
      searchTerm: query + ' wallpaper',
      themeData: themeData,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: themeData.primaryColor,
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 50,
            height: 50,
            child: Icon(
              Icons.search,
              size: 50,
              color: themeData.accentColor,
            ),
          ),
          Text('Enter a term to search.', style: themeData.textTheme.bodyText1)
        ],
      )),
    );
  }
}
