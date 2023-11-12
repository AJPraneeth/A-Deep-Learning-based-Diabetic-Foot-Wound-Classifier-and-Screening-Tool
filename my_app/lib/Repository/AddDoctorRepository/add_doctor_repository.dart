import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_app/Screen/dashboard.dart';

class AddDocotorRepository extends GetxController {
  static AddDocotorRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;

  Future<void> updatePatientHasDoctor(
      String patientEmail, String doctorEmail, int doctorId) async {
    final patientSnapshot = await db
        .collection("Users")
        .where("Email", isEqualTo: patientEmail)
        .where("HasDoctor", isEqualTo: false)
        .get();

    final doctorSnapshot = await db
        .collection("Users")
        .where("Email", isEqualTo: doctorEmail)
        .where("DoctorID", isEqualTo: doctorId)
        .get();

    final patientDocs = patientSnapshot.docs;
    final doctorDocs = doctorSnapshot.docs;

    if (patientDocs.isNotEmpty && doctorDocs.isNotEmpty) {
      final patientDoc = patientDocs.first;
      final doctorDoc = doctorDocs.first;

      final patientRef = patientDoc.reference;

      await patientRef.update({"HasDoctor": true});

      // Add to DoctorPatient collection
      final doctorPatientData = {
        "DoctorEmail": doctorEmail,
        "DoctorID": doctorDoc.id,
        "PatientEmail": patientEmail,
        "PatientID": patientDoc.id,
        "IsOnline": false,
      };

      await db.collection("DoctorPatient").add(doctorPatientData);
      Get.snackbar("Success", "You register Under Your Doctor");
      Get.to(() => const Dashboard());
    } else {
      Get.snackbar("Error", "Check Your Doctor Email And ID");
    }
  }
}
