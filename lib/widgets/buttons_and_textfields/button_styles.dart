import 'package:flutter/material.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/constant/fonts_styles.dart';

// ignore: must_be_immutable
class CustomButtonOne extends StatelessWidget {
  CustomButtonOne({super.key, required this.onPressed, required this.text});
  void Function() onPressed;
  String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.sizeOf(context).width - 120, 45)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
            backgroundColor: MaterialStatePropertyAll(mainThemeClr)),
        onPressed: onPressed,
        child: Text(text, style: buttonStyle));
  }
}
