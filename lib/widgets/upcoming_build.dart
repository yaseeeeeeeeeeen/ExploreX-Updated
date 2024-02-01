import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/ontap_screens/upcoming_screen.dart';
import 'package:trip_planner/screens/trip_adding/add_trip1.dart';
import 'package:trip_planner/widgets/upcoming_trip.dart';

class UpcomingTripWid extends StatefulWidget {
  const UpcomingTripWid({super.key, this.UserInfo});
  final Map<String, dynamic>? UserInfo;
  @override
  State<UpcomingTripWid> createState() => _UpcomingTripWidState();
}

class _UpcomingTripWidState extends State<UpcomingTripWid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.readUpcomingTrips(widget.UserInfo?['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Erorr:${snapshot.error}');
        } else {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return AddTrip1(
                      UserInfo: widget.UserInfo,
                    );
                  },
                ));
              },
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "NO UPCOMING TRIPS",
                        style: GoogleFonts.marcellusSc(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "ADD A TRIP ➔",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: borderSide),
                  borderRadius: BorderRadius.circular(10),
                  color: white,
                ),
                padding: EdgeInsets.all(10),
                width: MediaQuery.sizeOf(context).width,
              ),
            );
          }
          return ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Map<String, dynamic> Tripdata = snapshot.data![index];

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return UpcomingScreen(
                          TripInfo: Tripdata,
                          userInfo: widget.UserInfo,
                        );
                      },
                    ));
                  },
                  child: UpcomingWid(
                    startdate: Tripdata[DatabaseHelper.ColumDateStart],
                    ImagePath: Tripdata[DatabaseHelper.ColumCoverPhoto],
                    place: Tripdata[DatabaseHelper.columDestination],
                  ),
                );
              },
              itemCount: snapshot.data!.length);
        }
      },
    );
  }
}
