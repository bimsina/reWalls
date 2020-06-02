import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_walls/core/utils/theme.dart';
import 'package:re_walls/core/viewmodels/grid_wallpaper_state.dart';
import '../../core/utils/constants.dart';
import '../views/selector.dart';
import '../../core/utils/api_endpoints.dart';
import '../../core/utils/models/response.dart';
import '../widgets/wallpaper_list.dart';
import '../widgets/general.dart';

class PopularWallpapers extends StatefulWidget {
  @override
  _PopularWallpapersState createState() => _PopularWallpapersState();
}

class _PopularWallpapersState extends State<PopularWallpapers>
    with AutomaticKeepAliveClientMixin<PopularWallpapers> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return mainList(context);
  }

  Widget mainList(BuildContext context) {
    final dataState = Provider.of<GridWallpaperState>(context);
    final themeState = Provider.of<ThemeNotifier>(context);
    final themeData = themeState.getTheme();
    final List<Post> posts = dataState.posts;

    return dataState.state == kdataFetchState.IS_LOADING
        ? Container(
            width: double.infinity,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(themeData.accentColor),
              ),
            ),
          )
        : dataState.state == kdataFetchState.ERROR_ENCOUNTERED
            ? ErrorOccured(
                onTap: () =>
                    dataState.fetchWallPapers(dataState.selectedSubreddit),
              )
            : ListView(
                padding: const EdgeInsets.all(0.0),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  ListTile(
                    dense: true,
                    trailing: Icon(Icons.edit,
                        color: themeData.textTheme.bodyText1.color),
                    title: Text(
                        '${kfilterValues[dataState.selectedFilter]} on r/${dataState.selectedSubreddit.join(', ')}',
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: themeData.textTheme.caption),
                    onTap: () async {
                      SelectorCallback selected =
                          await showModalBottomSheet<SelectorCallback>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return SelectorWidget(
                                  themeData: themeData,
                                  filterSelected: dataState.selectedFilter,
                                  subredditSelected:
                                      dataState.selectedSubreddit,
                                );
                              });

                      if (selected != null) {
                        dataState.changeSelected(selected);
                      }
                    },
                  ),
                  WallpaperList(
                    posts: posts,
                    themeData: themeData,
                  ),
                ],
              );
  }
}
