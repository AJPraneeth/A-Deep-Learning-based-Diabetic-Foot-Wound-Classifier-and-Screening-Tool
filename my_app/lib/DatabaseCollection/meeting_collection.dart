import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingCollection {
  final String? id;
  final String? patientEmail;
  final String? patientName;
  final String? roomId;
  final String? password;
  final String? date;
  final String? time;
  final String? doctorUserId;

  const MeetingCollection(
      {this.id,
      this.patientEmail,
      this.roomId,
      this.password,
      this.date,
      this.time,
      this.doctorUserId,
      this.patientName});

  toJson() {
    return {
      "DoctorUserID": doctorUserId,
      "PatientEmail": patientEmail,
      "RoomID": roomId,
      "Password": password,
      "Date": date,
      "Time": time,
      "PatienName": patientName,
    };
  }
}

class MeetingCollectionWithId {
  final String? id;
  final String? patientEmail;
  final String? patientName;
  final String? roomId;
  final String? password;
  final String? date;
  final String? time;
  final String? doctorUserId;

  const MeetingCollectionWithId(
      {this.id,
      this.patientEmail,
      this.roomId,
      this.password,
      this.date,
      this.time,
      this.doctorUserId,
      this.patientName});

  factory MeetingCollectionWithId.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    return MeetingCollectionWithId(
      id: document.id,
      patientEmail: data?["PatientEmail"] ?? "",
      roomId: data?["RoomID"] ?? "",
      password: data?["Password"] ?? "",
      date: data?["Date"] ?? "",
      time: data?["Time"] ?? "",
      doctorUserId: data?["DoctorUserID"] ?? "",
      patientName: data?["PatienName"] ?? "",
    );
  }
}
