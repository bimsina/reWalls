import 'package:flutter/material.dart';

enum kdataFetchState { IS_LOADING, IS_LOADED, ERROR_ENCOUNTERED }

const Color lightThemePrimaryColor = Color(0xffFFFFFF);
const Color lightThemePrimaryColorDark = Color(0xffE5EBF0);
const Color lightThemeAccentColor = Color(0xff5B37B7);

const Color darkThemePrimaryColor = Color(0xff212121);
const Color darkThemePrimaryColorDark = Color(0xff2B2B2B);
const Color darkThemeAccentColor = Color(0xff68F0AE);

const Color amoledThemePrimaryColor = Color(0xff000000);
const Color amoledThemePrimaryColorDark = Color(0xff2B2B2B);
const Color amoledThemeAccentColor = Color(0xff68F0AE);

final List<ThemeData> themes = [lightTheme, darkTheme, amoledTheme];

const List<Color> cardColors = [
  Color(0xffadb6c6),
  Color(0xff963e63),
  Color(0xffe6a542),
  Color(0xff519b89),
  Color(0xffab8c67),
  Color(0xffde34a0),
  Color(0xff5a9def),
  Color(0xfff4663c),
  Color(0xffa9c95a),
];

final darkTheme = ThemeData(
  primaryColor: darkThemePrimaryColor,
  primaryColorDark: darkThemePrimaryColorDark,
  accentColor: darkThemeAccentColor,
  canvasColor: Colors.transparent,
  primaryIconTheme: IconThemeData(color: Colors.white),
  textTheme: TextTheme(
    headline5: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 24),
    bodyText2: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 18),
    bodyText1: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 16),
    caption: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 13),
  ),
);

final amoledTheme = ThemeData(
  primaryColor: amoledThemePrimaryColor,
  primaryColorDark: amoledThemePrimaryColorDark,
  accentColor: amoledThemeAccentColor,
  canvasColor: Colors.transparent,
  primaryIconTheme: IconThemeData(color: Colors.white),
  textTheme: TextTheme(
    headline5: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 24),
    bodyText2: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 18),
    bodyText1: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 16),
    caption: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 13),
  ),
);

final lightTheme = ThemeData(
  primaryColorDark: lightThemePrimaryColorDark,
  primaryColor: lightThemePrimaryColor,
  accentColor: lightThemeAccentColor,
  canvasColor: Colors.transparent,
  primaryIconTheme: IconThemeData(color: Colors.black),
  textTheme: TextTheme(
    headline5: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 24),
    bodyText2: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 18),
    bodyText1: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 16),
    caption: TextStyle(
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 13),
  ),
);

const List<String> phoneResolutions = [
  "1080x1920",
  "750x1334",
  "2960x1440",
  "640x1136",
  "1440x2560",
  "640x960",
  "720x1280",
  "1920x1080",
  "800x1280",
  "480x800",
  "768x1280",
  "800x480",
  "828x1792",
  "854x480",
  "960x540",
  "1125x2436",
  "1242x2688",
  "1280x720",
  "2560x1440",
];
