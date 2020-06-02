import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'theme.dart';

void showLoadingDialog(BuildContext context) {
  final stateData = Provider.of<ThemeNotifier>(context);
  final ThemeData state = stateData.getTheme();
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
            onWillPop: _willPopCallback,
            child: AlertDialog(
              backgroundColor: state.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              content: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Please Wait....',
                        style: state.textTheme.bodyText2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
}

Future<bool> _willPopCallback() async {
  return false;
}

void showAlertDialog(BuildContext context, String error, String title) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text('$title'),
        content: Text(error),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay', style: TextStyle(color: Colors.blue)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    },
  );
}

showConfirmationDialog(
    BuildContext context, String title, String content) async {
  bool confirm = false;

  final stateData = Provider.of<ThemeNotifier>(context);
  final ThemeData state = stateData.getTheme();
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: state.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text('$title', style: state.textTheme.bodyText2),
        content: Text(content, style: state.textTheme.bodyText1),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes', style: TextStyle(color: state.accentColor)),
            onPressed: () {
              confirm = true;
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('No', style: TextStyle(color: state.accentColor)),
            onPressed: () {
              confirm = false;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );

  return confirm;
}

showThemeChangerDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => ThemeChangerWidget(),
  );
}

class ThemeChangerWidget extends StatelessWidget {
  final List<String> string = ['Light', 'Dark', 'Amoled'];
  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<ThemeNotifier>(context);
    final ThemeData state = stateData.getTheme();

    return Theme(
      data: state.copyWith(unselectedWidgetColor: state.accentColor),
      child: AlertDialog(
          backgroundColor: state.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Text('Select Theme', style: state.textTheme.bodyText2),
          content: Container(
            width: 0.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return RadioListTile(
                  value: index,
                  groupValue: themes.indexOf(state),
                  onChanged: (ind) {
                    onThemeChanged(ind, stateData);
                  },
                  title: Text(
                    string[index],
                    style: state.textTheme.bodyText1,
                  ),
                );
              },
              itemCount: string.length,
            ),
          )),
    );
  }
}
