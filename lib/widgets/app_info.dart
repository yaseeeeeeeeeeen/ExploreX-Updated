// import 'package:flutter/material.dart';

// class AppInfo extends StatelessWidget {
//   const AppInfo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'App Info',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeading('About ExploreX'),
            SizedBox(height: 16),
            Text(
              "ExploreX App is an offline app designed to help you plan and manage your trips. It provides a user-friendly interface and a range of features to make your travel experience seamless and enjoyable.",
            ),
            SizedBox(height: 16),
            _buildSectionHeading('Key Features'),
            SizedBox(height: 16),
            _buildFeatureParagraph(
              'Trip Organization & Details',
              'Effortlessly categorize your trips into ongoing, upcoming, and recent for better organization and planning. Add trip name, destination, dates, type, transportation method, and cover image for a comprehensive trip overview.',
            ),
            _buildFeatureParagraph(
              'Dream Trip',
              'A new feature use to save our money and make your dream destination tour. its working is a you will enter dream destination and Expense for this trip and save a little anmmont in every time and oincrease the progress bar',
            ),
            _buildFeatureParagraph(
              'Budget, Expenses & Companions',
              'Specify the number of companions, Set and manage your trip budget, track expenses, and stay within your financial limits.',
            ),
            SizedBox(height: 16),
            _buildSectionHeading('Version'),
            SizedBox(height: 16),
            Text(
              "ExplorX Version 1.0",
            ),
            SizedBox(height: 16),
            _buildSectionHeading('Made in India'),
            SizedBox(height: 16),
            // Row(
            //   children: [
            //     SizedBox(
            //       child: SvgPicture.asset(
            //         'assets/flag_of_india.svg',
            //         height: 20,
            //       )),
            //     SizedBox(width: 15),
            //     Text(
            //       'ExploreX App is proudly made in India.',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String heading) {
    return Text(
      heading,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildFeatureParagraph(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
