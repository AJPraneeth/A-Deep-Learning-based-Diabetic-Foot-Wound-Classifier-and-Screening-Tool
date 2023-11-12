import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/doctor_patient_controller.dart';
import 'package:my_app/Controller/manage_user_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Repository/DoctorPatientRepository/doctor_patient_repository.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/field_widget.dart';

class DoctorPatientsProfilesScreen extends StatefulWidget {
  final PatientDetails patient;
  const DoctorPatientsProfilesScreen({
    super.key,
    required this.patient,
  });

  @override
  State<DoctorPatientsProfilesScreen> createState() =>
      _DoctorPatientsProfilesScreenState();
}

class _DoctorPatientsProfilesScreenState
    extends State<DoctorPatientsProfilesScreen> {
  final controller = Get.put(DoctorPatientController());

  @override
  Widget build(BuildContext context) {
    final name = '${widget.patient.firstName} ${widget.patient.lastName}';

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
            "Profile",
            style: tpharagraph4.copyWith(color: blackColor),
          ),
        ),
        body: Expanded(
          child: SingleChildScrollView(
            child: FutureBuilder<UserCollection>(
              future: controller.patientProfile(widget.patient.email),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error:${snapshot.error}");
                } else if (snapshot.hasData) {
                  final patient = snapshot.data;

                  if (patient != null) {
                    return Column(
                      children: [
                        FiledWidget(
                          title: "Name",
                          fact: name,
                        ),
                        FiledWidget(
                          title: "Date Of Birth",
                          fact: patient.dOB,
                        ),
                        FiledWidget(
                          title: "Gender",
                          fact: patient.gender,
                        ),
                        FiledWidget(
                          title: "Mobile",
                          fact: patient.mobileNo,
                        ),
                        FiledWidget(
                          title: "Email",
                          fact: patient.email,
                        ),
                        FiledWidget(
                          title: "Address",
                          fact: patient.address,
                        ),
                        FiledWidget(
                          title: "Current Medication",
                          fact: patient.currentMedication,
                        ),
                      ],
                    );
                  } else {
                    return const Text("Patient doesn't have any details");
                  }
                }
                return Text("Something Gone Wrong");
              },
            ),
          ),
        ),
      ),
    );
  }
}
