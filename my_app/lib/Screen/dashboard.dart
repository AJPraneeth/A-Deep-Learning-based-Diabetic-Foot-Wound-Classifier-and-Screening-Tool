import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/profile_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/analyze_screen.dart';
import 'package:my_app/Screen/chats_screen.dart';
import 'package:my_app/Screen/manage_user_screen.dart';
import 'package:my_app/Screen/create_meeting_screen.dart';
import 'package:my_app/Screen/doctor_join_meeting_screen.dart';
import 'package:my_app/Screen/join_meeting_screen.dart';
import 'package:my_app/Screen/doctor_schedual_screen.dart';
import 'package:my_app/Screen/patient_chat_screen.dart';
import 'package:my_app/Screen/patient_schedual_screen.dart';
import 'package:my_app/Screen/patients_details_view_screen.dart';
import 'package:my_app/Screen/profile_screen.dart';
import 'package:my_app/Screen/wound_capture_upload_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Card/dashborad_card.dart';
import 'package:my_app/Widget/nav_drawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool hasDoctor = false;
  String userType = "Patient";
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return SafeArea(
      child: FutureBuilder(
        future: controller.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              UserCollection userData = snapshot.data as UserCollection;
              String firstname = userData.firstName;
              String lastname = userData.lastName;
              hasDoctor = userData.hasDoctor ?? false;
              userType = userData.userType ?? "Patient";
              String doctorId = userData.doctorId.toString();
              String userEmail = userData.email;
              String userId = userData.id ?? "null";
              String? userName = '$firstname $lastname';
              String? callId = "$userName 123";

              return Scaffold(
                drawer: NavDrawer(
                  userType: userType,
                  hasDoctor: hasDoctor,
                  userEmail: userEmail,
                  userdata: userData,
                ),
                backgroundColor: white,
                appBar: AppBar(
                  backgroundColor: white,
                  leading: Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: blackColor,
                        ),
                      );
                    },
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
                    // Respond to item press.
                    setState(() {
                      _currentIndex = value;
                      if (_currentIndex == 1) {
                        Get.to(() => ProfileScreen(
                              userdata: userData,
                              bottomNegigatorIndex: _currentIndex,
                            ));
                      } else if (_currentIndex == 2) {
                        if (userType == "Doctor") {
                          Get.to(() => ChatsScreen(
                                userdata: userData,
                              ));
                        } else {
                          Get.to(() => PatientChatScreen(userdata: userData));
                        }
                      }
                    });
                  },
                  items: [
                    const BottomNavigationBarItem(
                      label: 'Home',
                      icon: Icon(Icons.home),
                    ),
                    const BottomNavigationBarItem(
                      label: "Profile",
                      icon: Icon(FontAwesomeIcons.user),
                    ),
                    if (userType != "Admin")
                      const BottomNavigationBarItem(
                        label: "Message",
                        icon: Icon(Icons.chat_bubble_outline),
                      ),
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (userType == "Doctor")
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "DR.",
                              style: tpharagraph4,
                            ),
                          ),
                        if (userType != "Doctor")
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Hello !",
                              style: tpharagraph4,
                            ),
                          ),
                        Text(
                          "$firstname $lastname",
                          style: tpharagraph3,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    if (userType == "Doctor")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Doctor ID:",
                              style: tpharagraph3,
                            ),
                          ),
                          Text(
                            "$doctorId",
                            style: tpharagraph3,
                          )
                        ],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Feature",
                        style: title,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (userType == "Admin")
                            DashboradCard(
                                onTap: () {
                                  Get.to(() => const ManageUserScreen());
                                },
                                title: "Manage\nUser",
                                icon: Icons.account_circle_outlined),
                          if (userType != "Admin")
                            DashboradCard(
                                onTap: () {
                                  Get.to(WoundCaptureUploadScreen(
                                    userId: userId,
                                    userType: userType,
                                    userData: userData,
                                  ));
                                },
                                title: " Wound\nScreen",
                                icon: FontAwesomeIcons.camera),
                          if (userType == "Doctor")
                            DashboradCard(
                                onTap: () {
                                  Get.to(DoctorSchedualScreen(
                                    doctorUserID: userId,
                                    usertype: userType,
                                    doctorName: userName,
                                    userData: userData,
                                  ));
                                },
                                title: " Schedual",
                                icon: FontAwesomeIcons.calendarCheck),
                          if (userType == "Patient" && hasDoctor == true)
                            DashboradCard(
                                onTap: () {
                                  Get.to(PatientSchedualScreen(
                                    patientEmail: userEmail,
                                    usertype: userType,
                                    userData: userData,
                                  ));
                                },
                                title: " Schedual",
                                icon: FontAwesomeIcons.calendarCheck),
                          if (userType == "Doctor")
                            DashboradCard(
                              onTap: () {
                                Get.to(() => PratienDetailsViewScreen(
                                    userData: userData));
                              },
                              title: "Patients",
                              icon: FontAwesomeIcons.user,
                            ),
                          if (userType == "Patient")
                            DashboradCard(
                                onTap: () {
                                  Get.to(() => AnalyzeScreen(
                                        userData: userData,
                                      ));
                                },
                                title: " Analyze",
                                icon: FontAwesomeIcons.chartLine),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (userType == "Patient" && hasDoctor == true)
                            DashboradCard(
                              onTap: () {
                                Get.to(() => JoinMeetingScreen(
                                    userId: callId, userName: userName));
                              },
                              title: "Meet\n With \nDoctor",
                              icon: FontAwesomeIcons.userDoctor,
                            ),
                          if (userType == "Doctor")
                            DashboradCard(
                              onTap: () {
                                Get.to(() =>
                                    CreateMeetingScreen(doctorUserId: userId));
                              },
                              title: "Create\nMeeting",
                              icon: FontAwesomeIcons.video,
                            ),
                          if (userType == "Doctor")
                            DashboradCard(
                              onTap: () {
                                Get.to(() => DoctorJoinMeetingScreen(
                                    userId: callId, userName: userName));
                              },
                              title: "Join\n The \nMeeting",
                              icon: FontAwesomeIcons.circlePlus,
                            ),
                        ],
                      ),
                    )
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
        },
      ),
    );
  }
}
