import 'package:provider/provider.dart';
import '../../ui/widgets/bottom_nav_bar.dart';
import '../../core/utils/theme.dart';
import 'search_page.dart';
import 'category.dart';
import 'main_page.dart';
import 'settings.dart';
import 'package:flutter/material.dart';

import 'for_you.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<ThemeNotifier>(context);
    final ThemeData state = stateData.getTheme();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: state.primaryColor,
        elevation: 0,
        title: Text(
          'reWalls',
          style: state.textTheme.headline5,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: state.textTheme.bodyText2.color,
            ),
            onPressed: () => showSearch(
                context: context, delegate: WallpaperSearch(themeData: state)),
          )
        ],
      ),
      body: Container(
        color: state.primaryColor,
        child: PageView(
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            MainBody(),
            Category(),
            ForYou(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        unselectedColor: state.textTheme.bodyText2.color,
        onItemSelected: (index) {
          _pageController.jumpToPage(index);
        },
        selectedColor: state.accentColor,
        backgroundColor: state.primaryColor,
        showElevation: false,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.category),
            title: Text('Subreddits'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.phone_android),
            title: Text('Exact Fit'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }

  Widget oldBody(ThemeData state) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: state.primaryColor,
            elevation: 4,
            title: Text(
              'reWalls',
              style: state.textTheme.headline5,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search, color: state.accentColor),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: WallpaperSearch(themeData: state));
                },
              )
            ],
            floating: true,
            pinned: _selectedIndex == 0 ? false : true,
            snap: false,
            centerTitle: false,
          ),
        ];
      },
      body: Container(
        color: state.primaryColor,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            MainBody(),
            Category(),
            ForYou(),
            SettingsPage(),
          ],
        ),
      ),
    );
  }
}
