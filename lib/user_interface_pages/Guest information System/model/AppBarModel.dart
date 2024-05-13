import 'dart:core';

import 'package:flutter/material.dart';

class AppDrawerModel {
  int? id;
  String? title;
  bool? isSaved;
  bool? isSelected;
  String? taskStatus;
  void Function()? onTap;

  AppDrawerModel(
      {this.taskStatus,
      this.title,
      this.isSaved,
      this.onTap,
      this.isSelected,
      this.id});
}
