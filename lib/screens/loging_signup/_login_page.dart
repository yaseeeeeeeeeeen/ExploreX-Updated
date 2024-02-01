import 'package:flutter/material.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/constant/fonts_styles.dart';
import 'package:trip_planner/constant/validations.dart';

import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/loging_signup/_signup_page.dart';
import 'package:trip_planner/screens/loging_signup/transition.dart';
import 'package:trip_planner/screens/pages/botton_nav.dart';
import 'package:trip_planner/widgets/buttons_and_textfields/button_styles.dart';
import 'package:trip_planner/widgets/buttons_and_textfields/text_filed.dart';
import 'package:trip_planner/widgets/snackbar/snack_bar.dart';

bool logincheck = false;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        body: SingleChildScrollView(
            child: Stack(children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/LoGIN(img).jpg'),
                  fit: BoxFit.cover),
            ),
          ),
          Container(
              // height:
              alignment: Alignment.bottomCenter,
              height: MediaQuery.sizeOf(context).height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        transperent,
                        transperent,
                        white.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.3, 1])),
              child: Container(
                  child: Form(
                      key: _formkey,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomTextFiledOne(
                                  suffixIcon: Icons.person,
                                  controller: _usernameController,
                                  hintText: "Enter your username",
                                  validation: (value) =>
                                      Validations().nameValidation(value)),
                              SizedBox(height: 20),
                              CustomTextFiledOne(
                                  suffixIcon: Icons.lock,
                                  controller: _passwordController,
                                  hintText: "Password",
                                  validation: (value) =>
                                      Validations().passwordValidations(value)),
                              SizedBox(height: 20),
                              CustomButtonOne(
                                  onPressed: () {
                                    checkLogin(context);
                                  },
                                  text: "Login"),
                              SizedBox(height: 60),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return SignUPage();
                                    }));
                                  },
                                  child: RichText(
                                      text: TextSpan(
                                          text: 'Didn’t have any account?   ',
                                          style: font17,
                                          children: [
                                        TextSpan(
                                            text: 'SignUp', style: font17Mcl)
                                      ]))),
                              SizedBox(height: 50)
                            ]),
                      ))))
        ])));
  }

// --Login and SnackBar
  Future<void> checkLogin(BuildContext ctx) async {
    final _username = _usernameController.text;
    final _password = _passwordController.text;

    final result = await DatabaseHelper.instance.login(_username, _password);

    if (result.isEmpty) {
//SnackBar
      ScaffoldMessenger.of(ctx).showSnackBar(
          customSnackBar(ctx, "USERNAME OR PASSWORD DOES' NOT MATCH", true));
    } else {
      logincheck = true;
      Navigator.of(ctx).pushAndRemoveUntil(
          SizeTransitions(BottomNavBar(UserDetails: result)), (route) => false);
      // Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (ctx) {
      //   return BottomNavBar(
      //     UserDetails: result,
      //   );
      // }));
    }
  }
}
