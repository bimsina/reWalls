import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/models/subreddit_exist.dart';
import '../../core/utils/theme.dart';
import 'package:http/http.dart' as http;

class ColButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  ColButton(
      {Key key, this.title = '', this.icon = Icons.tap_and_play, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<ThemeNotifier>(context);
    final ThemeData theme = stateData.getTheme();
    return Expanded(
      child: InkWell(
        highlightColor: theme.accentColor,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: theme.textTheme.bodyText2.color,
              ),
            ),
            Text(title,
                style: theme.textTheme.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis)
          ],
        ),
      ),
    );
  }
}

class SubredditAddWidget extends StatefulWidget {
  @override
  _SubredditAddWidgetState createState() => _SubredditAddWidgetState();
}

class _SubredditAddWidgetState extends State<SubredditAddWidget> {
  bool isLoading = false, errorSub = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController subredditText = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    subredditText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final ThemeData themeData = themeNotifier.getTheme();
    return Form(
      key: _formKey,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      'r/',
                      style: themeData.textTheme.bodyText1,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: subredditText,
                      keyboardType: TextInputType.text,
                      style:
                          TextStyle(color: themeData.textTheme.bodyText1.color),
                      decoration: InputDecoration(
                        hintText: 'Subreddit Name',
                        labelText: 'Enter the subreddit',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: themeData.accentColor,
                        )),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a subreddit.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            (!isLoading && errorSub)
                ? Row(children: <Widget>[
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'No such subreddit found!',
                        style: themeData.textTheme.bodyText1,
                      ),
                    )
                  ])
                : SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: themeData.textTheme.bodyText1,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                !isLoading
                    ? MaterialButton(
                        color: themeData.accentColor,
                        child: Text(
                          'Add',
                          style: themeData.textTheme.bodyText1
                              .copyWith(color: themeData.primaryColor),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            checkSub(
                                'https://www.reddit.com/search.json?q=${subredditText.text}&type=sr');
                          }
                        })
                    : CircularProgressIndicator()
              ],
            ),
          ]),
    );
  }

  void checkSub(String subreddit) async {
    setState(() {
      isLoading = true;
    });
    http.get(subreddit).then((res) async {
      if (res.statusCode == 200) {
        Map<String, dynamic> decodeRes = jsonDecode(res.body);
        print(decodeRes);
        SubredditTestClass subredditTestClass =
            SubredditTestClass.fromJson(decodeRes);

        List<bool> list = subredditTestClass.data.children
            .map((item) =>
                item.data.displayname.toLowerCase() ==
                'r/${subredditText.text.toLowerCase()}')
            .toList();
        setState(() {
          isLoading = false;
        });
        if (list.contains(true)) {
          setState(() {
            errorSub = false;
          });

          Navigator.pop(context, subredditText.text);
        } else {
          setState(() {
            errorSub = true;
          });
        }
      }
    });
  }
}

class ErrorOccured extends StatelessWidget {
  final VoidCallback onTap;

  ErrorOccured({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeNotifier>(context);
    final ThemeData _themeData = state.getTheme();
    return SizedBox(
      height: 200,
      child: Column(
        children: <Widget>[
          Text(
            'Oops! something went wrong.',
            style: _themeData.textTheme.bodyText1,
          ),
          RaisedButton(
            onPressed: onTap,
            color: _themeData.accentColor,
            child: Text('Retry',
                style: _themeData.textTheme.bodyText1.copyWith(
                  color: _themeData.primaryColor,
                )),
          ),
        ],
      ),
    );
  }
}

class ShowSelectorWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  ShowSelectorWidget({Key key, this.title, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final ThemeData themeData = themeNotifier.getTheme();
    return ListTile(
      dense: true,
      trailing: Icon(Icons.edit, color: themeData.textTheme.bodyText1.color),
      title: Text(title,
          maxLines: 2,
          overflow: TextOverflow.clip,
          style: themeData.textTheme.caption),
      onTap: onTap,
    );
  }
}
