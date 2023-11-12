import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Repository/Authentication_Repostoty/authentication_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  void loginUser(String email, String password) async {
    final auth = AuthenticationRepository.instance;
    auth.loginUserWithEmailAndPassword(email, password);
    auth.setIntialScreen(auth.firebaseUser as User?);
    //auth.setIntialScreen(auth.firebaseUser);
  }
}
