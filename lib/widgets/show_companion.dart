import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:trip_planner/database/db_helper.dart';

// ignore: must_be_immutable
class ShowCompanion extends StatefulWidget {
  ShowCompanion({super.key, required this.TripID});
  int? TripID;
  @override
  State<ShowCompanion> createState() => _ShowCompanionState();
}

class _ShowCompanionState extends State<ShowCompanion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black,
      ),
      child: ListTile(
        onTap: () {
          companionBottomSheet(widget.TripID!);
        },
        title: Text('SHOW COMPANIONS',
            style: GoogleFonts.tenorSans(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center),
      ),
    );
  }

  companionBottomSheet(int TripId) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: DatabaseHelper.instance.companionTable(TripId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error${snapshot.error}');
            } else {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Container(
                  height: 350,
                  child: GestureDetector(
                    onTap: () {},
                    child: Lottie.asset(
                      'assets/animation/emptyList.json',
                    ),
                  ),
                );
              }
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> Companion = snapshot.data![index];
                        return Container(
                          height: 80,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(237, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            trailing: Container(
                              width: 50,
                              child: IconButton(
                                  onPressed: () {
                                    callComapnion(Companion[
                                        DatabaseHelper.CompanionNumber]);
                                  },
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.green,
                                  )),
                            ),
                            textColor: Colors.black,
                            title: Text(
                              '${Companion[DatabaseHelper.CompanionName].toString().toUpperCase()}',
                              style: GoogleFonts.actor(),
                            ),
                            subtitle: Text(
                                '${Companion[DatabaseHelper.CompanionNumber]}'),
                          ),
                        );
                      },
                      itemCount: snapshot.data!.length,
                    );
                  },
                ),
              );
            }
          },
        );
      },
    );
  }

  callComapnion(String Number) async {
    await FlutterPhoneDirectCaller.callNumber(Number);
  }
}
