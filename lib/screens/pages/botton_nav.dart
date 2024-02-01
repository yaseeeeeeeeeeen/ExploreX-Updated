import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/constant/fonts_styles.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/pages/completed_card.dart';
import 'package:trip_planner/screens/pages/home_screen.dart';
import 'package:trip_planner/screens/pages/expense.dart';
import 'package:trip_planner/screens/pages/bucket_build.dart';
import 'package:trip_planner/widgets/drawer.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key, this.pagenumber, this.UserDetails});
  final int? pagenumber;
  Map<String, dynamic>? UserDetails;
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void _openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void _navigateBottomBar(int value) {
    setState(() {
      _selectIndex = value;
    });
  }

  String? images;
  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    images = widget.UserDetails![DatabaseHelper.coloumImages];
    _selectIndex = widget.pagenumber ?? 0;
    _pages = [
      Home(UserInfo: widget.UserDetails),
      BucketBuilder(userData: widget.UserDetails),
      ExpensePage(UserData: widget.UserDetails),
      CompletedTrip(
        UserData: widget.UserDetails,
      )
    ];
  }

  TextStyle GnavFont = GoogleFonts.tenorSans(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            drawer: DrawerWid(UserDetails: widget.UserDetails),
            appBar: AppBar(
              backgroundColor: white,
              leading: GestureDetector(
                onTap: _openDrawer,
                child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                  child: CircleAvatar(
                      radius: 20, backgroundImage: FileImage(File(images!))),
                ),
              ),
              title: Text(
                "ExploreX",
                style: appbarTitle,
              ),
            ),
            body: _pages[_selectIndex],
            bottomNavigationBar: Container(
                color: Colors.black,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: GNav(
                        gap: 8,
                        selectedIndex: _selectIndex,
                        onTabChange: (value) {
                          _navigateBottomBar(value);
                        },
                        backgroundColor: Colors.black,
                        color: Colors.white,
                        activeColor: Colors.white,
                        tabBackgroundColor: Colors.grey.shade800,
                        padding: EdgeInsets.all(15),
                        tabs: [
                          GButton(
                            icon: Icons.home,
                            text: 'Home',
                            textStyle: GnavFont,
                          ),
                          GButton(
                            icon: Icons.track_changes,
                            text: 'Destination',
                            textStyle: GnavFont,
                          ),
                          GButton(
                            icon: Icons.account_balance_wallet_outlined,
                            text: 'Expense',
                            textStyle: GnavFont,
                          ),
                          GButton(
                            icon: Icons.favorite,
                            text: 'Completed',
                            textStyle: GnavFont,
                          )
                        ])))));
  }
}
