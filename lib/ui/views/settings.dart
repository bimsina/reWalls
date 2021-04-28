import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/utils/dialog_utils.dart';
import '../../core/utils/theme.dart';
import '../widgets/card_with_children.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin<SettingsPage> {
  @override
  bool get wantKeepAlive => true;
  String cacheSize = 'N/A';
  static const String appUrl =
          'https://play.google.com/store/apps/details?id=com.bimsina.re_walls',
      codeUrl = 'https://github.com/bimsina/reWalls',
      issuesUrl = 'https://github.com/bimsina/reWalls/issues';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final ThemeData state = themeNotifier.getTheme();

    return Container(
      color: state.primaryColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: <Widget>[
          CardWithChildren(
            title: 'Look And Feel',
            children: <Widget>[
              CustomListTile(
                title: 'Theme',
                icon: FontAwesomeIcons.palette,
                subtitle: 'Select the way you app looks.',
                onTap: () {
                  showThemeChangerDialog(context);
                },
              ),
            ],
          ),
          _supportDev(state),
        ],
      ),
    );
  }

  Widget _supportDev(ThemeData theme) {
    return CardWithChildren(
      title: 'Support Development',
      children: <Widget>[
        CustomListTile(
          icon: Icons.share,
          title: 'Share',
          subtitle: 'Share this app with your friends.',
          onTap: () => Share.share(appUrl),
        ),
        CustomListTile(
          icon: FontAwesomeIcons.github,
          title: 'GitHub',
          subtitle: 'View the source code on GitHub.',
          onTap: () => _launchURL(codeUrl),
        ),
        CustomListTile(
          icon: Icons.star,
          title: 'Rate the app',
          subtitle: 'Rate the app on Google Play.',
          onTap: () => _launchURL(appUrl),
        ),
        CustomListTile(
          icon: FontAwesomeIcons.bug,
          title: 'Report a bug',
          onTap: () => _launchURL(issuesUrl),
        ),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CustomListTile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;

  CustomListTile(
      {Key key,
      this.title = 'Title',
      this.subtitle,
      this.icon = Icons.star,
      this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final ThemeData state = themeNotifier.getTheme();

    return ListTile(
      onTap: onTap,
      dense: true,
      leading: Icon(
        icon,
        color: Color(0xff909090),
      ),
      title: Text(
        title,
        style: state.textTheme.bodyText1,
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: state.textTheme.caption,
            ),
    );
  }
}
