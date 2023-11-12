import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/mail_verification_controller.dart';
import 'package:my_app/Screen/login_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/button_primary.dart';

class MailVerificationScreen extends StatelessWidget {
  const MailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mailVerificationController = Get.put(MailVerificationController());
    return WillPopScope(
      onWillPop: () async {
        // Show the exit dialog when the back button is pressed
        _showExitDialog(context);
        return false; // Return false to prevent the default back navigation
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              color: blackColor,
            ),
            title: const Text("Back", style: TextStyle(color: blackColor)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.email_outlined,
                    size: 100,
                  ),
                ),
                Center(
                  child: Text(
                    "Verify Your email Address",
                    style: title,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      " We have just send email verification link on your email.Pleace check email and click on that link to verify your Email address",
                      style: tpharagraph2,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "If not auto redirected after verification, tap on the continue button",
                      style: tpharagraph2,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonPrimary(
                    text: "Continue",
                    onTap: () {
                      mailVerificationController
                          .manuallyCheckEmailVerificationStatus();
                    }),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      mailVerificationController.sendVerificationEmail();
                    },
                    child: const Text("Resend Email Link"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Close the LoginScreen
            },
            child: const Text('Exit'),
          ),
        ],
      );
    },
  );
}
