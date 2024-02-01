import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/ontap_screens/completed_page.dart';
import 'package:trip_planner/screens/pages/completed_card.dart';


class CompletedTripBuild extends StatelessWidget {
  const CompletedTripBuild({super.key, required this.UserData});
  final UserData;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.readCompledTrips(UserData['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Erorr${snapshot.error}');
        } else {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Container(
                height: 500,
                child: Lottie.asset('assets/animation/noDataAnime.json'),
              ),
            );
          }
        }

        return ListView.separated(
            itemBuilder: (context, index) {
              Map<String, dynamic> TripInfo = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return CompletedTripTap(TripData: TripInfo);
                    },
                  ));
                },
                child: CompletedWid(
                  Tripdata: TripInfo,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemCount: snapshot.data!.length);
      },
    );
  }
}
