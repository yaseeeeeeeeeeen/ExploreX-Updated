import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/database/db_helper.dart';

import 'package:trip_planner/screens/pages/botton_nav.dart';
import 'package:trip_planner/widgets/check_list.dart';
import 'package:trip_planner/widgets/image_pick.dart';
import 'package:trip_planner/widgets/titles.dart';

// ignore: must_be_immutable
class UpcomingScreen extends StatefulWidget {
  UpcomingScreen({
    super.key,
    this.userInfo,
    required this.TripInfo,
  });
  final userInfo;

  final Map<String, dynamic> TripInfo;
  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

TextEditingController NotesController = TextEditingController();

TextEditingController BudgetController = TextEditingController();
String? Notes;
String? Budget;
String? CoverPhoto;

XFile? imagefile;

class _UpcomingScreenState extends State<UpcomingScreen> {
  late bool startdateBool;
  late DateTime date1;
  late String formatedStartDate;
  late DateTime date2;
  late String formatedEndDate;
  String? formatedDate; //update time date
  late String endDate;
  late String startDate;
  File? image;
  @override
  @override
  void initState() {
    startdateBool = false;
    super.initState();
    date1 = DateFormat('yyyy-MM-dd')
        .parse(widget.TripInfo[DatabaseHelper.ColumDateStart]);
    formatedStartDate = DateFormat('MMM d, y').format(date1);
    date2 = DateFormat('yyyy-MM-dd')
        .parse(widget.TripInfo[DatabaseHelper.ColumDateEnding]);
    formatedEndDate = DateFormat('MMM d, y').format(date2);

    BudgetController.text = widget.TripInfo[DatabaseHelper.ColumTripBudget];
    NotesController.text = widget.TripInfo[DatabaseHelper.ColomNote];
    Notes = NotesController.text;
    Budget = widget.TripInfo[DatabaseHelper.ColumTripBudget];
    CoverPhoto = widget.TripInfo[DatabaseHelper.ColumCoverPhoto];
  }

  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.TripInfo[DatabaseHelper.columDestination].toUpperCase(),
          style: GoogleFonts.tenorSans(
              fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                deleteTrip(widget.TripInfo['id']);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              )),
          SizedBox(
            width: 10,
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) {
                  return BottomNavBar(
                    UserDetails: widget.userInfo,
                    pagenumber: 0,
                  );
                },
              ), (route) => false);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                  textColor: Colors.white,
                  leading: InkWell(
                    onTap: () async {
                      startdateBool = true;
                      String startDate = await updateDate();
                      setState(() {
                        formatedStartDate = startDate;
                      });
                    },
                    child: Column(children: [
                      OngoingTile(textt: '  Starting Date'),
                      OngoingTile(textt: ' ${formatedStartDate}'),
                    ]),
                  ),
                  trailing: InkWell(
                    onTap: () async {
                      startdateBool = false;
                      String endDatee = await updateDate();

                      setState(() {
                        formatedEndDate = endDatee;
                      });
                    },
                    child: Column(
                      children: [
                        OngoingTile(textt: 'Ending Date '),
                        OngoingTile(textt: '${formatedEndDate} '),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  UpdateCoverPhoto();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.sizeOf(context).width,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1), BlendMode.darken),
                          image: FileImage(File(CoverPhoto!)),
                          fit: BoxFit.cover)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  BudgetBottomSheet();
                  // noteBottomSheet();
                },
                child: DreamAmmountText(
                    leadingText: "TRIP BUDGET", TrailingText: Budget!),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 10),
                height: 300,
                width: deviceWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12),
                child: Column(
                  children: [
                    ListTile(
                      leading: Text("Notes",
                          style: GoogleFonts.tenorSans(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      trailing: TextButton.icon(
                          onPressed: () {
                            noteBottomSheet();
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 18,
                          ),
                          label: Text('Edit Notes',
                              style: GoogleFonts.tenorSans(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 200,
                      child: Text(
                        textAlign: TextAlign.center,
                        Notes!,
                        style: GoogleFonts.tenorSans(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.black,
                      fixedSize:
                          Size(MediaQuery.sizeOf(context).width / 2 - 20, 50),
                    ),
                    onPressed: () {
                      companionBottomSheet(widget.TripInfo['id']);
                    },
                    child: Text(
                      'SHOW COMPANIONS',
                      style: GoogleFonts.outfit(
                          color: white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: mainThemeClr,
                      fixedSize:
                          Size(MediaQuery.sizeOf(context).width / 2 - 20, 50),
                    ),
                    onPressed: () {
                      startClicked();
                    },
                    child: Text(
                      'START  TRIP',
                      style: GoogleFonts.outfit(
                          color: white,
                          fontSize: 19,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

//bottom sheet check list
  startClicked() {
    showModalBottomSheet(
      shape: LinearBorder(),
      context: context,
      builder: (context) {
        return CheckList(TripInfo: widget.TripInfo, userInfo: widget.userInfo);
      },
    );
  }

  //Update Cover Photo
  UpdateCoverPhoto() async {
    imagefile = await ImagePickService().pickCropImage(
        cropAspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        imageSource: ImageSource.gallery);
    if (imagefile != null) {
      final Imagepath = File(imagefile!.path);
      DatabaseHelper.instance
          .UpdateCoverPhoto(Imagepath.path, widget.TripInfo['id']);
      setState(() {
        CoverPhoto = Imagepath.path;
      });
    }
  }

  //update Dates----------------------------------------------------------------------------------------------------------
  Future<String> updateDate() async {
    DateTime? pickdate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
              primary: Colors.black,
              onSurface: Colors.black,
            )),
            child: child!,
          );
        },
        initialDate: startdateBool ? date1 : date2,
        firstDate: startdateBool ? DateTime.now() : date1,
        lastDate: DateTime(2050));
    if (pickdate != null) {
      startdateBool
          ? startDate = DateFormat('yyyy-MM-dd').format(pickdate)
          : endDate = DateFormat('yyyy-MM-dd').format(pickdate);
      formatedDate = DateFormat('MMM d, y').format(pickdate);
    }
    startdateBool
        ? await DatabaseHelper.instance.UpdateTripDates(
            startDate,
            widget.TripInfo[DatabaseHelper.ColumDateEnding],
            widget.TripInfo['id'])
        : await DatabaseHelper.instance.UpdateTripDates(
            widget.TripInfo[DatabaseHelper.ColumDateStart],
            endDate,
            widget.TripInfo['id']);

    return formatedDate!;
  }

//Update Budget
  void BudgetBottomSheet() async {
    final result = await showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tenorSans(),
                      keyboardType: TextInputType.number,
                      controller: BudgetController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  TextButton.icon(
                      onPressed: () async {
                        final Ammount = BudgetController.text;
                        await DatabaseHelper.instance
                            .UpdateBudget(Ammount, widget.TripInfo['id']);
                        Navigator.of(context).pop(Ammount);
                      },
                      icon: Icon(
                        Icons.done,
                        color: Colors.black,
                      ),
                      label: Text(
                        'SAVE AMMOUNT',
                        style: GoogleFonts.arsenal(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        Budget = result;
      });
    }
  }

// trip delete function
  void deleteTrip(int TripId) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 30, top: 20),
                  child: Text('Delete this Trip?',
                      style: GoogleFonts.dmSerifDisplay(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black)),
                ),
              ],
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    await DatabaseHelper.instance
                        .deleteTripData(widget.TripInfo['id']);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => BottomNavBar(
                              UserDetails:
                                  widget.userInfo[DatabaseHelper.coloumid],
                              pagenumber: 0,
                            )));
                  },
                  child: Text(
                    'Delete',
                    style: GoogleFonts.dmSerifDisplay(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

//bottom sheet open and edit notes
  void noteBottomSheet() async {
    final result = await showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 2, color: Colors.transparent)),
                    child: Form(
                      child: TextFormField(
                        controller: NotesController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                        maxLines: 10,
                        maxLength: 500,
                      ),
                    ),
                  ),
                  TextButton.icon(
                      onPressed: () async {
                        final notes = NotesController.text;
                        await DatabaseHelper.instance
                            .UpdateTripNotes(notes, widget.TripInfo['id']);

                        // No setState here, it's moved below after the showModalBottomSheet

                        Navigator.of(context).pop(notes);
                      },
                      icon: Icon(
                        Icons.done,
                        color: Colors.black,
                      ),
                      label: Text(
                        'SAVE NOTES',
                        style: GoogleFonts.dmSerifDisplay(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );

    // Update the UI with the new notes after the modal bottom sheet is closed
    if (result != null) {
      setState(() {
        Notes = result;
      });
    }
  }

//show companion datas in this bottom sheet
  companionBottomSheet(int TripId) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: DatabaseHelper.instance.companionTable(TripId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error${snapshot.error}');
            } else {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Container(
                  height: 350,
                  child: GestureDetector(
                    onTap: () {},
                    child: Lottie.asset(
                      'assets/animation/emptyList.json',
                    ),
                  ),
                );
              }
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> Companion = snapshot.data![index];
                        return Container(
                          height: 80,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(237, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            trailing: Container(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        callComapnion(Companion[
                                            DatabaseHelper.CompanionNumber]);
                                      },
                                      icon: Icon(
                                        Icons.call,
                                        color: Colors.green,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        companionDelete(Companion[
                                            DatabaseHelper.CompanionId]);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                            ),
                            textColor: Colors.black,
                            title: Text(
                              '${Companion[DatabaseHelper.CompanionName].toString().toUpperCase()}',
                              style: GoogleFonts.actor(),
                            ),
                            subtitle: Text(
                                '${Companion[DatabaseHelper.CompanionNumber]}'),
                          ),
                        );
                      },
                      itemCount: snapshot.data!.length,
                    );
                  },
                ),
              );
            }
          },
        );
      },
    );
  }

  callComapnion(String Number) async {
    await FlutterPhoneDirectCaller.callNumber(Number);
  }

  companionDelete(int companionId) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 30, top: 20),
                  child: Text('Delete this Companion  ?',
                      style: GoogleFonts.arsenal(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
              ],
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    DatabaseHelper.instance.deleteComapanion(companionId);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Delete',
                    style: GoogleFonts.arsenal(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.arsenal(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
