import 'package:flutter/material.dart';

getFinalizedFormContainer({String? text}) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Color(0xfff1926e),
        borderRadius: BorderRadius.all(Radius.circular(5))),
    child: Text(
      text ??
          "This form has been finalized. If you need to make changes, please call your reservationist.",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
    ),
  );
}
