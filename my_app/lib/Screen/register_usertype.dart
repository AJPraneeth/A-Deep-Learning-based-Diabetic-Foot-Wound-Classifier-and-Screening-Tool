import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Screen/login_screen.dart';
import 'package:my_app/Screen/register_screen.dart';
import 'package:my_app/Theme/theme.dart';

class UserType extends StatelessWidget {
  const UserType({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // Show the exit dialog when the back button is pressed
        Get.to(() => const LoginScreen());
        return false; // Return false to prevent the default back navigation
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: white,
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
                Center(
                  child: Text(
                    "Choose Your User Type",
                    style: title,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      color: bgColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(
                                        userType: "Doctor",
                                      )));
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/doctor.png",
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.4,
                            ),
                            Text(
                              "Doctor",
                              style: cardtext,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: bgColor,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(
                                        userType: "Patient",
                                      )));
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/patient.png",
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.4,
                            ),
                            Text(
                              "Patient",
                              style: cardtext,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
