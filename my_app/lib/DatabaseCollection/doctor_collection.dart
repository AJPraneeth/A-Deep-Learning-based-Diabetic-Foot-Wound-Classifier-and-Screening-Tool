class DoctorCollection {
  final String? id;
  final int? doctorId;
  final String? firstName;
  final String? lastName;
  final String? dOB;
  final String? gender;
  final String email;
  final String password;
  final String? address;
  final String? medicalRegisterNumber;
  final String? medicalQualification;
  final String? mobileNo;

  const DoctorCollection(
      {this.id,
      this.doctorId,
      this.firstName,
      this.lastName,
      this.dOB,
      this.gender,
      required this.email,
      required this.password,
      this.address,
      this.mobileNo,
      this.medicalQualification,
      this.medicalRegisterNumber});

  toJson() {
    return {
      "DoctorID": doctorId,
      "FirstName": firstName,
      "LastName": lastName,
      "DOB": dOB,
      "Gender": gender,
      "Email": email,
      "Password": password,
      "Address": address,
      "MobileNo": mobileNo,
      "MedicalRegisterNumber": medicalRegisterNumber,
      "MedicalQualification": medicalQualification,
      "Usertype": "Doctor",
      "status": "Active"
    };
  }
}
