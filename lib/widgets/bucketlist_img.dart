import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_planner/database/db_helper.dart';

class DreamDestinationWid extends StatelessWidget {
  const DreamDestinationWid({super.key, required this.Destination});

  final Destination;
  @override
  Widget build(BuildContext context) {
    double DeviceWidth = MediaQuery.sizeOf(context).width;
    return Stack(
      children: [
        Container(
          width: DeviceWidth,
          height: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.darken),
                  fit: BoxFit.cover,
                  image: FileImage(
                      File(Destination[DatabaseHelper.destinationImg])))),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Text(
              Destination[DatabaseHelper.destination].toString().toUpperCase(),
              style: GoogleFonts.tenorSans(
                  letterSpacing: 2, fontSize: 30, color: Colors.white)),
        )
      ],
    );
  }
}
