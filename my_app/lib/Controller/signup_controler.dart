import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/doctor_collection.dart';
import 'package:my_app/DatabaseCollection/patient_collection.dart';
import 'package:my_app/Repository/Authentication_Repostoty/authentication_repository.dart';
import 'package:my_app/Repository/UserRepository/userrepository.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  //Text feild controller get the data form text field

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final dob = TextEditingController();
  //final gender = TextEditingController();
  final RxString gender = "".obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final mobileNumber = TextEditingController();
  final address = TextEditingController();
  final curentMedication = TextEditingController();
  final medicalRegNumber = TextEditingController();
  final medicalQulification = TextEditingController();

  final userRepo = Get.put(UserRepository());

//this call from register screen
  void phoneAuthentication(String phoneNo) {
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }

  Future<bool> alreadyExist(email) async {
    return await userRepo.doesAccountExist(email);
  }

  void registerUser(
    String email,
    String password,
  ) async {
    final auth = AuthenticationRepository.instance;
    await auth.createUserWithEmailAndPassword(email, password);
    await auth.setIntialScreen(auth.firebaseUser as User?);
  }

  Future<void> createPatient(PatientCollection user) async {
    registerUser(user.email, user.password);
    await userRepo.createPatient(user);
    //phoneAuthentication(user.mobileNo);
    //Get.to(() => const Dashboard());
  }

  Future<void> createDoctor(DoctorCollection user) async {
    registerUser(user.email, user.password);
    await userRepo.createDoctor(user);
    //phoneAuthentication(user.mobileNo);
    //Get.to(() => const Dashboard());
  }

  clear() {
    firstName.clear();
    lastName.clear();
    dob.clear();

    email.clear();
    password.clear();
    mobileNumber.clear();
    address.clear();
    curentMedication.clear();
    medicalRegNumber.clear();
    medicalQulification.clear();
  }
}
