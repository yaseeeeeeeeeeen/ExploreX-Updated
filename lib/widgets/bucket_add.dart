import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/pages/botton_nav.dart';
import 'package:trip_planner/widgets/continue_btn.dart';
import 'package:trip_planner/widgets/image_pick.dart';
import 'package:trip_planner/widgets/textfield.dart';

// ignore: must_be_immutable
class BucketAdd extends StatefulWidget {
  BucketAdd({super.key, this.userData});
  Map<String, dynamic>? userData;
  @override
  State<BucketAdd> createState() => _BucketAddState();
}

class _BucketAddState extends State<BucketAdd> {
  bool imageCheck = false;
  File? image;
  XFile? imagefile;
  final _DestinationController = TextEditingController();
  final _AmmountController = TextEditingController();
  final _NotesController = TextEditingController();
  final _formKey4 = GlobalKey<FormState>();
  final _nestedFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                imageCheck = false;
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
              key: _formKey4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Your Destination.',
                    style: GoogleFonts.tenorSans(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Start to add your trip details.',
                    style: GoogleFonts.tenorSans(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldWid(
                      hintText: 'Enter Your Dream Destination',
                      validation: "ENTER A DESTINATION",
                      controller: _DestinationController,
                      SuffIcon: Icons.location_on),
                  SizedBox(
                    height: 10,
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
                                  color: Colors.grey,
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
                    height: 10,
                  ),
                  TextFieldWid(
                      hintText: 'Enter Ammount',
                      SuffIcon: Icons.currency_rupee,
                      controller: _AmmountController,
                      keybordType: TextInputType.number,
                      validation: 'ENTER AMMOUNT'),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Description',
                    style: GoogleFonts.tenorSans(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black)),
                    child: Form(
                      key: _nestedFormKey, // Use the new GlobalKey here
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'ADD SOME TEXT';
                          }
                          return null;
                        },
                        controller: _NotesController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: 10,
                        maxLength: 500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ContinueButtonWid(
                    ButtonClick: () {
                      _submitForm();
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_AmmountController.text.isNotEmpty &&
        imageCheck == true &&
        _DestinationController.text.isNotEmpty) {
      print('userData${widget.userData}');
      String amountText = _AmmountController.text;
      double parsedAmount = double.tryParse(amountText) ?? 0;
      Map<String, dynamic> BucketList = {
        DatabaseHelper.destinationImg: image!.path,
        DatabaseHelper.userId: widget.userData!['id'],
        DatabaseHelper.ammount: parsedAmount,
        DatabaseHelper.savings: 0,
        DatabaseHelper.destination: _DestinationController.text
      };

      print('Map==${BucketList}');

      addDb(BucketList);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) {
          return BottomNavBar(UserDetails: widget.userData, pagenumber: 1);
        },
      ), (route) => false);
      GetDatas(widget.userData!['id']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(59, 115, 2, 1),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          duration: Duration(milliseconds: 700),
          content: Text(
            "PLEASE ADD ALL DETAILS",
            style: GoogleFonts.tenorSans(fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
  }

  addDb(Map<String, dynamic> Destination) async {
    await DatabaseHelper.instance.dreamDestinationAdd(Destination);
    print('db addedddd sucssesfull');
  }

  Future<Map<String, Object?>> GetDatas(int UserId) async {
    final result = await DatabaseHelper.instance.dreamDestinationGet(UserId);
    print(result);
    return result;
  }
}
