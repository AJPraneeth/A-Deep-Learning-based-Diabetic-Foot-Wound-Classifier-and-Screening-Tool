import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/chats_screen.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Screen/patient_chat_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/field_widget.dart';

class ProfileScreen extends StatefulWidget {
  final UserCollection userdata;
  final bottomNegigatorIndex;
  const ProfileScreen(
      {super.key, required this.userdata, required this.bottomNegigatorIndex});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String? Fname = widget.userdata.firstName;
    String? Lname = widget.userdata.lastName;
    String Name = '$Fname $Lname';
    int _currentIndex = widget.bottomNegigatorIndex;
    return Scaffold(
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
            "Profile",
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
            // Respond to item press.
            setState(() {
              _currentIndex = value;
              if (_currentIndex == 0) {
                Get.to(() => const Dashboard());
              } else if (_currentIndex == 2) {
                if (widget.userdata.userType == "Doctor") {
                  Get.to(() => ChatsScreen(
                        userdata: widget.userdata,
                      ));
                } else {
                  Get.to(() => PatientChatScreen(userdata: widget.userdata));
                }
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
        body: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: screenWidth *
                    0.3, // Set the width and height as per your requirements
                height: screenHeight * 0.1,
                decoration: BoxDecoration(
                  color: blackColor.withOpacity(0.1),
                  shape: BoxShape.circle, // This makes the container circular
                  image: const DecorationImage(
                    image: AssetImage('assets/deafultUser.png'),
                    fit: BoxFit.cover, // Adjust the fit property as needed
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (widget.userdata.userType == 'Doctor')
                      FiledWidget(
                        title: "Doctor ID",
                        fact: widget.userdata.doctorId.toString(),
                      ),
                    FiledWidget(
                      title: "Name",
                      fact: Name,
                    ),
                    //if (widget.userdata.userType != 'Admin')
                    FiledWidget(
                      title: "Date Of Birth",
                      fact: widget.userdata.dOB,
                    ),
                    // if (widget.userdata.userType != 'Admin')
                    FiledWidget(
                      title: "Gender",
                      fact: widget.userdata.gender,
                    ),
                    // if (widget.userdata.userType != 'Admin')
                    FiledWidget(
                      title: "Mobile",
                      fact: widget.userdata.mobileNo,
                    ),
                    FiledWidget(
                      title: "Email",
                      fact: widget.userdata.email,
                    ),
                    FiledWidget(
                      title: "Address",
                      fact: widget.userdata.address,
                    ),
                    if (widget.userdata.userType == 'Patient')
                      FiledWidget(
                        title: "Current Medication",
                        fact: widget.userdata.currentMedication,
                      ),
                    if (widget.userdata.userType == 'Doctor')
                      FiledWidget(
                        title: "Medical Qualification",
                        fact: widget.userdata.medicalQualification,
                      ),
                    if (widget.userdata.userType == 'Doctor')
                      FiledWidget(
                        title: "Medical Register Number",
                        fact: widget.userdata.medicalRegisterNumber,
                      ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
