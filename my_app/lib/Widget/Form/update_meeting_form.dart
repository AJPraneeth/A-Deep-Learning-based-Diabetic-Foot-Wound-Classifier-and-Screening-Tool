import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/meeting_controller.dart';
import 'package:my_app/Controller/send_email_controller.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/button_primary.dart';
import 'package:intl/intl.dart';

class UpdateMeetingForm extends StatefulWidget {
  final String sessionId;
  final String patientName;
  final String roomId;
  final String password;
  final String patientEmail;
  const UpdateMeetingForm(
      {super.key,
      required this.sessionId,
      required this.password,
      required this.patientName,
      required this.roomId,
      required this.patientEmail});

  @override
  State<UpdateMeetingForm> createState() => _CreateMeetingFormState();
}

class _CreateMeetingFormState extends State<UpdateMeetingForm> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final meetingController = Get.put(MeetingContoller());
  final sendEmailontroller = Get.put(SendEmailController());

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Patient Name : ${widget.patientName}",
              style: tpharagraph3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Room ID : ${widget.roomId}",
              style: tpharagraph3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Password :${widget.password}",
              style: tpharagraph3,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              controller: dateController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.calendar_month_outlined),
                labelText: "Date ",
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    dateController.text = formattedDate;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              controller: timeController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.more_time_outlined),
                labelText: "Time",
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, child) {
                    return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                            // Using 12-Hour format
                            alwaysUse24HourFormat: false),
                        child: child!);
                  },
                );

                if (pickedTime != null) {
                  setState(() {
                    print('done');

                    //timeController.text = pickedTime.format(context);
                    final formattedTime = DateFormat('h:mm a').format(
                      DateTime(2023, 1, 1, pickedTime.hour, pickedTime.minute),
                    );
                    timeController.text = formattedTime;
                  });
                }
              },
            ),
          ),
          ButtonPrimary(
              text: "Create ",
              onTap: () {
                if (dateController.text.isEmpty ||
                    timeController.text.isEmpty) {
                  message(context, "All fields are required");
                } else {
                  String newDate = dateController.text.trim();
                  String newTime = timeController.text.trim();

                  meetingController.updateMeeting(
                      widget.sessionId,
                      widget.roomId,
                      widget.password,
                      widget.patientEmail,
                      newDate,
                      newTime);
                }
              })
        ],
      ),
    );
  }
}

void message(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
