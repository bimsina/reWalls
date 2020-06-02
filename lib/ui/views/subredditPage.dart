import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../core/utils/models/response.dart';
import '../../core/utils/api_endpoints.dart';
import '../widgets/wallpaper_list.dart';

class SubredditPage extends StatefulWidget {
  final ThemeData themeData;
  final String subreddit;
  SubredditPage({Key key, this.themeData, this.subreddit}) : super(key: key);
  @override
  _SubredditPageState createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  String filterValue = kfilterValues[0];

  bool isLoading = true;
  List<Post> posts;

  @override
  void initState() {
    super.initState();
    fetchWallPapers(widget.subreddit, filterValue);
  }

  void fetchWallPapers(String subreddit, String filter) async {
    setState(() {
      isLoading = true;
    });
    filter = filter.toLowerCase();
    http.get(EndPoints.getPosts(subreddit, filter)).then((res) {
      if (res.statusCode == 200) {
        var decodeRes = jsonDecode(res.body);
        posts = [];
        posts.clear();
        Reddit temp = Reddit.fromJson(decodeRes);
        temp.data.children.forEach((children) {
          if (children.post.postHint == 'image') {
            posts.add(children.post);
          }
        });
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.themeData.primaryColor,
        title: Text('r/${widget.subreddit}',
            style: widget.themeData.textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.themeData.textTheme.bodyText1.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Theme(
              data: widget.themeData
                  .copyWith(canvasColor: widget.themeData.primaryColor),
              child: DropdownButton<String>(
                underline: Container(),
                style: widget.themeData.textTheme.bodyText1,
                value: filterValue,
                items: kfilterValues.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: widget.themeData.textTheme.bodyText1,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (!isLoading) {
                    setState(() {
                      filterValue = value;
                    });

                    fetchWallPapers(widget.subreddit, filterValue);
                  }
                },
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: widget.themeData.primaryColor,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(widget.themeData.accentColor),
                ),
              )
            : WallpaperList(posts: posts, themeData: widget.themeData),
      ),
    );
  }
}
