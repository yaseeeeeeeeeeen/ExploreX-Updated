import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/widgets/completed_build.dart';

// ignore: must_be_immutable
class CompletedTrip extends StatelessWidget {
  CompletedTrip({super.key, this.UserData});
  final UserData;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: CompletedTripBuild(UserData: UserData)),
    );
  }
}

class CompletedWid extends StatefulWidget {
  const CompletedWid(
      {super.key,
   required this.Tripdata});
  final Tripdata;


  @override
  State<CompletedWid> createState() => _CompletedWidState();
}

class _CompletedWidState extends State<CompletedWid> {
  late DateTime date;
  late String formatedDate;

  void initState() {
    super.initState();
    date = DateFormat('yyyy-MM-dd').parse(widget.Tripdata[DatabaseHelper.ColumDateEnding]);
    formatedDate = DateFormat('MMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    double devicewidth = MediaQuery.sizeOf(context).width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 200,
            width: devicewidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.darken),
                    image: FileImage(File(widget.Tripdata[DatabaseHelper.ColumCoverPhoto])))),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.Tripdata[DatabaseHelper.columDestination],
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                SizedBox(
                  width: 80,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(formatedDate,
                    style: GoogleFonts.arsenal(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
