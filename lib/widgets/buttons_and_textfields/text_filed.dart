import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFiledOne extends StatelessWidget {
  CustomTextFiledOne(
      {super.key,
      this.keyboardType,
      required this.suffixIcon,
      required this.controller,
      required this.hintText,
      required this.validation});
  TextEditingController controller;
  FormFieldValidator validation;
  String hintText;
  IconData suffixIcon;
  TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: validation,
        keyboardType: keyboardType ?? TextInputType.name,
        decoration: InputDecoration(
            suffixIcon: Icon(suffixIcon),
            suffixIconColor: Colors.black87,
            filled: true,
            fillColor: Color.fromARGB(167, 255, 255, 255),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: hintText,
            hintStyle: GoogleFonts.outfit(
              fontSize: 19,
              color: Color.fromARGB(255, 0, 0, 0),
            )));
  }
}
