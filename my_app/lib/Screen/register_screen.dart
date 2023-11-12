import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Screen/login_screen.dart';
import 'package:my_app/Screen/register_usertype.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Form/doctor_form.dart';
import 'package:my_app/Widget/Form/patient_form.dart';

class RegisterScreen extends StatefulWidget {
  final String userType;

  const RegisterScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    Widget registerform;

    if (widget.userType == "Doctor") {
      registerform = const DoctorForm();
    } else {
      registerform = const PatientForm();
    }

    return WillPopScope(
      onWillPop: () async {
        // Show the exit dialog when the back button is pressed
        Get.to(() => const UserType());
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "${widget.userType}'s Sign Up",
                    style: title,
                  ),
                  registerform //registerform
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
