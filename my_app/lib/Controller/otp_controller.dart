import 'package:get/get.dart';
import 'package:my_app/Repository/Authentication_Repostoty/authentication_repository.dart';
import 'package:my_app/Screen/dashboard.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();
  void verifyOTP(String otp) async {
    var isVerify = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerify ? Get.offAll(const Dashboard()) : Get.back();
  }
}
