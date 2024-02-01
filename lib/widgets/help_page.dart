import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trip_planner/screens/pages/botton_nav.dart';

class HelpPage extends StatefulWidget {
  HelpPage({super.key, this.UserInfo});
  final Map<String, dynamic>? UserInfo;
  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  TextStyle buttonstyl = GoogleFonts.dmSerifDisplay(
      color: Colors.white, fontSize: 20, decoration: TextDecoration.none);

  PageController _controller = PageController();
  bool SelectLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'How to Use',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height / 1.3,
                width: MediaQuery.sizeOf(context).width,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  controller: _controller,
                  onPageChanged: (value) {
                    setState(() {
                      SelectLastPage = (value == 3);
                    });
                  },
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 2, 2, 1),
                          image: DecorationImage(
                              image: AssetImage('assets/images/14.jpg'),
                              fit: BoxFit.fill)),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 2, 2, 1),
                          image: DecorationImage(
                              image: AssetImage('assets/images/12.jpg'),
                              fit: BoxFit.fill)),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 2, 2, 1),
                          image: DecorationImage(
                              image: AssetImage('assets/images/13.jpg'),
                              fit: BoxFit.fill)),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 2, 2, 1),
                          image: DecorationImage(
                              image: AssetImage('assets/images/11.jpg'),
                              fit: BoxFit.fill)),
                    ),
                  ],
                ),
              ),
              Container(
                  alignment: Alignment(0, 0.80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () {
                            _controller.jumpToPage(3);
                          },
                          child: Text(
                            'Skip',
                            style: buttonstyl,
                          )),
                      SmoothPageIndicator(
                          controller: _controller,
                          count: 4,
                          effect: ColorTransitionEffect(
                              activeDotColor: Colors.black87,
                              dotColor: Colors.grey)),
                      SelectLastPage
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return BottomNavBar(
                                        pagenumber: 0,
                                        UserDetails: widget.UserInfo);
                                  },
                                ), (route) => false);
                              },
                              child: Text(
                                'Done',
                                style: buttonstyl,
                              ))
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              onPressed: () {
                                _controller.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              },
                              child: Text(
                                'Next',
                                style: buttonstyl,
                              )),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
