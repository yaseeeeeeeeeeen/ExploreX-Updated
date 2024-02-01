import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/loging_signup/_login_page.dart';
import 'package:trip_planner/screens/loging_signup/_signup_page.dart';
import 'package:trip_planner/screens/ontap_screens/terms_conditions.dart';
import 'package:trip_planner/screens/pages/botton_nav.dart';
import 'package:trip_planner/widgets/app_info.dart';
import 'package:trip_planner/widgets/help_page.dart';
import 'package:trip_planner/widgets/titles.dart';

import 'image_pick.dart';

// ignore: must_be_immutable
class DrawerWid extends StatefulWidget {
  DrawerWid({super.key, this.UserDetails});
  var UserDetails;

  @override
  State<DrawerWid> createState() => _DrawerWidState();
}

TextEditingController NameController = TextEditingController();
String? name;
TextEditingController MailController = TextEditingController();
String? mail;
TextEditingController PhoneController = TextEditingController();
String? Phone;
String? ProfilePhoto;

class _DrawerWidState extends State<DrawerWid> {
  @override
  void initState() {
    NameController.text = widget.UserDetails[DatabaseHelper.coloumname];
    name = NameController.text;
    MailController.text = widget.UserDetails[DatabaseHelper.coloumemail];
    mail = MailController.text;
    PhoneController.text =
        widget.UserDetails[DatabaseHelper.coloumPhone].toString();
    Phone = PhoneController.text;
    ProfilePhoto = widget.UserDetails[DatabaseHelper.coloumImages];
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    TextStyle color1 = GoogleFonts.tenorSans(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500);
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: height / 4,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Positioned(
                  right: 5,
                  child: IconButton(
                    onPressed: () {
                      bottomSheetEdit(widget.UserDetails, context);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  heightFactor: 1.2,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(File(
                            widget.UserDetails[DatabaseHelper.coloumImages])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.UserDetails[DatabaseHelper.coloumname]
                            .toUpperCase(),
                        style: color1,
                      ),
                      Text(widget.UserDetails[DatabaseHelper.coloumemail],
                          style: GoogleFonts.tenorSans(
                              color: Colors.white, fontWeight: FontWeight.w500))
                    ],
                  ),
                )
              ],
            ),
            DrawerTile(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) {
                      return BottomNavBar(
                          UserDetails: widget.UserDetails, pagenumber: 2);
                    },
                  ), (route) => false);
                },
                iconn: Icons.donut_small_rounded,
                texxt: 'Dashbord'),
            DrawerTile(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) {
                      return BottomNavBar(
                          UserDetails: widget.UserDetails, pagenumber: 3);
                    },
                  ), (route) => false);
                },
                iconn: Icons.done_all,
                texxt: 'Completed Trips'),
            DrawerTile(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) {
                      return BottomNavBar(
                          UserDetails: widget.UserDetails, pagenumber: 1);
                    },
                  ), (route) => false);
                },
                iconn: Icons.flight,
                texxt: 'Draem Trip'),
            DrawerTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return AppInfo();
                    },
                  ));
                },
                iconn: Icons.info,
                texxt: 'App info'),
            DrawerTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return TermsAndCondition();
                    },
                  ));
                },
                iconn: Icons.receipt_long,
                texxt: 'Terms & Conditions'),
            DrawerTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return HelpPage(UserInfo: widget.UserDetails);
                    },
                  ));
                },
                iconn: Icons.live_help,
                texxt: 'How to Use'),
            DrawerTile(
                onTap: () {
                  signoutConfirmation(context);
                },
                colrr: Colors.red,
                iconn: Icons.logout,
                texxt: 'SignOut'),
          ],
        ),
      ),
    );
  }

  signoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 30, top: 20),
                  child: Text('Logout your account',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ),
              ],
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.LogOutUser();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    'Logout',
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 20)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  bottomSheetEdit(dynamic UserData, BuildContext context) {
    TextStyle font1 = GoogleFonts.tenorSans(
        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 5,
                    child: IconButton(
                      onPressed: () {
                        saveButton();
                      },
                      icon: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    // heightFactor: 1.2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                            onTap: () {
                              UpdatePhoto();
                            },
                            child: CircleAvatar(
                              radius: 90,
                              backgroundImage: FileImage(File(ProfilePhoto!)),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            controller: NameController,
                            textAlign: TextAlign.center,
                            style: font1),
                        TextFormField(
                            controller: MailController,
                            textAlign: TextAlign.center,
                            style: font1),
                        TextFormField(
                            controller: PhoneController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.phone,
                            style: font1),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  UpdatePhoto() async {
    imagefile = await ImagePickService().pickCropImage(
        cropAspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        imageSource: ImageSource.gallery);
    if (imagefile != null) {
      final Imagepath = File(imagefile!.path);
      setState(() {
        ProfilePhoto = Imagepath.path;
      });
    }
  }

  saveButton() async {
    // Make a copy of widget.UserDetails
    Map<String, dynamic> updatedUserDetails = Map.from(widget.UserDetails);

    // Update the fields in the copy
    updatedUserDetails[DatabaseHelper.coloumname] = NameController.text;
    updatedUserDetails[DatabaseHelper.coloumemail] = MailController.text;
    updatedUserDetails[DatabaseHelper.coloumPhone] = PhoneController.text;
    updatedUserDetails[DatabaseHelper.coloumImages] = ProfilePhoto;

    // Save the updated data
    await DatabaseHelper.instance
        .UpdateUserData(updatedUserDetails, widget.UserDetails['id']);

    // Update the widget's UserDetails with the modified map (optional)
    setState(() {
      widget.UserDetails = updatedUserDetails;
    });
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) {
        return BottomNavBar(
          UserDetails: updatedUserDetails,
        );
      },
    ), (route) => false);
  }
}
