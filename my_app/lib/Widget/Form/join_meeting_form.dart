import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/meeting_controller.dart';
import 'package:my_app/Widget/button_primary.dart';

class JoinMeetingForm extends StatelessWidget {
  final String userId;
  final String userName;
  const JoinMeetingForm(
      {super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    TextEditingController roomIDController = TextEditingController();

    TextEditingController passwordController = TextEditingController();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.key_rounded),
                  labelText: "Password",
                  hintText: "Password"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ButtonPrimary(
            text: "Join",
            onTap: () {
              if (passwordController.text.isEmpty ||
                  roomIDController.text.isEmpty) {
                message(context, "All fields are required");
              } else {
                Controller.joinMeeting(roomIDController.text.trim(),
                    passwordController.text.trim(), '1234', userName);
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
