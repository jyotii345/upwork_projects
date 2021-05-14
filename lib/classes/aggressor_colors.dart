/*
File to contain the color values for custom MaterialColors for the application
 */
import 'package:flutter/material.dart';

class AggressorColors{
  static MaterialColor primaryColor = MaterialColor(0xFFc78f26  , primaryColorMap);
  static MaterialColor secondaryColor = MaterialColor(0xff428cc7 , secondaryColorMap);

  static Map<int, Color> primaryColorMap = {
    50: Color.fromRGBO(199, 143, 38, .1),
    100: Color.fromRGBO(199, 143, 38, .2),
    200: Color.fromRGBO(199, 143, 38, .3),
    300: Color.fromRGBO(199, 143, 38, .4),
    400: Color.fromRGBO(199, 143, 38, .5),
    500: Color.fromRGBO(199, 143, 38, .6),
    600: Color.fromRGBO(199, 143, 38, .7),
    700: Color.fromRGBO(199, 143, 38, .8),
    800: Color.fromRGBO(199, 143, 38, .9),
    900: Color.fromRGBO(199, 143, 38, 1),
  };

  static Map<int, Color> secondaryColorMap = {
    50: Color.fromRGBO( 66, 140, 199, .1),
    100: Color.fromRGBO( 66, 140, 199, .2),
    200: Color.fromRGBO( 66, 140, 199, .3),
    300: Color.fromRGBO( 66, 140, 199 ,.4),
    400: Color.fromRGBO( 66, 140, 199, .5),
    500: Color.fromRGBO( 66, 140, 199, .6),
    600: Color.fromRGBO( 66, 140, 199, .7),
    700: Color.fromRGBO( 66, 140, 199, .8),
    800: Color.fromRGBO( 66, 140, 199, .9),
    900: Color.fromRGBO( 66, 140, 199, 1),
  };

}


