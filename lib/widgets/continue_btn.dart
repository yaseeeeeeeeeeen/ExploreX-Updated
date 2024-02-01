// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        width: 200,
        child: ElevatedButton(
          onPressed: ButtonClick,
          child: Text(finish ?? continuee,
              style: GoogleFonts.tenorSans(
                  fontSize: 20, fontWeight: FontWeight.w500)),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromRGBO(59, 115, 2, 1))),
        ),
      ),
    );
  }
}
