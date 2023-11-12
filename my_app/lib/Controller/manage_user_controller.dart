import 'package:get/get.dart';
import 'package:my_app/Repository/UserRepository/userrepository.dart';

class ManageUserController extends GetxController {
  static ManageUserController get instance => Get.find();

  final userRepo = Get.put(UserRepository());

  allUsers() {
    return userRepo.allUser();
  }

  // deactiveUser(email, userName) {
  //   return userRepo.disableAccount(email, userName);
  // }

  // activeUser(email, userName) {
  //   return userRepo.enableAccount(email, userName);
  // }

  deactiveUser(email, userName) {
    return userRepo.accountDeactive(email, userName);
  }

  activeUser(email, userName) {
    return userRepo.accountActive(email, userName);
  }
}
