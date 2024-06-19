import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/colors.dart';
import 'package:flutter/material.dart';

class AggressorButton extends StatelessWidget {
  const AggressorButton(
      {Key? key,
      required this.buttonName,
      this.onPressed,
      this.width,
      this.height,
      this.AggressorButtonColor,
      this.AggressorTextColor,
      this.boxBorder,
      this.fontSize,
      this.fontWeight,
      this.leftPadding})
      : super(key: key);
  final VoidCallback? onPressed;
  final String buttonName;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? AggressorButtonColor;
  final Color? AggressorTextColor;
  final BoxBorder? boxBorder;
  final double? leftPadding;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: AggressorButtonColor ?? Color(0xfff1926e),
            borderRadius: BorderRadius.circular(6),
            border: boxBorder),
        width: width,
        height: height ?? 50,
        child: Center(
            child: Padding(
          padding: EdgeInsets.only(left: leftPadding ?? 0),
          child: Text(
            buttonName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: AggressorTextColor,
            ),
          ),
        )),
      ),
    );
  }
}
