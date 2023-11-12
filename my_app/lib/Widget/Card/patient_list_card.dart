import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Repository/DoctorPatientRepository/doctor_patient_repository.dart';
import 'package:my_app/Screen/doctor_patients_nav_rail_screen.dart';

import 'package:my_app/Theme/theme.dart';

class PatientListCard extends StatelessWidget {
  final String patinetName;

  final PatientDetails patient;
  final UserCollection userData;
  const PatientListCard(
      {super.key,
      required this.patinetName,
      required this.patient,
      required this.userData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Add elevation to give it a shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        // Adjust the radius as needed
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            patinetName,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            patient.email,
            style: TextStyle(fontSize: 15),
          ),
          leading: CircleAvatar(
            backgroundColor: blackColor.withOpacity(0.6),
            foregroundColor: white,
            child: const Icon(FontAwesomeIcons.user),
          ),
          trailing: Text(patient.status.toString()),
          tileColor: Colors.black12,
          onTap: () {
            //patient list
            Get.to(() => DoctorPatientNavRailScreen(
                  patient: patient,
                  userData: userData,
                ));
          },
        ),
      ),
    );
  }
}
