import 'package:flutter/material.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/constant/fonts_styles.dart';

SnackBar customSnackBar(constext, String messege, bool error) {
  return SnackBar(
      backgroundColor: error ? Colors.red.shade700 : mainThemeClr,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(10),
      duration: Duration(milliseconds: 700),
      content: Text(messege, style: normalOutfit));
}
