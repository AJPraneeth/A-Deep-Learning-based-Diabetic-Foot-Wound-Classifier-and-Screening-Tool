import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:my_app/Repository/Authentication_Repostoty/authentication_repository.dart';

class MailVerificationController extends GetxController {
  static MailVerificationController get instance => Get.find();
  late Timer _timer;
  @override
  void onInit() {
    super.onInit();
    sendVerificationEmail();
    SetTimeForAutoRedirection();
  }

  Future<void> sendVerificationEmail() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void SetTimeForAutoRedirection() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified) {
        timer.cancel();
        AuthenticationRepository.instance.setIntialScreen(user);
      }
    });
  }

  void manuallyCheckEmailVerificationStatus() {
    FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      AuthenticationRepository.instance.setIntialScreen(user);
    }
  }
}
