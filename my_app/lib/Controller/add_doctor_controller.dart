import 'package:get/get.dart';
import 'package:my_app/Repository/AddDoctorRepository/add_doctor_repository.dart';

class AddDoctorController extends GetxController {
  static AddDoctorController get instance => Get.find();

  final addDocRepo = Get.put(AddDocotorRepository());

  registerPatientDoctor(patientEmail, doctorEmail, doctorId) {
    return addDocRepo.updatePatientHasDoctor(
        patientEmail, doctorEmail, doctorId);
  }
}
