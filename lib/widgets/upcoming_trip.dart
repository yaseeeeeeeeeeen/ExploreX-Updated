import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UpcomingWid extends StatefulWidget {
  UpcomingWid(
      {super.key,
      required this.ImagePath,
      required this.startdate,
      required this.place});
  final String ImagePath;
  final String startdate;
  final String place;

  @override
  State<UpcomingWid> createState() => _UpcomingWidState();
}

class _UpcomingWidState extends State<UpcomingWid> {
  late DateTime date;
  late String formatedDate;

  @override
  @override
  void initState() {
    super.initState();
    date = DateFormat('yyyy-MM-dd').parse(widget.startdate);
    formatedDate = DateFormat('MMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    double devicewidth = MediaQuery.sizeOf(context).width;
    return Stack(
      children: [
        Container(
          height: 200,
          width: devicewidth / 2 + 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4), BlendMode.darken),
                  fit: BoxFit.cover,
                  image: FileImage(File(widget.ImagePath)))),
        ),
        Container(
          width: devicewidth / 2 + 80,
          margin: EdgeInsets.only(top: 15, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.place.toUpperCase(),
                  style: GoogleFonts.tenorSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
              Text(
                '${formatedDate}      ',
                style: GoogleFonts.arsenal(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
