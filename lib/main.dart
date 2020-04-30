import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/views/home.dart';
import 'core/utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    int theme = prefs.getInt('theme') ?? 1;
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        builder: (_) => ThemeNotifier(themes[theme]),
        child: MaterialApp(
          theme: themes[theme],
          title: 'reWalls',
          debugShowCheckedModeBanner: false,
          routes: {
            '/home': (context) => HomePage(),
          },
          home: HomePage(),
        ),
      ),
    );
  });
}
