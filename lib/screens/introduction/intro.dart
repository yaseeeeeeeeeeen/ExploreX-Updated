import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/constant/image_urls.dart';

import 'package:trip_planner/screens/loging_signup/_login_page.dart';

import '../../constant/fonts_styles.dart';

class IntroScreens extends StatefulWidget {
  const IntroScreens({super.key});

  @override
  State<IntroScreens> createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 0.6],
              colors: [white, Color.fromARGB(151, 49, 49, 49)])),
      child: Stack(
        children: [
          PageView(
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                onLastPage = (value == 2);
              });
            },
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(ImagePaths.introOne))),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(ImagePaths.introTwo))),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(ImagePaths.introThree))),
              ),
            ],
          ),
          Container(
              alignment: Alignment(0, 0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      'Skip',
                      style: buttonstyl,
                    ),
                  ),
                  SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: ColorTransitionEffect(
                          activeDotColor: white, dotColor: Colors.grey)),
                  onLastPage
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                              },
                            ), (route) => false);
                          },
                          child: Text(
                            'Done',
                            style: buttonstyl,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Text(
                            'Next',
                            style: buttonstyl,
                          ),
                        )
                ],
              ))
        ],
      ),
    );
  }
}
