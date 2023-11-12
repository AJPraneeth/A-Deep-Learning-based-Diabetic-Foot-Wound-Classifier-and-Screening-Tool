import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/doctor_patient_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/add_doctor_screen.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Screen/profile_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Card/dialog_card.dart';
import 'package:my_app/Widget/Message/chat_messages.dart';
import 'package:my_app/Widget/Message/chat_text_field.dart';

class PatientChatScreen extends StatefulWidget {
  final UserCollection userdata;

  const PatientChatScreen({super.key, required this.userdata});

  @override
  State<PatientChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<PatientChatScreen> {
  int _currentIndex = 2;
  final doctorPatientController = Get.put(DoctorPatientController());

  @override
  void initState() {
    super.initState();
  }

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
            "Chat",
            style: tpharagraph4.copyWith(color: blackColor),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          backgroundColor: gray1,
          selectedItemColor: white,
          unselectedItemColor: blackColor,
          selectedLabelStyle: tpharagraph7,
          unselectedLabelStyle: tpharagraph7,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
              if (_currentIndex == 1) {
                Get.to(() => ProfileScreen(
                      userdata: widget.userdata,
                      bottomNegigatorIndex: _currentIndex,
                    ));
              } else if (_currentIndex == 0) {
                Get.to(() => const Dashboard());
              }
            });
          },
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(FontAwesomeIcons.user),
            ),
            BottomNavigationBarItem(
              label: "Message",
              icon: Icon(Icons.chat_bubble_outline),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<String?>(
            future:
                doctorPatientController.getDoctorEmail(widget.userdata.email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print("Patient msg error:${snapshot.error}");
                return DialogCard(
                    dialogTitle: "Connection",
                    message: "You have some connection Errors . Check Again",
                    onCancelActionName: "Go Back",
                    OnOKActionName: "Dashboard",
                    OnOKAction: () async {
                      Get.to(() => const Dashboard());
                    },
                    OnCancelAction: () {
                      Get.back();
                    },
                    dialogIcon: const Icon(
                      FontAwesomeIcons.plugCircleExclamation,
                      size: 75,
                      color: Colors.redAccent,
                    ));
              } else if (snapshot.hasData) {
                final doctorEmail = snapshot.data!;
                print("msg futute:$doctorEmail");
                return Column(
                  children: [
                    ChatMessages(
                      receiverEmail: doctorEmail,
                      currentUserId: widget.userdata.id!,
                    ),
                    ChatTextField(
                      receiverEmail: doctorEmail,
                      senderId: widget.userdata.id!,
                    ),
                  ],
                );
              } else {
                return DialogCard(
                  dialogTitle: "Info",
                  message: "You are not Register on your Doctor",
                  onCancelActionName: "Go Back",
                  OnOKActionName: "Register on Doctor",
                  OnOKAction: () async {
                    Get.to(() =>
                        AddDoctorScreen(patientEmail: widget.userdata.email));
                  },
                  OnCancelAction: () {
                    Get.back();
                  },
                  dialogIcon: const Icon(
                    FontAwesomeIcons.circleInfo,
                    size: 75,
                    color: Colors.blueAccent,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
