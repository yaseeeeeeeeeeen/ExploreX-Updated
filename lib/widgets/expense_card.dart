import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ExpenseCard extends StatelessWidget {
  ExpenseCard(
      {super.key, this.color1, this.ammount, this.label, required this.icon});
  Color? color1;
  String? ammount;
  String? label;
  bool icon;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 130,
        decoration: BoxDecoration(
            color: color1, borderRadius: BorderRadius.circular(15)),
        width: MediaQuery.sizeOf(context).width / 2 - 18,
      ),
      Container(
          margin: EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(ammount!,
                style: GoogleFonts.outfit(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w400)),
            SizedBox(
              height: 10,
            ),
            Text(label!,
                style: GoogleFonts.tenorSans(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 5),
            icon
                ? Row(
                    children: [
                      Icon(
                        Icons.add_box_outlined,
                        color: Color.fromARGB(211, 255, 255, 255),
                        size: 25,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Add Ammount',
                        style: GoogleFonts.tenorSans(
                            color: Color.fromARGB(226, 255, 255, 255),
                            fontSize: 17),
                      )
                    ],
                  )
                : Text(
                    'View Expense',
                    style: GoogleFonts.tenorSans(
                        color: Color.fromARGB(226, 255, 255, 255),
                        fontSize: 17),
                  )
          ]))
    ]);
  }
}
