import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/widgets/bucket_add.dart';

class EmptyBucket extends StatelessWidget {
  const EmptyBucket({super.key, this.userData});
  final userData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              height: 400,
              child: Image(image: AssetImage('assets/images/bucketEmpty2.png')),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: ListTile(
                textColor: white,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return BucketAdd(
                        userData: userData,
                      );
                    },
                  ));
                },
                title: Text(
                  'ADD YOUR DREAM DESTINATION',
                  style: GoogleFonts.outfit(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
