import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:trip_planner/constant/fonts_styles.dart';
import 'package:trip_planner/constant/functions.dart';
import 'package:trip_planner/constant/image_urls.dart';
import 'package:trip_planner/constant/validations.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/loging_signup/_login_page.dart';
import 'package:trip_planner/screens/loging_signup/transition.dart';

import 'package:trip_planner/screens/pages/botton_nav.dart';
import 'package:trip_planner/widgets/buttons_and_textfields/button_styles.dart';
import 'package:trip_planner/widgets/buttons_and_textfields/text_filed.dart';
import 'package:trip_planner/widgets/image_pick.dart';
import 'package:trip_planner/widgets/snackbar/snack_bar.dart';

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
    final media = MediaQuery.sizeOf(context);
    return Scaffold(
        body: Stack(alignment: Alignment.center, children: [
      Container(
          height: media.height,
          decoration: BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.darken,
              image: DecorationImage(
                  image: AssetImage(ImagePaths.signUpBg),
                  opacity: 0.7,
                  fit: BoxFit.cover))),
      Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                  child: Lottie.asset(LottiePath.cameraLottie,
                                      repeat: false))
                              : CircleAvatar(
                                  radius: 65,
                                  backgroundImage:
                                      FileImage(File(imagefile!.path)))),
                      SizedBox(height: 40),
                      CustomTextFiledOne(
                          suffixIcon: Icons.person,
                          controller: _nameController,
                          hintText: "Username",
                          validation: (value) =>
                              Validations().nameValidation(value)),
                      SizedBox(height: 20),
                      CustomTextFiledOne(
                          suffixIcon: Icons.phone,
                          controller: _PhoneController,
                          hintText: "Phone",
                          validation: (value) =>
                              Validations().phoneNumberValidate(value),
                          keyboardType: TextInputType.number),
                      SizedBox(height: 20),
                      CustomTextFiledOne(
                        suffixIcon: Icons.email,
                        controller: _MailController,
                        hintText: "email",
                        validation: (p0) => Validations().emailValidation(p0),
                      ),
                      SizedBox(height: 20),
                      CustomTextFiledOne(
                          suffixIcon: Icons.lock,
                          controller: _passwordController,
                          hintText: "Password",
                          validation: (value) =>
                              Validations().passwordValidations(value)),
                      SizedBox(height: 40),
                      CustomButtonOne(
                          onPressed: () {
                            _submitForm();
                          },
                          text: "SignUp"),
                      SizedBox(height: media.height * 0.05),
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
                                  style: GoogleFonts.outfit(fontSize: 17),
                                  children: [
                                TextSpan(text: 'LogIn', style: font17Mcl)
                              ])))
                    ]),
              )))
    ]));
  }

//validation checking
  void _submitForm() {
    if (_formKey.currentState!.validate() && imageCheck == true) {
      addDb();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, "COMPLETE  ALL DETAILS", true));
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
      await PermissionManager.requestContactsPermission();
      await PermissionManager.requestGalleryPermission();
    Navigator.of(context).pushAndRemoveUntil(
        SizeTransitions(BottomNavBar(
          UserDetails: UserInfo,
          pagenumber: 0,
        )),
        (route) => false);
  }
}
