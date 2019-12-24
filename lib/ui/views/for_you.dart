import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_walls/core/utils/constants.dart';
import 'package:re_walls/ui/widgets/general.dart';
import '../../core/utils/models/response.dart';
import '../../core/utils/theme.dart';
import '../widgets/resolution_selector.dart';
import '../../core/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import '../widgets/wallpaper_list.dart';

class ForYou extends StatefulWidget {
  @override
  _ForYouState createState() => _ForYouState();
}

class _ForYouState extends State<ForYou>
    with AutomaticKeepAliveClientMixin<ForYou> {
  @override
  bool get wantKeepAlive => true;

  kdataFetchState _fetchState = kdataFetchState.IS_LOADING;
  List<Post> posts;

  @override
  void initState() {
    super.initState();
    fetchWallPapers(EndPoints.getSearch(
        '${window.physicalSize.width.toInt()}x${window.physicalSize.height.toInt()}'));
  }

  void fetchWallPapers(String subreddit) async {
    setState(() {
      _fetchState = kdataFetchState.IS_LOADING;
    });
    http.get(subreddit).then((res) {
      if (res.statusCode == 200) {
        var decodeRes = jsonDecode(res.body);
        posts = [];
        Reddit temp = Reddit.fromJson(decodeRes);
        temp.data.children.forEach((children) {
          if (children.post.postHint == 'image') {
            posts.add(children.post);
          }
        });

        setState(() {
          _fetchState = kdataFetchState.IS_LOADED;
        });
      } else {
        setState(() {
          _fetchState = kdataFetchState.ERROR_ENCOUNTERED;
        });
      }
    }).catchError((onError) {
      setState(() {
        _fetchState = kdataFetchState.ERROR_ENCOUNTERED;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Provider.of<ThemeNotifier>(context);
    final ThemeData _themeData = theme.getTheme();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: _themeData.primaryColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 45,
            child: ResolutionSelector(
              deviceResolution:
                  '${window.physicalSize.width.toInt()}x${window.physicalSize.height.toInt()}',
              onTap: (value) {
                fetchWallPapers(EndPoints.getSearch(value));
              },
            ),
          ),
          Expanded(
            child: _fetchState == kdataFetchState.IS_LOADING
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(_themeData.accentColor),
                    ),
                  )
                : _fetchState == kdataFetchState.ERROR_ENCOUNTERED
                    ? Center(child: ErrorOccured(
                        onTap: () {
                          fetchWallPapers(EndPoints.getSearch(
                              '${window.physicalSize.width.toInt()}x${window.physicalSize.height.toInt()}'));
                        },
                      ))
                    : WallpaperList(posts: posts, themeData: _themeData),
          ),
        ],
      ),
    );
  }
}
