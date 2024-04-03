import 'dart:io';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:aggressor_adventures/classes/colors.dart';

import '../model/masterModel.dart';

class AdventureFormField extends StatelessWidget {
  const AdventureFormField({
    Key? key,
    this.maxLength,
    this.maxLines,
    this.suffixIcon,
    this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.isRequired = false,
    this.readOnly = false,
    this.textInputType,
    this.onChanged,
    this.onTap,
    this.prefixText,
    this.initialValue,
    this.isHintTextColorsPrimary = false,
    this.suffix,
    this.fontSize,
    this.fontWeight,
    this.textFiledBG,
    this.contentPadding,
    this.textInputAction,
    this.focusNode,
    this.hintTextStyle,
  }) : super(key: key);
  final Function()? onTap;
  final int? maxLength;
  final Widget? suffixIcon;
  final bool isRequired;
  final String? hintText;
  final String? labelText;

  final bool readOnly;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final Function(String)? onChanged;
  final String? prefixText;
  final String? initialValue;
  final bool isHintTextColorsPrimary;
  final int? maxLines;
  final Color? textFiledBG;
  final Widget? suffix;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextStyle? hintTextStyle;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      initialValue: initialValue,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly,
      focusNode: focusNode,
      textCapitalization: TextCapitalization.sentences,
      cursorHeight: Platform.isIOS ? 12 : 19,
      cursorColor: AggressorColors.balck,
      maxLength: maxLength,
      keyboardType: textInputType,
      maxLines: maxLines,
      textInputAction: textInputAction ?? TextInputAction.done,
      style: AdventureTextStyle.textPrimaryColor(fontSize: fontSize ?? 12),
      decoration: InputDecoration(
        alignLabelWithHint: maxLines != null ? true : false,
        prefixText: prefixText,
        prefixStyle: AdventureTextStyle.textPrimaryColor(
            fontSize: fontSize ?? 14, fontWeight: FontWeight.w300),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: contentPadding ?? EdgeInsets.only(left: 25),
        counterText: '',
        suffix: suffix,
        fillColor: textFiledBG ?? AggressorColors.textFieldBG,
        filled: true,
        hintText: hintText,
        labelStyle: AdventureTextStyle.textHintColor(),
        hintStyle: hintTextStyle != null
            ? hintTextStyle
            : isHintTextColorsPrimary
                ? AdventureTextStyle.textPrimaryColor(fontSize: fontSize ?? 14)
                : AdventureTextStyle.textHintColor(fontSize: fontSize ?? 14),
        suffixIcon: suffixIcon,
        label: labelText != null || isRequired
            ? RichText(
                text: TextSpan(
                    text: labelText,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: fontSize ?? 14,
                        fontWeight: fontWeight),
                    children: [
                      isRequired
                          ? const TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: AggressorColors.indianRed,
                              ),
                            )
                          : const TextSpan()
                    ]),
              )
            : null,
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: AggressorColors.textFieldBG, width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: AggressorColors.textFieldBG, width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: AggressorColors.textFieldBG, width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
    );
  }
}
