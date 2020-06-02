import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_walls/core/utils/subreddits.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/theme.dart';
import '../widgets/general.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'subredditPage.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with AutomaticKeepAliveClientMixin<Category> {
  List<String> subreddits, filtered;
  final TextEditingController controller = new TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    prepareSharedPrefs();
  }

  void prepareSharedPrefs() async {
    SharedPreferences.getInstance().then((prefs) {
      subreddits =
          prefs.getStringList('subredditsList') ?? initialSubredditsList;
      setState(() {
        filtered = subreddits;
      });

      controller.addListener(() {
        if (controller.text.length == 0) {
          filtered = subreddits;
        } else {
          filtered = subreddits
              .where((p) => p.toLowerCase().contains(controller.text))
              .toList();
        }
        setState(() {});
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final ThemeData themeData = themeNotifier.getTheme();
    return Column(
      children: <Widget>[
        Expanded(
          child: filtered == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : filtered.length == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                            "Couldn't find the subreddit that your'e looking for.\nTry adding your own subreddit by clicking the add button.",
                            style: themeData.textTheme.bodyText1),
                      ),
                    )
                  : GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 2.1),
                      controller: scrollController,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubredditPage(
                                            themeData: themeData,
                                            subreddit: filtered[index],
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: index < cardColors.length
                                      ? cardColors[index]
                                      : cardColors[index % cardColors.length],
                                  borderRadius: BorderRadius.circular(8.0)),
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text('r/${filtered[index]}',
                                    maxLines: 1,
                                    style: themeData.textTheme.bodyText1
                                        .copyWith(color: Colors.white)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  color: themeData.primaryColorDark,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      controller: controller,
                      cursorColor: themeData.accentColor,
                      style: themeData.textTheme.bodyText1,
                      decoration: InputDecoration(
                        icon: Icon(Icons.search,
                            color: themeData.textTheme.bodyText1.color
                                .withOpacity(0.6)),
                        border: InputBorder.none,
                        hintText: 'What subreddit are you looking for?',
                        hintStyle: themeData.textTheme.bodyText1.copyWith(
                          color: themeData.textTheme.bodyText1.color
                              .withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.extended(
                      backgroundColor: themeData.primaryColorDark,
                      heroTag: 'add',
                      icon: Icon(
                        Icons.add,
                        color: themeData.textTheme.bodyText1.color,
                      ),
                      label: Text(
                        'Add',
                        style: themeData.textTheme.bodyText1,
                      ),
                      onPressed: () async {
                        String res = await showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => Material(
                            child: AlertDialog(
                              backgroundColor: themeData.primaryColorDark,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              content: SubredditAddWidget(),
                            ),
                          ),
                        );
                        if (res != null) {
                          if (!subreddits.contains(res)) {
                            subreddits.add(res);
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setStringList('subredditsList', subreddits);
                              setState(() {
                                filtered = subreddits;
                              });
                            });
                          }
                        }
                      },
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
