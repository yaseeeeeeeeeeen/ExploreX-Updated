import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Terms and Conditions',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
            child: Container(
          color: Colors.black12,
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Text(
              '''
ExploreX Trip Planner Application - Terms and Conditions
            
Effective Date: AUG-27-2023
            
            Please read these Terms an Conditions ("Terms") carefully before using the ExploreX Trip Planner Application ("Application") operated by ExploreX. By accessing or using the Application, you agree to be bound by these Terms. If you do not agree with any part of these Terms, please do not use the Application.
            
1. Acceptance of Terms
            
            By downloading, accessing, or using the ExploreX Trip Planner Application, you agree to abide by these Terms and any additional guidelines or rules that may be posted by the Company within the Application. These Terms constitute a legally binding agreement between you and the Company.
            
2. Description of the Application
            
 ExploreX is a trip planner application designed to help users plan, organize, and manage their trips. The Application provides features such as trip itinerary creation, destination recommendations, travel expense tracking, and sharing of trip details with fellow travelers.
            
3. User Registration and Accounts
            
        3.1 In order to access certain features of the Application, you may be required to create a user account. You agree to provide accurate and complete information when creating your account, and you are responsible for maintaining the confidentiality of your account credentials.
            
        3.2 You are solely responsible for all activities that occur under your account. If you suspect unauthorized use of your account, you must notify the Company immediately.
            
 4. Use of the Application
            
        4.1 You agree to use the Application only for lawful purposes and in accordance with these Terms. You shall not use the Application to violate any applicable laws, infringe upon intellectual property rights, or engage in any harmful or malicious activities.
            
        4.2 The Company reserves the right to modify, suspend, or discontinue the Application or any part of it at any time without prior notice.
            
5. User-Generated Content
            
        5.1 The Application may allow you to submit, post, or share content, including trip itineraries, reviews, photos, and comments ("User Content"). You retain ownership of your User Content, but by submitting it, you grant the Company a non-exclusive, worldwide, royalty-free, sublicensable, and transferable license to use, reproduce, modify, distribute, and display your User Content for the purpose of operating and improving the Application.
            
        5.2 You are solely responsible for the User Content you submit, and you agree not to submit any content that is unlawful, defamatory, obscene, offensive, or infringing upon third-party rights.
            
6. Privacy Policy
            
            Your use of the Application is also governed by our Privacy Policy [Link to Privacy Policy]. By using the Application, you consent to the collection, use, and disclosure of your information as described in the Privacy Policy.
            
7. Disclaimer of Warranties
            
            The Application is provided on an "as is" and "as available" basis. The Company makes no warranties, either express or implied, regarding the accuracy, reliability, or availability of the Application.
            
8. Limitation of Liability
            
            To the extent permitted by law, the Company shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or in connection with the use of the Application.
            
9. Governing Law
            
            These Terms shall be governed by and construed in accordance with the laws of [Your Jurisdiction]. Any disputes arising under or in connection with these Terms shall be subject to the exclusive jurisdiction of the courts located in [Your Jurisdiction].
            
10. Changes to Terms
            
            The Company reserves the right to update or modify these Terms at any time without prior notice. By continuing to use the Application after any changes, you agree to be bound by the updated Terms.
            
            By using the ExploreX Trip Planner Application, you acknowledge that you have read, understood, and agree to these Terms and Conditions. If you do not agree to these Terms, please refrain from using the Application.
            
            If you have any questions or concerns regarding these Terms, please contact us at [muhammardyaseen@gmail.com]\n\n                                           [End of Terms and Conditions]
            ''',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
        )));
  }
}
