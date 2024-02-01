import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/pages/botton_nav.dart';
import 'package:trip_planner/widgets/expense_card.dart';
import 'package:trip_planner/widgets/image_pick.dart';
import 'package:trip_planner/widgets/images_build.dart';
import 'package:trip_planner/widgets/show_companion.dart';
import 'package:trip_planner/widgets/titles.dart';

class OnGoingScreen extends StatefulWidget {
  OnGoingScreen({super.key, required this.TripData, this.UserInfo});
  final UserInfo;
  final TripData;

  @override
  State<OnGoingScreen> createState() => _OnGoingScreenState();
}

List Purpose = ['Travel', 'Food', 'Shoping', 'Other'];
int isSelected1 = -1;
TextEditingController NotesController = TextEditingController();
TextEditingController ExpenseController = TextEditingController();
String? notes;
XFile? imagefile;

class _OnGoingScreenState extends State<OnGoingScreen> {
  //date Update veribles...
  late DateTime date1;
  late String formatedStartDate;
  late DateTime date2;
  late String formatedEndDate;
  late String endDate;
  String? formatedDate; //update time date
  late String startDate;
  //expense...
  double? budget;
  double? TravelExp;
  double? FoodExp;
  double? ShopingExp;
  double? OtherExp;
  double? TotalExp;
  late Map<dynamic, dynamic> ExpenseData;
  int? Expense;
  getExpensInfo() async {
    final result =
        await DatabaseHelper.instance.getExpenseInfo(widget.TripData['id']);
    setState(() {
      ExpenseData = result;
      Expense = ExpenseData[DatabaseHelper.totalExp] ?? 0;
    });
  }

  @override
  void initState() {
    getExpensInfo();
    super.initState();
    date1 = DateFormat('yyyy-MM-dd')
        .parse(widget.TripData[DatabaseHelper.ColumDateStart]);
    formatedStartDate = DateFormat('MMM d, y').format(date1);
    date2 = DateFormat('yyyy-MM-dd')
        .parse(widget.TripData[DatabaseHelper.ColumDateEnding]);
    formatedEndDate = DateFormat('MMM d, y').format(date2);
    NotesController.text = widget.TripData[DatabaseHelper.ColomNote];
    notes = NotesController.text;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle font1 = GoogleFonts.tenorSans(
        color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700);
    TextStyle font2 = GoogleFonts.tenorSans(
        fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);
    double deviceWidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) {
                    return BottomNavBar(
                        UserDetails: widget.UserInfo, pagenumber: 0);
                  },
                ), (route) => false);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          actions: [
            IconButton(
              onPressed: () {
                tripCompleted(context);
              },
              icon: Icon(Icons.task_alt),
              color: Colors.black,
              iconSize: 35,
            ),
            SizedBox(
              width: 10,
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(widget.TripData[DatabaseHelper.columDestination],
              style: font1),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.sizeOf(context).width,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: FileImage(File(
                              widget.TripData[DatabaseHelper.ColumCoverPhoto])),
                          fit: BoxFit.cover)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(
                        top: 15, left: 10, right: 10, bottom: 0),
                    textColor: Colors.white,
                    leading: Column(children: [
                      OngoingTile(textt: '  Started Date'),
                      OngoingTile(textt: formatedStartDate),
                    ]),
                    trailing: InkWell(
                      onTap: () async {
                        String date = await updateDate();
                        setState(() {
                          formatedEndDate = date;
                        });
                      },
                      child: Column(
                        children: [
                          OngoingTile(textt: 'Ending Date '),
                          OngoingTile(textt: formatedEndDate),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          showExpense();
                        },
                        child: ExpenseCard(
                          icon: false,
                          color1: Color.fromARGB(199, 51, 50, 50),
                          ammount:
                              '₹ ${widget.TripData[DatabaseHelper.ColumTripBudget]}',
                          label: 'Total Budget',
                        ),
                      ),
                      GestureDetector(
                        onTap: expenseBottomSheet,
                        child: ExpenseCard(
                          icon: true,
                          color1: Colors.black,
                          ammount: '₹ ${Expense}',
                          label: 'Total Expense',
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    onTap: () {
                      imagesAdding();
                    },
                    textColor: Colors.white,
                    title: Text(
                      'ADD SOME MEMMORIES ➔',
                      style: GoogleFonts.tenorSans(
                          color: Colors.white,
                          fontSize: 17,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                ImagesGrid(
                  TripData: widget.TripData,
                ),
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    height: 300,
                    width: deviceWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black12),
                    child: Column(children: [
                      ListTile(
                          leading: Text("Notes", style: font2),
                          trailing: TextButton.icon(
                              onPressed: () {
                                noteBottomSheet();
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 18,
                              ),
                              label: Text('Edit Notes', style: font2))),
                      Container(
                          padding: EdgeInsets.all(10),
                          height: 200,
                          child: Text(
                            textAlign: TextAlign.center,
                            notes!,
                            style: GoogleFonts.tenorSans(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ))
                    ])),
                SizedBox(height: 5),
                ShowCompanion(TripID: widget.TripData['id']),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }

//Date Update.............
  Future<String> updateDate() async {
    DateTime? pickdate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
              primary: Colors.black,
              onSurface: Colors.black,
            )),
            child: child!,
          );
        },
        initialDate: date2,
        firstDate: date1,
        lastDate: DateTime(2050));
    if (pickdate != null) {
      endDate = DateFormat('yyyy-MM-dd').format(pickdate);
      formatedDate = DateFormat('MMM d, y').format(pickdate);
    }

    await DatabaseHelper.instance.UpdateTripDates(
        widget.TripData[DatabaseHelper.ColumDateStart],
        endDate,
        widget.TripData['id']);

    return formatedDate!;
  }

//Image Adding(Memmories)................
  imagesAdding() async {
    imagefile = await ImagePickService().pickCropImage(
        cropAspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        imageSource: ImageSource.gallery);
    final Imagepath = File(imagefile!.path);
    print('$Imagepath');

    Map<String, dynamic> Images = {
      DatabaseHelper.imageTripId: widget.TripData['id'],
      DatabaseHelper.imageLocation: Imagepath.path,
    };
    setState(() {
      ImagesGrid(TripData: widget.TripData);
    });
    await DatabaseHelper.instance.addImages(widget.TripData['id'], Images);
  }

//Notes add ad nd edit...................
  void noteBottomSheet() async {
    final result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.transparent)),
                          child: Form(
                            child: TextFormField(
                              controller: NotesController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                              maxLines: 10,
                            ),
                          ),
                        ),
                        TextButton.icon(
                            onPressed: () async {
                              final notes = NotesController.text;
                              await DatabaseHelper.instance.UpdateTripNotes(
                                  notes, widget.TripData['id']);
                              Navigator.of(context).pop(notes);
                            },
                            icon: Icon(
                              Icons.done,
                              color: Colors.black,
                            ),
                            label: Text(
                              'SAVE NOTES',
                              style: GoogleFonts.tenorSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ))
                      ]))));
        });
    if (result != null) {
      setState(() {
        notes = result;
      });
    }
  }

//trip Complete button alert dialog.....................
  tripCompleted(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 30, top: 20),
                          child: Text('Complete this Trip?',
                              style: GoogleFonts.tenorSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                  color: Colors.black)))
                    ]),
                Column(children: [
                  TextButton(
                      onPressed: () async {
                        await DatabaseHelper.instance
                            .UpdateOngoingTrip(widget.TripData['id'], 2);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                          return BottomNavBar(
                            UserDetails: widget.UserInfo,
                          );
                        }), (route) => false);
                        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                            backgroundColor: Colors.black,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 2),
                            content: Text(
                                "TRIP INFORMATION ADDED IN COMPLETED LIST")));
                      },
                      child: Text('COMPLETED',
                          style: GoogleFonts.tenorSans(
                              color: Colors.green,
                              fontSize: 17,
                              fontWeight: FontWeight.bold))),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'BACK',
                        style: GoogleFonts.tenorSans(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ))
                ])
              ]);
        });
  }

  //show Spending History and Expense..................................
  showExpense() async {
    List ammountExp = [
      ExpenseData[DatabaseHelper.travelexpense].toString(),
      ExpenseData[DatabaseHelper.foodexpense].toString(),
      ExpenseData[DatabaseHelper.shopingexpense].toString(),
      ExpenseData[DatabaseHelper.otherexpense].toString()
    ];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                      leadingAndTrailingTextStyle:
                          GoogleFonts.tenorSans(fontSize: 17),
                      textColor: Colors.white,
                      leading: Text(Purpose[index]),
                      trailing: Text('₹ ${ammountExp[index]}')),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 5);
              },
              itemCount: 4),
        );
      },
    );
  }

//Expens Bottom Sheet Adding.........................
  expenseBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 250,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Form(
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.tenorSans(),
                                  keyboardType: TextInputType.number,
                                  controller: ExpenseController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Ammount',
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              StatefulBuilder(builder: (context, setState) {
                                return GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 1 / .3,
                                          crossAxisSpacing: 10,
                                          crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    return ChoiceChip(
                                        shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        label: Container(
                                            height: 40,
                                            child: Text(Purpose[index],
                                                style: GoogleFonts.tenorSans(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            alignment: Alignment.center),
                                        selectedColor:
                                            Color.fromARGB(155, 57, 143, 17),
                                        selected: index == isSelected1,
                                        onSelected: (NewBoolValue) {
                                          setState(() {
                                            isSelected1 =
                                                NewBoolValue ? index : -1;
                                          });
                                        });
                                  },
                                  itemCount: Purpose.length,
                                );
                              }),
                              TextButton.icon(
                                  onPressed: () async {
                                    //Databse update and expense adding in there...........
                                    String amountText = ExpenseController.text;
                                    expenseChecking(amountText);
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    'SAVE AMMOUNT',
                                    style: GoogleFonts.tenorSans(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ])))),
          );
        });
  }

  //Expense validation and database adding................................
  expenseChecking(String AmmountText) async {
    double parsedAmount = double.tryParse(AmmountText) ?? 0;
    ExpenseController.clear();
    budget = double.tryParse(widget.TripData[DatabaseHelper.ColumTripBudget]);
    TravelExp =
        double.tryParse(ExpenseData[DatabaseHelper.travelexpense].toString());
    FoodExp =
        double.tryParse(ExpenseData[DatabaseHelper.foodexpense].toString());
    ShopingExp =
        double.tryParse(ExpenseData[DatabaseHelper.shopingexpense].toString());
    OtherExp =
        double.tryParse(ExpenseData[DatabaseHelper.otherexpense].toString());
    if (isSelected1 == 0) {
      TravelExp = TravelExp! + parsedAmount;
    } else if (isSelected1 == 1) {
      FoodExp = FoodExp! + parsedAmount;
    } else if (isSelected1 == 2) {
      ShopingExp = ShopingExp! + parsedAmount;
    } else if (isSelected1 == 3) {
      OtherExp = OtherExp! + parsedAmount;
    }
    TotalExp = (OtherExp! + ShopingExp! + FoodExp! + TravelExp!);
    if (TotalExp! <= budget!) {
      Map<dynamic, dynamic> row = {
        DatabaseHelper.expTripId: widget.TripData['id'],
        DatabaseHelper.foodexpense: FoodExp!.round(),
        DatabaseHelper.otherexpense: OtherExp!.round(),
        DatabaseHelper.shopingexpense: ShopingExp!.round(),
        DatabaseHelper.travelexpense: TravelExp!.round(),
        DatabaseHelper.totalExp: TotalExp!.round()
      };
      await DatabaseHelper.instance.addExpense(row, widget.TripData['id']);
      print(TotalExp);
      setState(() {
        Expense = TotalExp!.round();
        isSelected1 = -1;
        ExpenseData = row;
      });
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) {
          return OnGoingScreen(
              TripData: widget.TripData, UserInfo: widget.UserInfo);
        },
      ), (route) => false);
    } else {
      Navigator.of(context).pop();
      isSelected1 = -1;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
        content: Text("YOUR EXPENSE IS OVER YOU CAN'T ADD EXPENSE"),
      ));
    }
  }
}
