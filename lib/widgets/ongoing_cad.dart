import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/database/db_helper.dart';

class OngoingCard extends StatefulWidget {
  const OngoingCard({super.key, this.TripData});
  final TripData;
  @override
  State<OngoingCard> createState() => _OngoingCardState();
}

class _OngoingCardState extends State<OngoingCard> {
  late DateTime date;
  late String formatedDate;

  @override
  void initState() {
    date = DateFormat('yyyy-MM-dd')
        .parse(widget.TripData[DatabaseHelper.ColumDateEnding]);
    formatedDate = DateFormat('MMM d, y').format(date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? text1 = GoogleFonts.tenorSans(
        color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600);
    TextStyle? text2 = GoogleFonts.tenorSans(
        letterSpacing: 1,
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.w600);
    return Container(
      height: 300,
      decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.darken),
              fit: BoxFit.cover,
              image: FileImage(
                  File(widget.TripData[DatabaseHelper.ColumCoverPhoto]))),
          color: Colors.amber,
          borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.TripData[DatabaseHelper.columDestination],
                      style: text1,
                    ),
                    Text(
                      formatedDate,
                      style: text1,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '₹${widget.TripData[DatabaseHelper.ColumTripBudget]}',
                      style: text2,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
