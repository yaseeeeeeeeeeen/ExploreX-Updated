import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/widgets/images_build.dart';
import 'package:trip_planner/widgets/show_companion.dart';
import 'package:trip_planner/widgets/titles.dart';

class CompletedTripTap extends StatefulWidget {
  const CompletedTripTap({super.key, required this.TripData});
  final TripData;

  @override
  State<CompletedTripTap> createState() => _CompletedTripTapState();
}

class _CompletedTripTapState extends State<CompletedTripTap> {
  late DateTime date1;
  late String formatedStartDate;
  late DateTime date2;
  late String formatedEndDate;
  @override
  void initState() {
    date1 = DateFormat('yyyy-MM-dd')
        .parse(widget.TripData[DatabaseHelper.ColumDateStart]);
    formatedStartDate = DateFormat('MMM d, y').format(date1);
    date2 = DateFormat('yyyy-MM-dd')
        .parse(widget.TripData[DatabaseHelper.ColumDateEnding]);
    formatedEndDate = DateFormat('MMM d, y').format(date2);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.TripData[DatabaseHelper.columDestination],
          style: GoogleFonts.tenorSans(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: FileImage(File(
                            widget.TripData[DatabaseHelper.ColumCoverPhoto])))),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                  textColor: Colors.white,
                  leading: Column(children: [
                    OngoingTile(textt: '  Started Date'),
                    OngoingTile(textt: formatedStartDate),
                  ]),
                  trailing: Column(
                    children: [
                      OngoingTile(textt: 'Ended Date '),
                      OngoingTile(textt: formatedEndDate),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  showExpense(widget.TripData['id']);
                },
                child: DreamAmmountText(
                    leadingText: 'Trip Expense',
                    TrailingText:
                        widget.TripData[DatabaseHelper.ColumTripBudget]),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(top: 10),
                  height: 250,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(143, 158, 158, 158),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(children: [
                    ListTile(
                      title: Text('- NOTES -',
                          style: GoogleFonts.tenorSans(
                              fontSize: 25, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center),
                    ),
                    Text(
                      widget.TripData[DatabaseHelper.ColomNote],
                      style: GoogleFonts.arsenal(
                          fontStyle: FontStyle.italic, fontSize: 15),
                    )
                  ])),
              ListTile(
                title: Text('MEMMORIES',
                    style: GoogleFonts.abhayaLibre(
                        fontSize: 30, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
              ),
              Container(
                child: ImagesGrid(TripData: widget.TripData),
              ),
              SizedBox(
                height: 5,
              ),
              ShowCompanion(TripID: widget.TripData['id']),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      )),
    );
  }

  showExpense(int TripId) async {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 260,
          color: Colors.amber,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: height / 8 - 10,
                      color: Colors.green,
                      width: width / 2 - 10,
                    ),
                    Container(
                      height: height / 8 - 10,
                      color: Colors.grey,
                      width: width / 2 - 10,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: height / 8 - 10,
                      color: Colors.red,
                      width: width / 2 - 10,
                    ),
                    Container(
                      height: height / 8 - 10,
                      color: Colors.blue,
                      width: width / 2 - 10,
                    )
                  ],
                )
              ]),
        );
      },
    );
  }
}
