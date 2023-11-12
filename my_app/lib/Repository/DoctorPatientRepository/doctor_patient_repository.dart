import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';

class DoctorPatientRepository extends GetxController {
  static DoctorPatientRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getDoctorPatients(
      String doctorUserId) async {
    final doctorPatientSnapshot = await db
        .collection("DoctorPatient")
        .where("DoctorID", isEqualTo: doctorUserId)
        .get();

    final doctorPatientDocs = doctorPatientSnapshot.docs;

    List<Map<String, dynamic>> patientsData = [];

    for (final doctorPatientDoc in doctorPatientDocs) {
      final patientUserId = doctorPatientDoc["PatientID"];

      final patientSnapshot =
          await db.collection("Users").doc(patientUserId).get();

      if (patientSnapshot.exists) {
        patientsData.add(patientSnapshot.data() as Map<String, dynamic>);
      }
    }

    return patientsData;
  }

  Future<String?> getDoctorEmail(String patientEmail) async {
    final doctorPatientSnapshot = await db
        .collection("DoctorPatient")
        .where("PatientEmail", isEqualTo: patientEmail)
        .get();

    final doctorPatientDocs = doctorPatientSnapshot.docs;

    if (doctorPatientDocs.isNotEmpty) {
      final doctorEmail = doctorPatientDocs[0]["DoctorEmail"];
      return doctorEmail;
    }

    return null;
  }

  Future<List<PatientDetails>> getPatientDetails(String doctorUserId) async {
    final doctorPatientSnapshot = await db
        .collection("DoctorPatient")
        .where("DoctorID", isEqualTo: doctorUserId)
        .get();

    final doctorPatientDocs = doctorPatientSnapshot.docs;

    List<PatientDetails> patientsDataList = [];

    for (final doctorPatientDoc in doctorPatientDocs) {
      final patientUserId = doctorPatientDoc["PatientID"];

      final patientSnapshot =
          await db.collection("Users").doc(patientUserId).get();

      if (patientSnapshot.exists) {
        final patientData = PatientDetails(
            id: patientUserId,
            firstName: patientSnapshot["FirstName"],
            lastName: patientSnapshot["LastName"],
            email: patientSnapshot["Email"],
            status: patientSnapshot['status']);
        patientsDataList.add(patientData);
      }
    }

    return patientsDataList;
  }
}

class PatientDetails {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String status;

  PatientDetails(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.status});
}
