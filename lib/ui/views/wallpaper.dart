import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:re_walls/core/utils/theme.dart';
import 'web_page.dart';
import '../../core/utils/dialog_utils.dart';
import '../widgets/general.dart';
import 'package:share/share.dart';
import '../../core/utils/models/response.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class WallpaperPage extends StatefulWidget {
  final String heroId;
  final List<Post> posts;
  final int index;

  WallpaperPage(
      {@required this.heroId, @required this.posts, @required this.index});
  @override
  _WallpaperPageState createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  BoxFit fit = BoxFit.cover;
  Post currentPost;
  static const platform = const MethodChannel('com.bimsina.re_walls/wallpaper');
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    currentPost = widget.posts[widget.index];
    _pageController = PageController(
      initialPage: widget.index,
    );
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeNotifier>(context);
    final themeData = themeState.getTheme();
    return Scaffold(
      body: wallpaperBody(themeData),
    );
  }

  void downloadImage() async {
    try {
      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);

      if (status == PermissionStatus.granted) {
        try {
          showToast('Check the notification to see progress.');

          var imageId = await ImageDownloader.downloadImage(currentPost.url,
              destination: AndroidDestinationType.directoryDownloads);
          if (imageId == null) {
            return;
          }
        } on PlatformException catch (error) {
          print(error);
        }
      } else {
        askForPermission();
      }
    } catch (e) {
      print(e);
    }
  }

  void askForPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (status == PermissionStatus.granted) {
      downloadImage();
    } else {
      showToast('Please grant storage permission.');
    }
  }

  void _setWallpaper() async {
    var file = await DefaultCacheManager().getSingleFile(currentPost.url);
    try {
      final int result = await platform.invokeMethod('setWallpaper', file.path);
      print('Wallpaer Updated.... $result');
    } on PlatformException catch (e) {
      print("Failed to Set Wallpaer: '${e.message}'.");
    }
    Navigator.pop(context);
  }

  void showToast(String content) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);

  Widget bottomSheet(ThemeData themeData) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        color: themeData.primaryColorDark.withOpacity(0.9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            currentPost.title,
            style: themeData.textTheme.bodyText2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Posted on r/${currentPost.subreddit} by u/${currentPost.author}',
            style: themeData.textTheme.bodyText1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: <Widget>[
              ColButton(
                title: 'Set Wallpaper',
                icon: Icons.wallpaper,
                onTap: () async {
                  showLoadingDialog(context);
                  await Future.delayed(Duration(seconds: 1));
                  _setWallpaper();
                },
              ),
              ColButton(
                title: 'Download',
                icon: Icons.file_download,
                onTap: downloadImage,
              ),
              ColButton(
                title: 'Share',
                icon: Icons.share,
                onTap: () {
                  Share.share(
                      'Checkout this awesome wallpaper I found on reWalls ${currentPost.url}');
                },
              ),
              ColButton(
                title: 'Source',
                icon: Icons.open_in_browser,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebPage(
                                title: currentPost.title,
                                initialPage: 'https://www.reddit.com' +
                                    currentPost.permalink,
                              )));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget wallpaperBody(ThemeData themeData) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (_controller.isCompleted) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
            },
            child: Hero(
              tag: widget.heroId,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: themeData.primaryColor,
                child: PageView(
                  controller: _pageController,
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      currentPost = widget.posts[index];
                    });
                  },
                  children: widget.posts
                      .map(
                        (item) => CachedNetworkImage(
                          errorWidget: (context, url, error) => Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                                child: Icon(
                              Icons.error,
                              color: themeData.accentColor,
                            )),
                          ),
                          fit: fit,
                          placeholder: (context, url) => Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.network(
                                item.preview.images[0].resolutions[0].url,
                                fit: fit,
                              ),
                              Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      themeData.accentColor),
                                ),
                              ),
                            ],
                          ),
                          imageUrl: item.url,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Transform.translate(
                  offset: Offset(0, -_controller.value * 80),
                  child: Container(
                    height: 80.0,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 24),
                    decoration: BoxDecoration(
                      color: themeData.primaryColorDark.withOpacity(0.9),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: themeData.textTheme.bodyText2.color,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            fit == BoxFit.contain
                                ? Icons.fullscreen
                                : Icons.fullscreen_exit,
                            color: themeData.textTheme.bodyText2.color,
                          ),
                          onPressed: () {
                            if (fit == BoxFit.contain) {
                              fit = BoxFit.cover;
                            } else {
                              fit = BoxFit.contain;
                            }
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, _controller.value * 150),
                  child: bottomSheet(themeData),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
