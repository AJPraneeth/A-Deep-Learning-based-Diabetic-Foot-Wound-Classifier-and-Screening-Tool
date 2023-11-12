import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:my_app/Repository/Authentication_Repostoty/google_auth_sign_in.dart';

class SendEmailController extends GetxController {
  static SendEmailController get instance => Get.find();

  final receiverEmailController = TextEditingController();
  final subjectController = TextEditingController();
  final discriptionController = TextEditingController();

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future sendEmail(
      String receiveremail, String subject, String description) async {
    final user = await GoogleAuthAPI.signIn();
    //const email = 'praneethdhananjaya99@gmail.com';
    if (user == null) return;
    final email = user.email;
    final auth = await user.authentication;
    final token = auth.accessToken!;
    // print('email:$email');
    // print(receiveremail);
    // print(subject);
    // print(description);
    final smtpServer = gmailSaslXoauth2(email, token);
    final message = Message()
      ..from = Address(email, "Admin")
      ..recipients = [receiveremail]
      ..subject = subject
      ..text = description;

    try {
      await send(message, smtpServer);
      // showSnackBar(Get.context!, "Sent Email Succussfully");
      Get.snackbar("Success", "Sent Email Succesfully");
    } on MailerException catch (e) {
      print(e);
      Get.snackbar("Error", "Something Went wrong!");
    }
  }
}
