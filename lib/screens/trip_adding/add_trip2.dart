import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/trip_adding/add_trip3.dart';

import 'package:trip_planner/widgets/buttons_and_textfields/continue_btn.dart';
import 'package:trip_planner/widgets/image_pick.dart';
import 'package:trip_planner/widgets/textfield.dart';

// ignore: must_be_immutable
class AddTrip2 extends StatefulWidget {
  AddTrip2({super.key, required this.TripData, required this.UserInfo});
  final Map<String, dynamic> TripData;
  Map<String, dynamic> UserInfo;

  @override
  State<AddTrip2> createState() => _AddTrip2State();
}

XFile? imagefile;

bool imageCheck = false;

class _AddTrip2State extends State<AddTrip2> {
  List Transportaions = ['Bus', 'Train', 'Car', 'Flight', 'Ship', 'Bike'];
  int isSelected = -1;
  File? image;
  final _budgetController = TextEditingController();
  final _formKey2 = GlobalKey<FormState>();
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
            child: Form(
              key: _formKey2,
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
                  TextFieldWid(
                      keybordType: TextInputType.number,
                      hintText: 'Enter Your Budget',
                      validation: "ENTER YOUR BUDGET",
                      controller: _budgetController,
                      SuffIcon: Icons.currency_rupee),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () async {
                        imagefile = await ImagePickService().pickCropImage(
                            cropAspectRatio:
                                CropAspectRatio(ratioX: 16, ratioY: 9),
                            imageSource: ImageSource.gallery);
                        if (imagefile != null) {
                          imageCheck = true;
                        }

                        final Imagepath = File(imagefile!.path);

                        setState(() {
                          this.image = Imagepath;
                        });
                      },
                      child: !imageCheck
                          ? Container(
                              child: Center(
                                child: Text(
                                  "ADD A COVER PHOTO",
                                  style: GoogleFonts.josefinSans(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              height: 200,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  border: Border.all(color: borderSide),
                                  color: white,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          : Container(
                              height: 200,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(File(imagefile!.path))),
                                  borderRadius: BorderRadius.circular(10)),
                            )),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Transportation',
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1 / .5, crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return ChoiceChip(
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 30,
                            width: 30,
                            child: Text(Transportaions[index],
                                style: GoogleFonts.outfit(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                            alignment: Alignment.center),
                        selectedColor: Color.fromRGBO(58, 115, 2, 0.452),
                        selected: index == isSelected,
                        showCheckmark: false,
                        onSelected: (NewBoolValue) {
                          setState(() {
                            isSelected = NewBoolValue ? index : -1;
                          });
                        },
                      );
                    },
                    itemCount: Transportaions.length,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ContinueButtonWid(
                    ButtonClick: () {
                      _submitForm();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey2.currentState!.validate() &&
        imageCheck == true &&
        isSelected != -1) {
      //mapp illekk add cheyyunnu
      final _budget = _budgetController.text;
      final _transportion = Transportaions[isSelected];
      final _imagePath = imagefile!.path;
      //set in map
      widget.TripData[DatabaseHelper.ColomTransportion] = _transportion;
      widget.TripData[DatabaseHelper.ColumCoverPhoto] = _imagePath;
      widget.TripData[DatabaseHelper.ColumTripBudget] = _budget;
      print(widget.TripData);
      //push next page
      imageCheck = false;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return AddTrip3(
            UserInfo: widget.UserInfo,
            TripData: widget.TripData,
          );
        },
      ));

      // _formKey.currentState?.save();    ===?? nthannn ariellaaa nokkanam...
      // Perform any further actions with the password data here
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
