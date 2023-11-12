import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/send_email_controller.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Widget/button_primary.dart';

class SendEmailForm extends StatelessWidget {
  const SendEmailForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SendEmailController());
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
              controller: controller.receiverEmailController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Receiver email Address",
                  hintText: "Receiver email Address"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.subjectController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.subject_outlined),
                  labelText: "Subject",
                  hintText: "Subject"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.discriptionController,
              decoration: const InputDecoration(
                  labelText: 'Enter Your email',
                  prefixIcon: Icon(Icons.description)),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ButtonPrimary(
            text: "send",
            onTap: () {
              if (_formKey.currentState!.validate()) {
                if (controller.receiverEmailController.text.isEmpty ||
                    controller.subjectController.text.isEmpty ||
                    controller.discriptionController.text.isEmpty) {
                  showSnackBar(context, "All fields are required");
                } else {
                  print('Send msg');

                  SendEmailController.instance.sendEmail(
                      //context,
                      controller.receiverEmailController.text.trim(),
                      controller.subjectController.text.trim(),
                      controller.discriptionController.text.trim());
                  Get.to(() => const Dashboard());
                }
              }
            },
          )
        ],
      ),
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}



// // void showSnackBar(BuildContext context, String text) {
// //   final snackBar = SnackBar(
// //     content: Text(
// //       text,
// //       style: tpharagraph3,
// //     ),
// //     backgroundColor: Colors.green,
// //   );
// //   ScaffoldMessenger.of(context)
// //     ..removeCurrentMaterialBanner()
// //     ..showSnackBar(snackBar);
// // }
