import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_walls/core/utils/models/response.dart';
import 'package:re_walls/core/utils/theme.dart';
import 'package:re_walls/core/viewmodels/carousel_wallpaper_state.dart';
import '../../core/utils/constants.dart';
import '../views/selector.dart';
import '../views/wallpaper.dart';
import '../../core/utils/api_endpoints.dart';

import 'general.dart';

class NewWallpapers extends StatefulWidget {
  @override
  _NewWallpapersState createState() => _NewWallpapersState();
}

class _NewWallpapersState extends State<NewWallpapers>
    with AutomaticKeepAliveClientMixin<NewWallpapers> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dataState = Provider.of<CarouselWallpaperState>(context);
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
            : Column(
                children: <Widget>[
                  ShowSelectorWidget(
                    title:
                        '${kfilterValues[dataState.selectedFilter]} on r/${dataState.selectedSubreddit.join(', ')}',
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
                  CarouselSlider(
                    enlargeCenterPage: true,
                    autoPlay: true,
                    height: 250.0,
                    viewportFraction: 0.7,
                    items: posts.map((post) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WallpaperPage(
                                              heroId: '${post.name}',
                                              posts: posts,
                                              index: posts.indexOf(post),
                                            )));
                              },
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: GestureDetector(
                                  child: Hero(
                                    tag: '${post.name}',
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 200,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                            errorWidget: (context, url,
                                                    error) =>
                                                Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.error,
                                                      color:
                                                          themeData.accentColor,
                                                    ),
                                                  ),
                                                ),
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Center(
                                                  child: Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      color: themeData
                                                          .primaryColorDark,
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                themeData
                                                                    .accentColor),
                                                      ))),
                                                ),
                                            imageUrl: post.preview.images[0]
                                                        .resolutions.length <=
                                                    3
                                                ? post
                                                    .preview
                                                    .images[0]
                                                    .resolutions[post
                                                            .preview
                                                            .images[0]
                                                            .resolutions
                                                            .length -
                                                        1]
                                                    .url
                                                : post.preview.images[0]
                                                    .resolutions[3].url),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              );
  }
}
