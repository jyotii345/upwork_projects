/*
File to contain the color values for custom MaterialColors for the application
 */
import 'package:flutter/material.dart';

class AggressorColors{
  static MaterialColor primaryColor = MaterialColor(0xFFC8911A, primaryColorMap);
  static MaterialColor secondaryColor = MaterialColor(0xff59a3c0, secondaryColorMap);

  static Map<int, Color> primaryColorMap = {
    50: Color.fromRGBO(200, 145, 26, .1),
    100: Color.fromRGBO(200, 145, 26, .2),
    200: Color.fromRGBO(200, 145, 26, .3),
    300: Color.fromRGBO(200, 145, 26, .4),
    400: Color.fromRGBO(200, 145, 26, .5),
    500: Color.fromRGBO(200, 145, 26, .6),
    600: Color.fromRGBO(200, 145, 26, .7),
    700: Color.fromRGBO(200, 145, 26, .8),
    800: Color.fromRGBO(200, 145, 26, .9),
    900: Color.fromRGBO(200, 145, 26, 1),
  };

  static Map<int, Color> secondaryColorMap = {
    50: Color.fromRGBO(89, 163, 192, .1),
    100: Color.fromRGBO(89, 163, 192, .2),
    200: Color.fromRGBO(89, 163, 192, .3),
    300: Color.fromRGBO(89, 163, 192, .4),
    400: Color.fromRGBO(89, 163, 192, .5),
    500: Color.fromRGBO(89, 163, 192, .6),
    600: Color.fromRGBO(89, 163, 192, .7),
    700: Color.fromRGBO(89, 163, 192, .8),
    800: Color.fromRGBO(89, 163, 192, .9),
    900: Color.fromRGBO(89, 163, 192, 1),
  };

}


