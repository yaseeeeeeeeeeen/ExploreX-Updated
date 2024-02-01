import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/loging_signup/_login_page.dart';
import 'package:trip_planner/screens/loging_signup/transition.dart';

import 'package:trip_planner/screens/pages/botton_nav.dart';
import 'package:trip_planner/widgets/image_pick.dart';

class SignUPage extends StatefulWidget {
  SignUPage({super.key});
  @override
  State<SignUPage> createState() => _SignUPageState();
}

final _formKey = GlobalKey<FormState>();
XFile? imagefile;
bool imageCheck = false;

class _SignUPageState extends State<SignUPage> {
  final _nameController = TextEditingController();
  final _PhoneController = TextEditingController();
  final _MailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(alignment: Alignment.center, children: [
      Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: AssetImage('assets/images/signUpIMG.jpg'),
                  opacity: 0.7,
                  fit: BoxFit.cover))),
      Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    GestureDetector(
                        onTap: () async {
                          imagefile = await ImagePickService().pickCropImage(
                              cropAspectRatio:
                                  CropAspectRatio(ratioX: 1, ratioY: 1),
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
                            ? CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(214, 190, 190, 190),
                                radius: 65,
                                child: Lottie.asset(
                                    'assets/animation/profileLottie.json'))
                            : CircleAvatar(
                                radius: 65,
                                backgroundImage:
                                    FileImage(File(imagefile!.path)))),
                    SizedBox(height: 40),
                    TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          final nameRegex = RegExp(r'^[a-zA-Z -]{1,}$');
                          if (!nameRegex.hasMatch(value!)) {
                            return 'Please enter a valid name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelStyle: GoogleFonts.tenorSans(
                                fontSize: 19,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500),
                            suffixIcon: Icon(Icons.person),
                            suffixIconColor: Colors.black87,
                            filled: true,
                            fillColor: Color.fromARGB(57, 255, 255, 255),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15)),
                            hintText: " Name",
                            hintStyle: GoogleFonts.tenorSans(
                                fontSize: 19,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500))),
                    SizedBox(height: 20),
                    TextFormField(
                        controller: _PhoneController,
                        validator: (value) {
                          final phoneRegex = RegExp(
                            r'^\+?[0-9]{10}$',
                          );
                          if (!phoneRegex.hasMatch(value!)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.phone),
                            suffixIconColor: Colors.black87,
                            filled: true,
                            fillColor: Color.fromARGB(57, 255, 255, 255),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15)),
                            hintText: "  Phone",
                            hintStyle: GoogleFonts.tenorSans(
                                fontSize: 19,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500))),
                    SizedBox(height: 20),
                    TextFormField(
                        controller: _MailController,
                        validator: (value) {
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegex.hasMatch(value!)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.mail),
                            suffixIconColor: Colors.black87,
                            filled: true,
                            fillColor: Color.fromARGB(57, 255, 255, 255),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "  Mail",
                            hintStyle: GoogleFonts.tenorSans(
                                fontSize: 19,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500))),
                    SizedBox(height: 20),
                    TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          // Define the regex pattern for password validation
                          final passwordRegex = RegExp(r'^.{8,}$');
                          if (!passwordRegex.hasMatch(value!)) {
                            return 'Password must be 8 characters long';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.lock_sharp),
                            suffixIconColor: Colors.black87,
                            filled: true,
                            fillColor: Color.fromARGB(57, 255, 255, 255),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "  Password",
                            hintStyle: GoogleFonts.tenorSans(
                                fontSize: 19,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500))),
                    SizedBox(height: 40),
                    ElevatedButton(
                        style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(Size(150, 40)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromRGBO(58, 115, 2, 1))),
                        onPressed: () {
                          _submitForm();
                        },
                        child: Text('SignUp',
                            style: GoogleFonts.tenorSans(
                                fontSize: 21,
                                color:
                                    const Color.fromARGB(211, 255, 255, 255)))),
                    SizedBox(height: 150),
                    GestureDetector(
                        onTap: () {
                          imageCheck = false;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }), (route) => false);
                        },
                        child: RichText(
                            text: TextSpan(
                                text: 'You have any account?   ',
                                style: GoogleFonts.tenorSans(fontSize: 17),
                                children: [
                              TextSpan(
                                  text: 'LogIn',
                                  style: GoogleFonts.tenorSans(
                                      color: Color.fromRGBO(120, 197, 43, 1),
                                      fontWeight: FontWeight.w700))
                            ])))
                  ])))
    ])));
  }

//validation checking
  void _submitForm() {
    if (_formKey.currentState!.validate() && imageCheck == true) {
      addDb();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(59, 115, 2, 1),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          duration: Duration(milliseconds: 700),
          content: Text("COMPLETE  ALL DETAILS"),
        ),
      );
    }
  }

//databse adding function
  addDb() async {
    final _username = _nameController.text.trim();
    final _phone = _PhoneController.text.trim();
    final _email = _MailController.text.trim();
    final _password = _passwordController.text.trim();
    final imagePath = imagefile!.path;
    // ignore: unused_local_variable
    int? IsLogin;

    //map ilekkk vekkkunnu

    Map<String, dynamic> userDetails = {
      DatabaseHelper.coloumPhone: _phone,
      DatabaseHelper.coloumemail: _email,
      DatabaseHelper.coloumname: _username,
      DatabaseHelper.coloumpassword: _password,
      DatabaseHelper.coloumImages: imagePath,
      DatabaseHelper.coloumIsLogin: IsLogin = 1
    };
    //database adding
    await DatabaseHelper.instance.insertRecords(userDetails);
    //added values Printing...
    var dbQuery = await DatabaseHelper.instance.queryDatabase();
    print(dbQuery);
    imageCheck = false;
//UserDetials Getting Firm DataBase
    var UserInfo = await DatabaseHelper.instance.getuserLoged();

    Navigator.of(context).pushAndRemoveUntil(
        SizeTransitions(BottomNavBar(
          UserDetails: UserInfo,
          pagenumber: 0,
        )),
        (route) => false);
  }
}
