import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user_interface_pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adventure Of A Lifetime',
      theme: ThemeData(
        primarySwatch: AggressorColors.primaryColor,
      ),
      home: LoginPage(),
    );
  }
}
