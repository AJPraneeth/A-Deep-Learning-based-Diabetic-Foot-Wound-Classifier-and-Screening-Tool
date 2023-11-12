import 'package:get/get.dart';
import 'package:my_app/Repository/Authentication_Repostoty/authentication_repository.dart';
import 'package:my_app/Repository/UserRepository/userrepository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final authRepo = Get.put(AuthenticationRepository());
  final userRepo = Get.put(UserRepository());

  getUserData() {
    final email = authRepo.firebaseUser.value?.email;
    if (email != null) {
      return userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to continue");
    }
  }
}
