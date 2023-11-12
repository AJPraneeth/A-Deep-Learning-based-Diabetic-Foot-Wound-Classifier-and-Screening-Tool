import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Repository/DoctorPatientRepository/doctor_patient_repository.dart';
import 'package:my_app/Repository/UserRepository/userrepository.dart';
import 'package:my_app/Repository/WoundRepository/wound_repository.dart';

class DoctorPatientController extends GetxController {
  static DoctorPatientController get instance => Get.find();
  final doctorPatientRepo = Get.put(DoctorPatientRepository());
  final userPatientRepo = Get.put(UserRepository());
  final woundRepo = Get.put(WoundRepository());
  listAllDoctorPatientDetails(doctorUserId) {
    return doctorPatientRepo.getDoctorPatients(doctorUserId);
  }

  getDoctorEmail(patientEmail) {
    return doctorPatientRepo.getDoctorEmail(patientEmail);
  }

  getDoctorDetails(doctorEmail) {
    return userPatientRepo.getUserDetails(doctorEmail);
  }

  Future<List<PatientDetails>> getPatientsDeatils(doctorUserId) {
    return doctorPatientRepo.getPatientDetails(doctorUserId);
  }

  Future<UserCollection> patientProfile(email) {
    return userPatientRepo.getUserDetails(email);
  }

  Future<List<woundImage>> getwoundImage(userId) async {
    return await woundRepo.getWoundImage(userId);
  }
}
