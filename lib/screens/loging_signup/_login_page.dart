import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/constant/fonts_styles.dart';

import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/loging_signup/_signup_page.dart';
import 'package:trip_planner/screens/loging_signup/transition.dart';
import 'package:trip_planner/screens/pages/botton_nav.dart';

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
                        black,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.3, 1])),
              child: Container(
                  child: Form(
                      key: _formkey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.person),
                                        suffixIconColor: black,
                                        filled: true,
                                        fillColor: Color(0x5AFFFFFF),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        hintText: "Enter your username",
                                        hintStyle: GoogleFonts.tenorSans(
                                            color: Color.fromARGB(
                                                150, 235, 235, 235),
                                            fontWeight: FontWeight.w500)))),
                            SizedBox(height: 20),
                            Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.security),
                                        suffixIconColor: Colors.black87,
                                        filled: true,
                                        fillColor: Color(0x5AFFFFFF),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        hintText: "Enter password here",
                                        hintStyle: GoogleFonts.tenorSans(
                                            color: Color.fromARGB(
                                                150, 235, 235, 235),
                                            fontWeight: FontWeight.w500)))),
                            SizedBox(height: 20),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(mainThemeClr),
                                  minimumSize:
                                      MaterialStateProperty.all(Size(150, 40)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                                onPressed: () {
                                  checkLogin(context);
                                },
                                child: Text('Login', style: buttonLog)),
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
                                      TextSpan(text: 'SignUp', style: font17Mcl)
                                    ]))),
                            SizedBox(height: 50)
                          ]))))
        ])));
  }

// --Login and SnackBar
  Future<void> checkLogin(BuildContext ctx) async {
    final _username = _usernameController.text;
    final _password = _passwordController.text;

    final result = await DatabaseHelper.instance.login(_username, _password);

    if (result.isEmpty) {
//SnackBar
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          backgroundColor: Color.fromRGBO(59, 115, 2, 1),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          duration: Duration(milliseconds: 700),
          content: Text("User OR PASSWORD DOES' NOT MATCH")));
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
