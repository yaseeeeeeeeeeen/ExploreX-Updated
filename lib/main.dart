import 'package:flutter/material.dart';
import 'package:trip_planner/constant/colors.dart';
import 'package:trip_planner/database/db_helper.dart';
import 'package:trip_planner/screens/introduction/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDB();
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(shape: LinearBorder()),
          scaffoldBackgroundColor: scaffoldbg,
          appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: black),
              elevation: 0,
              centerTitle: true)),
      // darkTheme: ThemeData.light(),
      title: 'Trip Planner',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
