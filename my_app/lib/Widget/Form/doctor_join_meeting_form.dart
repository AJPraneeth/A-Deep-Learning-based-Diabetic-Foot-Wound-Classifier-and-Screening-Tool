import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/meeting_controller.dart';

import 'package:my_app/Widget/button_primary.dart';

class DoctorJoinMeetingForm extends StatelessWidget {
  final String userId;
  final String userName;
  const DoctorJoinMeetingForm(
      {super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    TextEditingController roomIDController = TextEditingController();

    final Controller = Get.put(MeetingContoller());
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: roomIDController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.meeting_room_outlined),
                  labelText: "Room ID",
                  hintText: "Room ID"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          ButtonPrimary(
            text: "Join",
            onTap: () {
              if (roomIDController.text.isEmpty) {
                message(context, "All fields are required");
              } else {
                Controller.doctorJoinMeeting(
                    roomIDController.text.trim(), '12344', userName);
              }
            },
          )
        ],
      ),
    );
  }
}

void message(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
