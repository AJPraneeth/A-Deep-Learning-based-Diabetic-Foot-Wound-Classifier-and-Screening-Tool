import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Repository/Authentication_Repostoty/authentication_repository.dart';

class PasswordRestConroller extends GetxController {
  static PasswordRestConroller get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  void passwordRest(String email) async {
    await AuthenticationRepository.instance.passwordRest(email);
  }
}
