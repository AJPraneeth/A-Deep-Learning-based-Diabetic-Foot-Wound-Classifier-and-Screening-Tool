import 'package:flutter/material.dart';
import 'package:my_app/Screen/splash_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'dart:io';
import 'package:my_app/Widget/Form/login_Form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        // Show the exit dialog when the back button is pressed
        _showExitDialog(context);
        return false; // Return false to prevent the default back navigation
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: white,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()));
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              color: blackColor,
            ),
            title: const Text("Back", style: TextStyle(color: blackColor)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    "assets/Loging.png",
                    height: screenHeight * 0.3,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    //height: screenHeight * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Log in", style: title),
                        ),
                        const SizedBox(height: 10),
                        const LoginForm()
                      ],
                    ),
                  )
                ],
              ),
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
        title: Text('Exit App'),
        content: Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              exit(0);
            },
            child: Text('Exit'),
          ),
        ],
      );
    },
  );
}
