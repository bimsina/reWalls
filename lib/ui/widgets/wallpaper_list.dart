import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../views/wallpaper.dart';
import '../../core/utils/models/response.dart';

class WallpaperList extends StatefulWidget {
  final List<Post> posts;
  final ThemeData themeData;

  WallpaperList({@required this.posts, @required this.themeData});

  @override
  _WallpaperListState createState() => _WallpaperListState();
}

class _WallpaperListState extends State<WallpaperList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.posts.length == 0
        ? SizedBox(
            height: 200,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.sadCry,
                      size: 30, color: widget.themeData.accentColor),
                ),
                Text(
                  'Seems like what you are looking for, is empty.',
                  style: widget.themeData.textTheme.bodyText1,
                )
              ],
            ),
          )
        : wallpaperGrid(widget.posts);
  }

  Widget wallpaperGrid(List<Post> list) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.7),
      padding: const EdgeInsets.all(0),
      itemCount: list.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WallpaperPage(
                            heroId: 'popular${list[index].name}',
                            posts: list,
                            index: index,
                          )));
            },
            child: Hero(
              tag: 'popular${list[index].name}',
              child: SizedBox(
                width: double.infinity,
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: Icon(
                          Icons.error,
                          color: widget.themeData.accentColor,
                        ),
                      ),
                    ),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: widget.themeData.primaryColorDark,
                          child: Center(
                              child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                widget.themeData.accentColor),
                          ))),
                    ),
                    imageUrl:
                        list[index].preview.images[0].resolutions.length <= 3
                            ? widget
                                .posts[index]
                                .preview
                                .images[0]
                                .resolutions[list[index]
                                        .preview
                                        .images[0]
                                        .resolutions
                                        .length -
                                    1]
                                .url
                                .replaceAll('amp;', '')
                            : list[index]
                                .preview
                                .images[0]
                                .resolutions[3]
                                .url
                                .replaceAll('amp;', ''),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
