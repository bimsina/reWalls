import 'package:flutter/material.dart';

class GeneralScreen extends StatelessWidget {
  final Widget body;
  final String title;
  final ThemeData themeData;

  GeneralScreen({Key key, this.body, this.title, this.themeData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.primaryColor,
        title: Text(
          title,
          style: themeData.textTheme.bodyText2,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeData.accentColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: body,
    );
  }
}
