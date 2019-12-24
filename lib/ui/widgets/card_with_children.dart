import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/theme.dart';

class CardWithChildren extends StatelessWidget {
  final List<Widget> children;
  final String title;
  CardWithChildren({Key key, this.children, this.title = 'Title'})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final ThemeData state = themeNotifier.getTheme();
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: state.primaryColorDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              title,
              style: TextStyle(color: state.accentColor, fontSize: 14),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        ],
      ),
    );
  }
}
