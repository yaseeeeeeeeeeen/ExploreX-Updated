import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldWid extends StatelessWidget {
  TextFieldWid(
      {super.key,
      required this.hintText,
      required this.SuffIcon,
      this.validation,
      this.controller,
      this.keybordType,
      this.ontap,
      this.enabled,
      this.readOnly});

  //-------------------------------------
  TextEditingController? controller;
  String? validation;
  final String hintText;
  final IconData SuffIcon;
  TextInputType? keybordType;
  Function()? ontap;
  bool? readOnly;
  bool? enabled;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return validation;
          }
          return null;
        },
        readOnly: readOnly==true?true:false,
        keyboardType: keybordType,
        enabled: enabled,
        onTap: ontap ?? () {},
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black)),
            labelText: hintText,
            suffixIcon: Icon(
              SuffIcon,
              color: Colors.black,
            ),
            hintText: hintText,
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black))),
      ),
    );
  }
}

// ignore: must_be_immutable


