import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Form/add_doctor_form.dart';

class AddDoctorScreen extends StatelessWidget {
  final String patientEmail;
  const AddDoctorScreen({super.key, required this.patientEmail});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
            onPressed: () {
              Get.to(() => const Dashboard());
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            color: blackColor,
          ),
          title: const Text(
            "back",
            style: TextStyle(color: blackColor),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Add Your Doctor",
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
                  " Enter Your doctor email address and  ID ",
                  style: tpharagraph2,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AddDoctorForm(patientEmail: patientEmail)
          ],
        ),
      ),
    );
  }
}
