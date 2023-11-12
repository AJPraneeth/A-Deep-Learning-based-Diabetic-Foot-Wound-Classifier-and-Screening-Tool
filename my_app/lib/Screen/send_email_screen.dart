import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Form/send_email_form.dart';

class SendEmailScreen extends StatelessWidget {
  const SendEmailScreen({super.key});

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
            title: const Text(
              "back",
              style: TextStyle(color: blackColor),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Send Your Email', style: tpharagraph3),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(5.0),
                //   child: Text(
                //     'Type  Your mail',
                //     style: tpharagraph2,
                //   ),
                // ),
                const SendEmailForm()
              ],
            ),
          )),
    );
  }
}
