import 'package:flutter/material.dart';
import 'package:re_walls/core/utils/subreddits.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/api_endpoints.dart';

class SelectorCallback {
  final int selectedFilter;
  final List<String> selectedSubreddits;

  SelectorCallback({this.selectedFilter, this.selectedSubreddits});
}

class SelectorWidget extends StatefulWidget {
  final ThemeData themeData;
  final int filterSelected;
  final List<String> subredditSelected;
  SelectorWidget(
      {Key key, this.themeData, this.filterSelected, this.subredditSelected})
      : super(key: key);

  @override
  _SelectorWidgetState createState() => _SelectorWidgetState();
}

class _SelectorWidgetState extends State<SelectorWidget> {
  int filterSelected;
  List<String> subreddits, subredditSelected;

  @override
  void initState() {
    super.initState();
    prepareSharedPrefs();
  }

  void prepareSharedPrefs() async {
    SharedPreferences.getInstance().then((prefs) {
      subreddits =
          prefs.getStringList('subredditsList') ?? initialSubredditsList;
      filterSelected = widget.filterSelected;
      subredditSelected = widget.subredditSelected;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        color: widget.themeData.primaryColor,
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(8.0),
            width: 75,
            height: 5,
            decoration: BoxDecoration(
                color: widget.themeData.accentColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Filters : ',
              style: widget.themeData.textTheme.bodyText2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: kfilterValues
                .map(
                  (item) => GestureDetector(
                    onTap: () {
                      setState(() {
                        filterSelected = kfilterValues.indexOf(item);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: kfilterValues.indexOf(item) == filterSelected
                              ? widget.themeData.accentColor.withOpacity(0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        item,
                        style: widget.themeData.textTheme.bodyText1.copyWith(
                            color: kfilterValues.indexOf(item) == filterSelected
                                ? widget.themeData.accentColor
                                : widget.themeData.textTheme.bodyText1.color),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: widget.themeData.accentColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Subreddits : ',
              style: widget.themeData.textTheme.bodyText2,
            ),
          ),
          Expanded(
            child: subreddits == null
                ? CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(widget.themeData.accentColor),
                  )
                : GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            (MediaQuery.of(context).size.width / 100)),
                    itemCount: subreddits.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          if (subredditSelected.contains(subreddits[index]) &&
                              subredditSelected.length > 1) {
                            subredditSelected.remove(subreddits[index]);
                          } else {
                            subredditSelected.add(subreddits[index]);
                          }
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color:
                                  subredditSelected.contains(subreddits[index])
                                      ? widget.themeData.accentColor
                                          .withOpacity(0.3)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            'r/${subreddits[index]}',
                            style: widget.themeData.textTheme.bodyText1
                                .copyWith(
                                    color: subredditSelected
                                            .contains(subreddits[index])
                                        ? widget.themeData.accentColor
                                        : widget.themeData.textTheme.bodyText2
                                            .color),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  child: Text(
                    'OK',
                    style: widget.themeData.textTheme.bodyText2
                        .copyWith(color: widget.themeData.accentColor),
                  ),
                  onPressed: () {
                    Navigator.pop(
                        context,
                        // [filterSelected, subredditSelected]
                        SelectorCallback(
                            selectedFilter: filterSelected,
                            selectedSubreddits: subredditSelected));
                  },
                ),
              ),
              Expanded(
                child: FlatButton(
                  child: Text(
                    'Cancel',
                    style: widget.themeData.textTheme.bodyText2
                        .copyWith(color: widget.themeData.accentColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
