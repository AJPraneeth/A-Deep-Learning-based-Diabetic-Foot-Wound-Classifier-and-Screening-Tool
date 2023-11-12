import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/add_doctor_controller.dart';
import 'package:my_app/Widget/button_primary.dart';

class AddDoctorForm extends StatelessWidget {
  final String patientEmail;
  const AddDoctorForm({super.key, required this.patientEmail});

  @override
  Widget build(BuildContext context) {
    TextEditingController doctorEmailContorller = TextEditingController();
    TextEditingController doctorIDController = TextEditingController();
    final addDocController = Get.put(AddDoctorController());
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter the email Address";
                }

                final isEmailValid =
                    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);

                if (!isEmailValid) {
                  return "Enter Valid Email Address";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: doctorEmailContorller,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "Doctor Email",
                  hintText: "Doctor Email"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter the DoctorId ";
                }
              },
              controller: doctorIDController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.userDoctor),
                  labelText: "Doctor ID",
                  hintText: "Doctor ID"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ButtonPrimary(
              text: "Add Doctor",
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  if (doctorEmailContorller.text.isEmpty ||
                      doctorIDController.text.isEmpty) {
                    message(context, "All fields are required");
                  } else {
                    print("Add your Doctor");
                    int intDoctorId = int.parse(doctorIDController.text.trim());
                    addDocController.registerPatientDoctor(patientEmail,
                        doctorEmailContorller.text.trim(), intDoctorId);
                  }
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
