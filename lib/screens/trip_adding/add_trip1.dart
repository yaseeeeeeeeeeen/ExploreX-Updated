import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/trip_adding/add_trip2.dart';
import 'package:trip_planner/screens/pages/botton_nav.dart';
import 'package:trip_planner/widgets/continue_btn.dart';
import 'package:trip_planner/widgets/textfield.dart';

class AddTrip1 extends StatefulWidget {
  const AddTrip1({super.key, this.UserInfo});
  final UserInfo;
  @override
  State<AddTrip1> createState() => _AddTrip1State();
}

@override
final _DestinationController = TextEditingController();
final _StartingController = TextEditingController();
final _DateStartController = TextEditingController();
final _DateEndController = TextEditingController();
Map<String, dynamic> TripData = {};
String? startDate;
String? endDate;
bool dateSelected = false;
DateTime? pickdate1;

class _AddTrip1State extends State<AddTrip1> {
  @override
  void initState() {
    _DateEndController.text = '';
    _DateStartController.text = '';
    _DestinationController.text = '';
    _StartingController.text = '';
    super.initState();
  }

  final _formKey1 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) {
                    return BottomNavBar(
                      UserDetails: widget.UserInfo,
                      pagenumber: 0,
                    );
                  },
                ), (route) => false);
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.black,
                size: 30,
              )),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20, top: 20, right: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Your Trip.',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Start to add your trip details.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFieldWid(
                      controller: _DestinationController,
                      validation: 'ADD A VALID DESTINATION',
                      hintText: 'Enter Your Destination',
                      SuffIcon: Icons.location_on),
                  TextFieldWid(
                      controller: _StartingController,
                      validation: 'ADD A VALID LOCATION',
                      hintText: 'Enter your starting point',
                      SuffIcon: Icons.location_on),
                  TextFieldWid(
                      controller: _DateStartController,
                      readOnly: true,
                      ontap: () async {
                        pickdate1 = await showDatePicker(
                            context: context,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                  primary: Colors.black, // <-- SEE HERE
                                  // onPrimary: Colors.redAccent, // <-- SEE HERE
                                  onSurface: Colors.black, // <-- SEE HERE
                                )),
                                child: child!,
                              );
                            },
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050));

                        if (pickdate1 != null) {
                          startDate =
                              DateFormat('yyyy-MM-dd').format(pickdate1!);
                          setState(() {
                            _DateStartController.text =
                                DateFormat('MMM d, y').format(pickdate1!);
                            dateSelected = true;
                          });
                        }
                      },
                      validation: 'ADD A VALID DATE',
                      hintText: 'Select your starting date',
                      SuffIcon: Icons.calendar_month),
                  TextFieldWid(
                      controller: _DateEndController,
                      readOnly: true,
                      enabled: dateSelected,
                      ontap: () async {
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
                            initialDate: pickdate1!,
                            firstDate: pickdate1!,
                            lastDate: DateTime(2050));
                        if (pickdate != null) {
                          endDate = DateFormat('yyyy-MM-dd').format(pickdate);
                          setState(() {
                            _DateEndController.text =
                                DateFormat('MMM d, y').format(pickdate);
                          });
                        }
                      },
                      validation: 'ADD A VALID DATE',
                      hintText: 'Select your ending date',
                      SuffIcon: Icons.calendar_month),
                  SizedBox(
                    height: 40,
                  ),
                  ContinueButtonWid(ButtonClick: () {
                    _submitForm();
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addDb() async {
    final _destination = _DestinationController.text;
    final _StartingPoint = _StartingController.text;

//set in a map
    TripData[DatabaseHelper.columDestination] = _destination;
    TripData[DatabaseHelper.ColumStarting] = _StartingPoint;
    TripData[DatabaseHelper.ColumDateStart] = startDate;
    TripData[DatabaseHelper.ColumDateEnding] = endDate;
    print(TripData);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return AddTrip2(
          UserInfo: widget.UserInfo,
          TripData: TripData,
        );
      },
    ));
  }

  void _submitForm() async {
    if (_formKey1.currentState!.validate()) {
      // _formKey.currentState?.save();    ===?? nthannn ariellaaa nokkanam...
      // Perform any further actions with the password data here
      await addDb();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(59, 115, 2, 1),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 1),
          content: Text("COMPLETE  ALL DETAILS"),
        ),
      );
    }
  }
}
