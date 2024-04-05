// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'package:aggressor_adventures/classes/colors.dart';
import 'package:flutter/material.dart';

import '../../../classes/aggressor_colors.dart';

class AdventureTextStyle {
  static TextStyle textPrimaryColor({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
    bool isLight = false,
    double? opacity,
  }) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 20,
        fontWeight: FontWeight.w600,
        color: isLight
            ? AggressorColors.balck.withOpacity(opacity ?? 1)
            : AggressorColors.balck.withOpacity(opacity ?? 1));
  }

  static TextStyle textPrimaryColorUndelined(
      {double? fontSize,
      FontWeight fontWeight = FontWeight.w500,
      bool isLight = false}) {
    return TextStyle(
        fontFamily: 'overpass',
        decoration: TextDecoration.underline,
        fontSize: fontSize ?? 20,
        fontWeight: FontWeight.w600,
        color: isLight ? Color(0xFF099faf) : Color(0xFF099faf));
  }

  static TextStyle textCustomColor({
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 18,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: textColor ?? Color(0xFF099faf));
  }

  static TextStyle textPrimaryColorWithRoboto(
      {double? fontSize, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
      fontFamily: 'overpass',
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF099faf),
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle textIndianRedColor(
      {double? fontSize, FontWeight? fontWeight}) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 20,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: AggressorColors.indianRed);
  }

  static TextStyle textRedColor(
      {double? fontSize,
      FontWeight fontWeight = FontWeight.w500,
      double? colorOpacity}) {
    return TextStyle(
      fontFamily: 'overpass',
      fontSize: fontSize ?? 17,
      fontWeight: FontWeight.w800,
      color: AggressorColors.red.withOpacity(colorOpacity ?? 1),
    );
  }

  static TextStyle textGreyColor({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 20,
        fontWeight: FontWeight.w600,
        color: AggressorColors.textGrey);
  }

  static TextStyle textWhiteColor({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 18,
        fontWeight: fontWeight,
        color: AggressorColors.white);
  }

  static TextStyle textBlackColor({
    double? fontSize,
    double? opacity,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 18,
        fontWeight: fontWeight,
        color: AggressorColors.balck.withOpacity(opacity ?? 1));
  }

  static TextStyle textBlackColorMontserrat({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
        fontFamily: 'montserrat',
        fontSize: fontSize ?? 18,
        fontWeight: fontWeight,
        color: AggressorColors.balck);
  }

  static TextStyle textPrimaryColorFontMontserrat({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
        fontFamily: 'montserrat',
        fontSize: fontSize ?? 30,
        fontWeight: fontWeight,
        color: Color(0xFF099faf));
  }

  static TextStyle textHintColor({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 14,
        fontWeight: FontWeight.w400,
        color: AggressorColors.hintTextColor);
  }

  static ButtonStyle bottomSheetsButtonStyle() {
    return ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
            (states) => Colors.transparent),
        padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.only(left: 38, top: 21, bottom: 21)));
  }

  static ButtonStyle noOverlayColor() {
    return ButtonStyle(
      overlayColor: MaterialStateProperty.resolveWith<Color>(
          (states) => Colors.transparent),
    );
  }

  static TextStyle textPhilippineGreyColor(
      {double? fontSize, FontWeight? fontWeight, double? opacity}) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 18,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: AggressorColors.philippineGrey.withOpacity(opacity ?? 1));
  }

  static TextStyle textDarkLiver(
      {double? fontSize, FontWeight? fontWeight, double? opacity}) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 20,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: AggressorColors.darkLiver.withOpacity(opacity ?? 1.0));
  }

  static TextStyle textQuickSilverColor({
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: AggressorColors.quickSilver);
  }

  static TextStyle textStyleForColor(
      {double? fontSize, FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontFamily: 'overpass',
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Color(0xFF099faf),
    );
  }

  static TextStyle textDarkCharcoalColor({
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
        fontFamily: 'overpass',
        fontSize: fontSize ?? 18,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: AggressorColors.darkCharcoal);
  }
}
