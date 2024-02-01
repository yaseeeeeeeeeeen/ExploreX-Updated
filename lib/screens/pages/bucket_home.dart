import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/widgets/progress_bar.dart';
import 'package:trip_planner/widgets/titles.dart';

class BucketFHome extends StatefulWidget {
  BucketFHome({super.key, this.UserInfo});
  final Map<String, dynamic>? UserInfo;
  @override
  State<BucketFHome> createState() => _BucketFHomeState();
}

late Map<String, dynamic>? datas;
late String Ammount;
late String Destination;
int? Savings;

class _BucketFHomeState extends State<BucketFHome> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return FutureBuilder(
        future:
            DatabaseHelper.instance.dreamDestinationGet(widget.UserInfo!['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: Colors.white);
          } else if (snapshot.hasError) {
            return Text('Erorr ${snapshot.error}');
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Container(
                child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: height / 4.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      image: DecorationImage(
                          image: AssetImage('assets/images/EXPLORE X.jpg'),
                          fit: BoxFit.cover)),
                ),
              ],
            ));
          } else {
            datas = snapshot.data;
            Savings = datas![DatabaseHelper.savings];
            Destination = datas![DatabaseHelper.destination];
            Ammount = datas![DatabaseHelper.ammount].toString();
            int? amountText = datas![DatabaseHelper.ammount];
            double value = (Savings! / amountText!) * 100;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitlesWid(Title: 'Bucket List'),
                Container(
                    child: Stack(children: [
                  Container(
                      height: 200,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.darken),
                              image:
                                  AssetImage('assets/images/moneyyy.jpeg')))),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Row(children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      Destination,
                                      style: GoogleFonts.tenorSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 30.0),
                                    )
                                  ])),
                              SizedBox(
                                height: 20,
                              ),
                              Row(children: [
                                Icon(
                                  Icons.account_balance,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '₹ ${Ammount}',
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30.0),
                                )
                              ])
                            ]),
                        Container(
                            margin: EdgeInsets.only(top: 30),
                            child: ProgressWid(
                              radiusValue: 65,
                              lineWidth: 10,
                              percentageValue: value.roundToDouble() / 100,
                              fontValue: 23,
                              textColor: Colors.white,
                            ))
                      ])
                ])),
              ],
            );
          }
        });
  }
}
