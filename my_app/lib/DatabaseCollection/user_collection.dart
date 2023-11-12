import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollection {
  final String? id;
  final int? doctorId;
  final String firstName;
  final String lastName;
  final String dOB;
  final String gender;
  final String email;
  final String password;
  final String address;
  String? currentMedication;
  final String mobileNo;
  final String? medicalRegisterNumber;
  final String? medicalQualification;
  String? userType;
  String? status;
  bool? hasDoctor;

  UserCollection(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.dOB,
      required this.gender,
      required this.email,
      required this.password,
      required this.address,
      required this.mobileNo,
      this.currentMedication,
      this.medicalQualification,
      this.medicalRegisterNumber,
      this.status,
      this.hasDoctor,
      this.userType,
      this.doctorId});

  factory UserCollection.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();

    return UserCollection(
        id: document.id,
        firstName: data?["FirstName"] ?? "",
        lastName: data?["LastName"] ?? "",
        dOB: data?["DOB"] ?? "",
        gender: data?["Gender"] ?? "",
        email: data?["Email"] ?? "",
        password: data?["Password"] ?? "",
        address: data?["Address"] ?? "",
        mobileNo: data?["MobileNo"] ?? "",
        currentMedication: data?["CurrentMedication"] ?? "",
        medicalQualification: data?["MedicalQualification"] ?? "",
        medicalRegisterNumber: data?["MedicalRegisterNumber"] ?? "",
        userType: data?["Usertype"] ?? "",
        status: data?["status"] ?? "",
        hasDoctor: data?["HasDoctor"] ?? false,
        doctorId: data?["DoctorID"]);
  }
}
