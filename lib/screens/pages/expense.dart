import 'package:flutter/material.dart';
import 'package:trip_planner/database/db_helper.dart';

import 'package:trip_planner/screens/pages/botton_nav.dart';
import 'package:trip_planner/widgets/cards.dart';
import 'package:trip_planner/widgets/fuel_calclator.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key, this.UserData});
  final UserData;
  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

List<Map<String, dynamic>>? Completed;
List<Map<String, dynamic>>? upcoming;
int? UpcomingLength;
int? CompleteLength;

class _ExpensePageState extends State<ExpensePage> {
  Datas(int userId) async {
    Completed = await DatabaseHelper.instance.readCompledTrips(userId);
    upcoming = await DatabaseHelper.instance.readUpcomingTrips(userId);
    setState(() {
      CompleteLength = Completed!.length;
      UpcomingLength = upcoming!.length;
    });
  }

  @override
  void initState() {
    Datas(widget.UserData['id']);
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return BottomNavBar(
                                    UserDetails: widget.UserData,
                                    pagenumber: 0,
                                  );
                                }));
                              },
                              child: ExpensePageCard(
                                  Number: '${UpcomingLength ?? 0}',
                                  text: 'Upcoming\nTrips',
                                  backColor: Color.fromRGBO(69, 138, 0, 0.842)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return BottomNavBar(
                                      UserDetails: widget.UserData,
                                      pagenumber: 3,
                                    );
                                  }));
                                },
                                child: ExpensePageCard(
                                    Number: "${CompleteLength ?? 0}",
                                    text: "Completed\nTrips",
                                    backColor: Colors.black))
                          ])),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: fuelCalculator,
                        child: Stack(
                          children: [
                            ExpensePageCard(
                                Number: '',
                                text: "Fuel\nCalculator",
                                backColor: Colors.black),
                            Positioned(
                              left: 10,
                              top: 15,
                              child: Icon(
                                Icons.local_gas_station,
                                size: 50,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      )
                    ]))));
  }

  fuelCalculator() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FuelCalculator();
      },
    );
  }
}
