import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Controller/signup_controler.dart';
import 'package:my_app/DatabaseCollection/doctor_collection.dart';

import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/button_primary.dart';
import 'package:get/get.dart';
import 'dart:math';

class DoctorForm extends StatefulWidget {
  const DoctorForm({super.key});

  @override
  State<DoctorForm> createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final confirmPassword = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    //final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter the First Name ";
                  } else if (!RegExp(r"^[A-Za-z]+$").hasMatch(value)) {
                    return "Please enter a valid name";
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.firstName,
                decoration: const InputDecoration(
                    labelText: "First Name", hintText: "First Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter the Last Name ";
                  } else if (!RegExp(r"^[A-Za-z]+$").hasMatch(value)) {
                    return "Please enter a valid name";
                  } else if (controller.firstName.text.trim() == value) {
                    return "First Name and last can't be same";
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.lastName,
                decoration: const InputDecoration(
                    labelText: "Last Name", hintText: "Last Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Select your Date of Birth";
                  }
                  return null;
                },
                keyboardType: TextInputType.datetime,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.dob,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                  labelText: "Date Of Birth",
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990),
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    setState(() {
                      controller.dob.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
            ),
            Text("Gender", style: tpharagraph),
            Row(
              children: [
                Flexible(
                  child: RadioListTile(
                    title: const Text("Male"),
                    value: "male",
                    groupValue: controller.gender.value,
                    onChanged: (value) {
                      setState(() {
                        controller.gender.value = value.toString();
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile(
                    title: const Text("Female"),
                    value: "female",
                    groupValue: controller.gender.value,
                    onChanged: (value) {
                      setState(() {
                        controller.gender.value = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
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
                controller: controller.email,
                decoration: const InputDecoration(
                    labelText: "Email", hintText: "Email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter the Mobile Number";
                  }

                  final isValidPhone =
                      RegExp(r"^\+?0[0-9]{9}$").hasMatch(value);

                  if (!isValidPhone) {
                    return "Enter Valid Mobile Number:Ex:-0771234567";
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"[0-9]"),
                  )
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.mobileNumber,
                decoration: const InputDecoration(
                    labelText: "Mobile Number", hintText: "Mobile Number"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter the Password";
                  }
                  if (value.length < 6) {
                    return "At least password needs 6 charaters";
                  }

                  final isValidPassword = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{6,}$')
                      .hasMatch(value);

                  if (!isValidPassword) {
                    return "At least one uppercase letter (A-Z)\nAt least one lowercase letter (a-z).\nAt least one digit (0-9).\nAt least one special character from the set (!@#\><*~).\nA minimum length of 6 characters.\n";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.password,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Password", hintText: "Password"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter the Password Again";
                  }

                  if (confirmPassword.text.trim() !=
                      controller.password.text.trim()) {
                    return "Enter the Password Correctly.Password isn't Macthed";
                  }

                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: confirmPassword,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Confirm Password"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                keyboardType: TextInputType.streetAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter the Address";
                  }

                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.address,
                decoration: const InputDecoration(
                    labelText: "Address", hintText: "Address"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Medical Register Number";
                  }

                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.medicalRegNumber,
                decoration: const InputDecoration(
                    labelText: "Medical Register Number",
                    hintText: "Medical Register Number"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Medical Qulification";
                  }

                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.medicalQulification,
                decoration:
                    const InputDecoration(labelText: 'Medical Qulification'),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
              ),
            ),
            ButtonPrimary(
              text: "Submit",
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  final exist = await controller
                      .alreadyExist(controller.email.text.trim());
                  if (exist == false) {
                    if (controller.gender.trim().isNotEmpty) {
                      final doctor = DoctorCollection(
                          doctorId: randomNumber(),
                          firstName: controller.firstName.text.trim(),
                          lastName: controller.lastName.text.trim(),
                          dOB: controller.dob.text.trim(),
                          gender: controller.gender.trim(),
                          email: controller.email.text.trim(),
                          password: controller.password.text.trim(),
                          address: controller.address.text.trim(),
                          mobileNo: controller.mobileNumber.text.trim(),
                          medicalQualification:
                              controller.medicalQulification.text.trim(),
                          medicalRegisterNumber:
                              controller.medicalRegNumber.text.trim());
                      SignupController.instance.createDoctor(doctor);
                      controller.clear();
                    } else {
                      Get.snackbar("Error", "Select Your Gender");
                    }
                  } else {
                    Get.snackbar(
                        "Error", "Your Input email address already exist");
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

int randomNumber() {
  Random random = Random();
  int randomNumber = random.nextInt(100000) + 1; // from 1 to 100000 included
  //print("Doctor Id: $randomNumber");

  return randomNumber;
}
