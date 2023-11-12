import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/doctor_patient_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Repository/DoctorPatientRepository/doctor_patient_repository.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Card/patient_list_card.dart';
import 'package:my_app/Widget/bottomNavBar.dart';

class PratienDetailsViewScreen extends StatefulWidget {
  final UserCollection userData;
  const PratienDetailsViewScreen({super.key, required this.userData});

  @override
  State<PratienDetailsViewScreen> createState() =>
      _PratienDetailsViewScreenState();
}

class _PratienDetailsViewScreenState extends State<PratienDetailsViewScreen> {
  final controller = Get.put(DoctorPatientController());
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: blackColor,
        ),
        centerTitle: true,
        title: Text(
          "Patients",
          style: tpharagraph4.copyWith(color: blackColor),
        ),
      ),
      bottomNavigationBar: BottomNavBar(userData: widget.userData),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 4, // Blur radius
                    offset: const Offset(0, 2), // Shadow offset
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search_outlined),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "List Of Patients",
              style: tpharagraph3,
            ),
          ),
          FutureBuilder<List<PatientDetails>>(
              future: controller.getPatientsDeatils(widget.userData.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error:${snapshot.error}");
                } else if (snapshot.hasData) {
                  //succuess
                  final patientsListCard = snapshot.data!
                      .where((patient) => (patient.firstName
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          patient.lastName
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          patient.email
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase())))
                      .map((user) {
                    String userName = "${user.firstName} ${user.lastName}";
                    return PatientListCard(
                      patinetName: userName,
                      patient: user,
                      userData: widget.userData,
                    );
                  }).toList();

                  return Column(
                    children: patientsListCard,
                  );
                } else {
                  return Text("Someting Gone Wrong,Try again");
                }
              })
        ],
      ),
    ));
  }
}
