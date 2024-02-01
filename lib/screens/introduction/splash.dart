import 'package:flutter/material.dart';
import 'package:trip_planner/constant/image_urls.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/introduction/intro.dart';

import '../pages/botton_nav.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Map<String, dynamic>? UserInfo;
  LoginCheck(BuildContext context) async {
    await Duration(seconds: 2);
    Map<String, dynamic>? User = await DatabaseHelper.instance.getuserLoged();
    if (User != null) {
      UserInfo = User;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => IntroScreens()),
          (route) => false);
    } else {
      UserInfo = null;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => BottomNavBar(UserDetails: UserInfo)),
          (route) => false);
    }
  }

  @override
  void initState() {
    LoginCheck(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        height: media.height,
        width: media.width,
        child: Center(
          child: Container(
            height: media.height / 3,
            width: media.width / 2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImagePaths.splashBgRemovedIcon),
                    fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}
