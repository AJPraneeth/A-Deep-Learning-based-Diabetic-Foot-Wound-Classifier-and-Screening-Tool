import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Form/create_meeting_form.dart';

class CreateMeetingScreen extends StatelessWidget {
  final String doctorUserId;
  const CreateMeetingScreen({super.key, required this.doctorUserId});

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text('Create The Meeting', style: tpharagraph4)),
                ),
                const SizedBox(
                  height: 10,
                ),
                CreateMeetingForm(
                  doctorUserId: doctorUserId,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
