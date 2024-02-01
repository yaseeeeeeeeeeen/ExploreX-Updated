import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/widgets/bucketlist_img.dart';
import 'package:trip_planner/widgets/bucket_empty.dart';
import 'package:trip_planner/widgets/progress_bar.dart';
import 'package:trip_planner/widgets/titles.dart';

class BucketBuilder extends StatefulWidget {
  BucketBuilder({super.key, required this.userData});
  final userData;

  @override
  State<BucketBuilder> createState() => _BucketBuilderState();
}

late Map<String, dynamic>? datas;

int? Savings;
TextEditingController AmmountController = TextEditingController();

class _BucketBuilderState extends State<BucketBuilder> {
  @override
  void initState() {
    String amountText = AmmountController.text;
    // ignore: unused_local_variable
    double parsedAmount = double.tryParse(amountText) ?? 0;

    super.initState();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          DatabaseHelper.instance.dreamDestinationGet(widget.userData['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erorr ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return EmptyBucket(userData: widget.userData);
        }
        datas = snapshot.data;
        Savings = datas![DatabaseHelper.savings];
        int? amountText = datas![DatabaseHelper.ammount];
        double value = (Savings! / amountText!) * 100;
        return SafeArea(
          child: Scaffold(
              body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: ProgressWid(
                        radiusValue: 90,
                        percentageValue: value.roundToDouble() / 100,
                        fontValue: 30,
                        textColor: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(69, 138, 0, 0.842),
                      ),
                      child: TextButton(
                        onPressed: () {
                          AmmountAdd(context);
                        },
                        child: Text(
                          'ADD AMMOUNT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    DreamAmmountText(
                        leadingText: "Total Expense",
                        TrailingText: "${datas![DatabaseHelper.ammount]}"),
                    SizedBox(
                      height: 10,
                    ),
                    DreamAmmountText(
                        leadingText: "Savings", TrailingText: '$Savings'),
                    SizedBox(
                      height: 20,
                    ),
                    DreamDestinationWid(Destination: datas)
                  ],
                ),
              ),
            ),
          )),
        );
      },
    );
  }

  void AmmountAdd(context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 110,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Form(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmSerifDisplay(),
                                keyboardType: TextInputType.number,
                                controller: AmmountController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            TextButton.icon(
                                onPressed: () async {
                                  String amountText = AmmountController.text;
                                  double parsedAmount =
                                      double.tryParse(amountText) ?? 0;
                                  AmmountController.clear();
                                  double? dbSavings = double.tryParse(
                                          datas!['savings'].toString()) ??
                                      0;

                                  double total = parsedAmount + dbSavings;
                                  await DatabaseHelper.instance.UpdateDreamTrip(
                                      widget.userData['id'], total.round());
                                  setState(() {
                                    Savings = total.round();
                                  });
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.done,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'SAVE AMMOUNT',
                                  style: GoogleFonts.arsenal(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ))
                          ]))));
        });
  }
}
