import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_planner/database/db_helper.dart';

import 'package:trip_planner/screens/pages/botton_nav.dart';

import 'package:trip_planner/widgets/continue_btn.dart';

// ignore: must_be_immutable
class AddTrip3 extends StatefulWidget {
  AddTrip3({super.key, required this.TripData, required this.UserInfo});
  final Map<String, dynamic> TripData;
  Map<String, dynamic> UserInfo;

  @override
  State<AddTrip3> createState() => _AddTrip2State();
}

class _AddTrip2State extends State<AddTrip3> {
  int isSelected = -1;
  final _formKey3 = GlobalKey<FormState>();
  List Purpose = [
    'Bussiness',
    'Family',
    'Friends',
  ];
  List<Map<String, dynamic>> companionList = [];
  final _tripnoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.black,
                size: 30,
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Your Trip.',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Start to add your trip details.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Purpose',
                  style: GoogleFonts.dmSerifDisplay(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1 / .6, crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return ChoiceChip(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      label: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: 40,
                          width: 60,
                          child: Text(Purpose[index],
                              style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 15.5, fontWeight: FontWeight.w600)),
                          alignment: Alignment.center),
                      selectedColor: Color.fromRGBO(58, 115, 2, 0.452),
                      selected: index == isSelected,
                      onSelected: (NewBoolValue) {
                        setState(() {
                          isSelected = NewBoolValue ? index : -1;
                        });
                      },
                    );
                  },
                  itemCount: Purpose.length,
                ),

                Text(
                  'Companion',
                  style: GoogleFonts.dmSerifDisplay(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 10,
                ),
                //companion adding week3 added...
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.sizeOf(context).width / 2 - 23, 50),
                            backgroundColor: Colors.black),
                        onPressed: () async {
                          final contact =
                              await FlutterContactPicker.pickPhoneContact();

                          String CompanionName = contact.fullName ?? '';
                          String CompanionNumber =
                              contact.phoneNumber?.number ?? '';
                          if (CompanionName.isNotEmpty &&
                              CompanionNumber.isNotEmpty) {
                            companionList.add({
                              "CompanionName": CompanionName,
                              "CompanionNumber": CompanionNumber,
                            });

                            print('$CompanionName==$CompanionNumber');
                            print('added ${companionList.length}');
                          } else {
                            print('List is Empty');
                          }
                        },
                        child: Text(
                          'ADD COMPANION',
                          style: GoogleFonts.dmSerifDisplay(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.sizeOf(context).width / 2 - 25, 50),
                            backgroundColor: Color.fromRGBO(59, 115, 2, 1)),
                        onPressed: () {
                          //bottom sheet -------------------------------------
                          showModalBottomSheet(
                            backgroundColor: Color.fromARGB(255, 207, 207, 207),
                            // const Color.fromRGBO(59, 115, 2, 1),
                            context: context,
                            builder: (context) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        // Check if the map at the current index is not null before accessing its properties
                                        final companion = companionList[index];
                                        //check what is constain key
                                        // ignore: unnecessary_null_comparison
                                        if (companion != null &&
                                            companion
                                                .containsKey("CompanionName") &&
                                            companion.containsKey(
                                                "CompanionNumber")) {
                                          return Container(
                                            height: 80,
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    239, 255, 255, 255),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ListTile(
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      companionList
                                                          .removeAt(index);
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  )),
                                              title: Text(
                                                  companion["CompanionName"]
                                                          ?.toUpperCase() ??
                                                      ""),
                                              subtitle: Text(companion[
                                                      "CompanionNumber"] ??
                                                  ""),
                                            ),
                                          );
                                        } else {
                                          return Container(); // Return an empty container if the companion data is null or incomplete
                                        }
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 10);
                                      },
                                      itemCount: companionList.length,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'SHOW COMPANIONS',
                          style: GoogleFonts.dmSerifDisplay(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Add your Trip Notes',
                  style: GoogleFonts.dmSerifDisplay(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black)),
                  child: Form(
                    key: _formKey3,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'ADD SOME TEXT';
                        }
                        return null;
                      },
                      controller: _tripnoteController,
                      decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                      maxLines: 10,
                      maxLength: 500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ContinueButtonWid(
                  ButtonClick: () {
                    _submitForm();
                  },
                  finish: 'Finish',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (isSelected != -1 && _formKey3.currentState!.validate()) {
      final _tripNote = _tripnoteController.text;
      final String _purpose = Purpose[isSelected];

      widget.TripData[DatabaseHelper.ColomPurpose] = _purpose;
      widget.TripData[DatabaseHelper.ColomNote] = _tripNote;
      widget.TripData[DatabaseHelper.ColumnTripUsreId] = widget.UserInfo['id'];
      print('map:-${widget.TripData}');
      print(widget.UserInfo['id']);

      // ignore: unnecessary_null_comparison
      if (widget.TripData != null) {
        await DatabaseHelper.instance
            .addTripData(widget.TripData, companionList);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return BottomNavBar(
                pagenumber: 0,
                UserDetails: widget.UserInfo,
              );
            },
          ),
          (route) => false,
        );
      } else {
        print("widget.TripData is null");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(59, 115, 2, 1),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 1),
          content: Text("COMPLETE  ALL DETAILS"),
        ),
      );
    }
  }
}
