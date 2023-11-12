import 'package:cloud_firestore/cloud_firestore.dart';

class PatientCollection {
  final String? id;
  final String firstName;
  final String lastName;
  final String dOB;
  final String gender;
  final String email;
  final String password;
  final String address;
  final String currentMedication;
  final String mobileNo;
  String? userType;
  String? status;
  bool? hasDoctor;

  PatientCollection(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.dOB,
      required this.gender,
      required this.email,
      required this.password,
      required this.address,
      required this.mobileNo,
      required this.currentMedication,
      this.status,
      this.hasDoctor,
      this.userType});

  toJson() {
    return {
      "FirstName": firstName,
      "LastName": lastName,
      "DOB": dOB,
      "Gender": gender,
      "Email": email,
      "Password": password,
      "Address": address,
      "MobileNo": mobileNo,
      "CurrentMedication": currentMedication,
      "Usertype": "Patient",
      "status": "Active",
      "HasDoctor": false
    };
  }

  factory PatientCollection.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();

    return PatientCollection(
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
      userType: data?["Usertype"] ?? "",
      status: data?["status"] ?? "",
      hasDoctor: data?["HasDoctor"] ?? false,
    );
  }
}
