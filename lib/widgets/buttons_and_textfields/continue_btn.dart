// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_planner/constant/colors.dart';

class ContinueButtonWid extends StatelessWidget {
  ContinueButtonWid({super.key, this.finish, required this.ButtonClick});
  String? finish;
  String continuee = 'Continue';
  final Function()? ButtonClick;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: MediaQuery.sizeOf(context).width,
        child: ElevatedButton(
          onPressed: ButtonClick,
          child: Text(finish ?? continuee,
              style: GoogleFonts.outfit(
                  fontSize: 20, fontWeight: FontWeight.w500, color: white)),
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              backgroundColor: MaterialStatePropertyAll(mainThemeClr)),
        ),
      ),
    );
  }
}
