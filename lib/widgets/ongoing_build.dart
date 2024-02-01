import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/widgets/ongoing_cad.dart';

import '../screens/ontap_screens/ongoing_trip_screen.dart';

class OnGoingWid extends StatefulWidget {
  const OnGoingWid({super.key, this.UserInfo});
  final UserInfo;

  @override
  State<OnGoingWid> createState() => _OnGoingWidState();
}

class _OnGoingWidState extends State<OnGoingWid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.OngoingTripData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Lottie.asset('assets/animation/noDataAnime'),
            ),
          );
        } else {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(110, 158, 158, 158),
              ),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: Lottie.asset('assets/animation/carAnime.json',
                        fit: BoxFit.cover),
                  ),
                  Center(
                    heightFactor: 6,
                    child: Text(
                      '“Collect Moments, Not Things”',
                      style: GoogleFonts.tenorSans(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            );
          }
          Map<String, dynamic>? TripData = snapshot.data;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return OnGoingScreen(
                      TripData: TripData, UserInfo: widget.UserInfo);
                },
              ));
            },
            child: OngoingCard(
              TripData: TripData,
            ),
          );
        }
      },
    );
  }
}
