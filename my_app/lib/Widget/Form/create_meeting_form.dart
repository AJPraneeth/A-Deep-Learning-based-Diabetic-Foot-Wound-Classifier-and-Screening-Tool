import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/doctor_patient_controller.dart';
import 'package:my_app/Controller/meeting_controller.dart';
import 'package:my_app/Controller/send_email_controller.dart';
import 'package:my_app/DatabaseCollection/meeting_collection.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/button_primary.dart';
import 'package:intl/intl.dart';

class CreateMeetingForm extends StatefulWidget {
  final String doctorUserId;
  const CreateMeetingForm({super.key, required this.doctorUserId});

  @override
  State<CreateMeetingForm> createState() => _CreateMeetingFormState();
}

class _CreateMeetingFormState extends State<CreateMeetingForm> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final meetingController = Get.put(MeetingContoller());
  final sendEmailontroller = Get.put(SendEmailController());

  int generatedRoomId = 0;
  String generatedPassword = '';

  Map<String, dynamic>? selectedPatient;
  late Future<List<Map<String, dynamic>>> fetchPatients;

  @override
  void initState() {
    super.initState();
    generatedRoomId = randomNumber();
    generatedPassword = generateRandomPassword();
    fetchPatients = fetchPatientNames();
  }

  Future<List<Map<String, dynamic>>> fetchPatientNames() async {
    final controller = Get.put(DoctorPatientController());
    final patientDetails =
        await controller.listAllDoctorPatientDetails(widget.doctorUserId);

    List<Map<String, dynamic>> patientDataList = [];
    print(patientDetails);
    for (final patientDetail in patientDetails) {
      final firstName = patientDetail['FirstName'];
      final lastName = patientDetail['LastName'];
      final mergedName = '$firstName $lastName';
      final patientEmail = patientDetail['Email'];

      patientDataList.add({
        'name': mergedName,
        'email': patientEmail,
      });
    }

    return patientDataList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPatients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              //FORM
              return Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Patient Name :",
                            style: tpharagraph3,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: DropdownButton<Map<String, dynamic>>(
                              borderRadius: BorderRadius.circular(5),
                              elevation: 8,
                              isDense: true,
                              value: selectedPatient,
                              icon: const Icon(
                                FontAwesomeIcons.anglesDown,
                                size: 20,
                              ),
                              onChanged: (Map<String, dynamic>? newValue) {
                                setState(() {
                                  selectedPatient = newValue;
                                });
                              },
                              items: (snapshot.data
                                      as List<Map<String, dynamic>>)
                                  .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (Map<String, dynamic> patientData) {
                                  return DropdownMenuItem<Map<String, dynamic>>(
                                    value: patientData,
                                    child: Text(patientData['name']),
                                  );
                                },
                              ).toList(),
                              hint: const Text("Select"),
                              itemHeight: 50,
                              underline: Container(
                                height: 2,
                                color: blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Room ID :",
                            style: tpharagraph3,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(generatedRoomId.toString(),
                                style: tpharagraph),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Password :",
                            style: tpharagraph3,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(generatedPassword, style: tpharagraph),
                          ),
                        ],
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
                                DateTime(2023, 1, 1, pickedTime.hour,
                                    pickedTime.minute),
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
                              timeController.text.isEmpty ||
                              selectedPatient?['name'] == null) {
                            print(selectedPatient?['name']);
                            message(context, "All fields are required");
                          } else {
                            final meeting = MeetingCollection(
                                doctorUserId: widget.doctorUserId,
                                patientEmail: selectedPatient?['email'],
                                patientName: selectedPatient?['name'],
                                roomId: generatedRoomId.toString(),
                                password: generatedPassword,
                                date: dateController.text.trim(),
                                time: timeController.text.trim());

                            meetingController.createMeeting(meeting);
                          }
                        })
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Center(child: Text("Something Went wrong"));
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

void message(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

int randomNumber() {
  Random random = new Random();
  int randomNumber = random.nextInt(100000) + 1; // from 1 to 100000 included
  print("Room Id: $randomNumber");

  return randomNumber;
}

String generateRandomPassword() {
  const int passwordLength = 8;
  const String allowedChars =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

  Random random = Random();
  String password = '';

  for (int i = 0; i < passwordLength; i++) {
    int randomIndex = random.nextInt(allowedChars.length);
    password += allowedChars[randomIndex];
  }

  return password;
}
