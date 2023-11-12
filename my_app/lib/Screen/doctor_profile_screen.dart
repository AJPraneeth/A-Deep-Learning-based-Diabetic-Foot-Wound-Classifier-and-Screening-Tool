import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/doctor_patient_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';

import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/bottomNavBar.dart';
import 'package:my_app/Widget/field_widget.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String patientEmail;
  final UserCollection userData;
  const DoctorProfileScreen(
      {super.key, required this.patientEmail, required this.userData});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final doctorPatientController = Get.put(DoctorPatientController());
  late String doctorEmail = "";

  @override
  void initState() {
    super.initState();
    loadDoctorEmail();
  }

  Future<void> loadDoctorEmail() async {
    doctorEmail =
        await doctorPatientController.getDoctorEmail(widget.patientEmail);

    setState(() {
      doctorEmail = doctorEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
            "Doctor Profile",
            style: tpharagraph4.copyWith(color: blackColor),
          ),
        ),
        bottomNavigationBar: BottomNavBar(userData: widget.userData),
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
                child: FutureBuilder<UserCollection?>(
                    future:
                        doctorPatientController.getDoctorDetails(doctorEmail),
                    builder: (context, snapshot) {
                      // ignore: unnecessary_null_comparison
                      if (doctorEmail != null) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            UserCollection doctorData =
                                snapshot.data as UserCollection;
                            print(doctorData.firstName);

                            return Column(
                              children: [
                                FiledWidget(
                                  title: "Name",
                                  fact:
                                      "${doctorData.firstName} ${doctorData.lastName}",
                                ),
                                FiledWidget(
                                  title: "Doctor ID",
                                  fact: doctorData.doctorId.toString(),
                                ),
                                FiledWidget(
                                  title: "Mobile",
                                  fact: doctorData.mobileNo,
                                ),
                                FiledWidget(
                                  title: "Email",
                                  fact: doctorData.email,
                                ),
                                FiledWidget(
                                  title: "Medical Qualification",
                                  fact: doctorData.medicalQualification,
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          } else {
                            return const Center(
                                child: Text("Something Went wrong"));
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            )
          ],
        ));
  }
}
