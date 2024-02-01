import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/pages/botton_nav.dart';

class CheckList extends StatefulWidget {
  CheckList({super.key, this.userInfo, required this.TripInfo});
  final userInfo;

  final Map<String, dynamic> TripInfo;
  @override
  State<CheckList> createState() => _CheckListState();
}

List checkListItems = [
  'Personal Items',
  'Mobile Phone',
  'Medical supplies',
  'Charger',
  'Bag',
  'Water bottle',
];

class _CheckListState extends State<CheckList> {
  List<bool> itemSelections =
      List.generate(checkListItems.length, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'REMAINDER',
            style: GoogleFonts.tenorSans(
                fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            itemCount: checkListItems.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(
                  '${checkListItems[index]}',
                  style: GoogleFonts.tenorSans(fontSize: 18),
                ),
                value: itemSelections[index],
                onChanged: (bool? newValue) {
                  setState(() {
                    itemSelections[index] = newValue!;
                  });
                },
                checkColor: Colors.white,
                activeColor: Colors.black,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: const Color.fromARGB(174, 0, 0, 0),
              );
            },
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.tenorSans(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  fixedSize:
                      Size(MediaQuery.sizeOf(context).width / 2 - 20, 50),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  started();
                },
                child: Text(
                  'Start',
                  style: GoogleFonts.tenorSans(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(59, 115, 2, 1),
                  fixedSize:
                      Size(MediaQuery.sizeOf(context).width / 2 - 20, 50),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  started() async {
    await DatabaseHelper.instance.UpdateOngoingTrip(widget.TripInfo['id'], 1);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return BottomNavBar(
          UserDetails: widget.userInfo,
        );
      },
    ), (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
        content: Text("TRIP IS STARTED")));
  }
}
