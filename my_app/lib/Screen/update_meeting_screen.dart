import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Form/update_meeting_form.dart';

class UpdateMeetingScreen extends StatelessWidget {
  final String sessionId;
  final String patientName;
  final String roomId;
  final String password;
  final String patientEmail;

  const UpdateMeetingScreen(
      {super.key,
      required this.sessionId,
      required this.password,
      required this.patientName,
      required this.roomId,
      required this.patientEmail});

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
          centerTitle: true,
          title: Text(
            "Edit Meeting",
            style: tpharagraph4.copyWith(color: blackColor),
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
                      child: Text('You can change only date and time.',
                          style: tpharagraph7)),
                ),
                const SizedBox(
                  height: 10,
                ),
                // CreateMeetingForm(
                //   doctorUserId: doctorUserId,
                // )
                UpdateMeetingForm(
                  sessionId: sessionId,
                  roomId: roomId,
                  password: password,
                  patientName: patientName,
                  patientEmail: patientEmail,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
