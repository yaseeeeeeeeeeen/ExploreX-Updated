import 'package:flutter/material.dart';
import 'package:trip_planner/constant/colors.dart';

// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:trip_planner/screens/pages/bucket_home.dart';
import 'package:trip_planner/screens/trip_adding/add_trip1.dart';
import 'package:trip_planner/widgets/ongoing_build.dart';
import 'package:trip_planner/screens/pages/botton_nav.dart';
import 'package:trip_planner/widgets/drawer.dart';
import 'package:trip_planner/widgets/titles.dart';
import 'package:trip_planner/widgets/upcoming_build.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.UserInfo, this.tripdata});
  final Map<String, dynamic>? UserInfo;
  final Map<String, dynamic>? tripdata;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return SafeArea(
        child: Scaffold(
            drawer: DrawerWid(),
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) {
                      return AddTrip1(
                        UserInfo: widget.UserInfo,
                      );
                    },
                  ));
                },
                backgroundColor: black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: white,
                )),
            body: SafeArea(
                child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitlesWid(Title: 'Ongoing Trip'),
                                Container(
                                    height: height / 4,
                                    child:
                                        OnGoingWid(UserInfo: widget.UserInfo)),
                                TitlesWid(Title: 'Upcoming Trips'),
                                Container(
                                    height: height / 5,
                                    child: UpcomingTripWid(
                                        UserInfo: widget.UserInfo)),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) {
                                        return BottomNavBar(
                                          pagenumber: 1,
                                          UserDetails: widget.UserInfo,
                                        );
                                      }));
                                    },
                                    child:
                                        BucketFHome(UserInfo: widget.UserInfo)),
                                SizedBox(
                                  height: 10,
                                )
                              ]))
                    ])))));
    // );
  }
}
