import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:my_app/Controller/send_email_controller.dart';
import 'package:my_app/DatabaseCollection/meeting_collection.dart';
import 'package:my_app/Screen/call_screen.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Screen/doctor_schedual_screen.dart';

class MeetingRepository extends GetxController {
  static MeetingRepository get instance => Get.find();
  final db = FirebaseFirestore.instance;
  final controller = Get.put(SendEmailController());

  createMeeting(
    MeetingCollection meeting,
  ) async {
    String email = meeting.patientEmail ?? '';
    String? roomId = meeting.roomId;
    String? password = meeting.password;
    String? date = meeting.date;
    String? time = meeting.time;
    String subject = "New Session with Your Doctor";
    String description =
        "RoomId:$roomId\n Password:$password\n Date:$date\n Time:$time";
    try {
      await db.collection("Meeting").add(meeting.toJson()).whenComplete(() {
        Get.snackbar(
          "Success",
          "Your meeting has scheduled",
          snackPosition: SnackPosition.TOP,
        );
        controller.sendEmail(email, subject, description);
        Get.to(() => const Dashboard());
      });
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error",
        "Somthing went Wrong",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> checkMeetingDetails(
      String roomID, String password, String userId, String userName) async {
    try {
      final meetingSnapshot = await FirebaseFirestore.instance
          .collection('Meeting')
          .where("RoomID", isEqualTo: roomID)
          .where("Password", isEqualTo: password)
          .get();

      final meetingDocs = meetingSnapshot.docs;

      if (meetingDocs.isNotEmpty) {
        final meetingData = meetingDocs.first.data();
        final scheduledDate = meetingData['Date'] as String;
        final scheduledTime = meetingData['Time'] as String;
        final convertedTime = convertTo24HourFormat(scheduledTime);
        print(convertedTime);
        final formattedScheduledDateTime =
            '$scheduledDate $convertedTime'; // Combine date and time strings
        print(formattedScheduledDateTime);
        final scheduledDateTime = DateTime.parse(formattedScheduledDateTime);
        final currentDateTime = DateTime.now();

        if (currentDateTime.isBefore(scheduledDateTime)) {
          print('Meeting has not started yet.');
          Get.snackbar(
            "Fail",
            "Meeting has not started yet.",
            snackPosition: SnackPosition.TOP,
          );
        } else if (currentDateTime
            .isAfter(scheduledDateTime.add(const Duration(hours: 1)))) {
          print('Meeting has ended.');
          Get.snackbar(
            "Fail",
            "Meeting has ended.",
            snackPosition: SnackPosition.TOP,
          );
        } else {
          print('Meeting is currently ongoing.');

          Get.snackbar(
            "Success",
            "Meeting is currently ongoing.",
            snackPosition: SnackPosition.TOP,
          );
          // Proceed to join the meeting
          Get.to(() =>
              CallPage(callID: roomID, userID: userId, userName: userName));
        }
      } else {
        print('Meeting not found.');
        Get.snackbar(
          "Error",
          "Somthing Gonna wrong.",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('Error fetching meeting details: $e');
      Get.snackbar(
        "Error",
        "Somthing Gonna wrong.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> doctorCheckMeetingDetails(
      String roomID, String userId, String userName) async {
    try {
      final meetingSnapshot = await FirebaseFirestore.instance
          .collection('Meeting')
          .where("RoomID", isEqualTo: roomID)
          .get();

      final meetingDocs = meetingSnapshot.docs;

      if (meetingDocs.isNotEmpty) {
        final meetingData = meetingDocs.first.data();
        final scheduledDate = meetingData['Date'] as String;
        final scheduledTime = meetingData['Time'] as String;
        final convertedTime = convertTo24HourFormat(scheduledTime);

        final formattedScheduledDateTime =
            '$scheduledDate $convertedTime'; // Combine date and time strings

        final scheduledDateTime = DateTime.parse(formattedScheduledDateTime);
        final currentDateTime = DateTime.now();

        if (currentDateTime.isBefore(scheduledDateTime)) {
          print('Meeting has not started yet.');
          Get.snackbar(
            "Fail",
            "Meeting has not started yet.",
            snackPosition: SnackPosition.TOP,
          );
        } else if (currentDateTime
            .isAfter(scheduledDateTime.add(const Duration(hours: 1)))) {
          print('Meeting has ended.');
          Get.snackbar(
            "Fail",
            "Meeting has ended.",
            snackPosition: SnackPosition.TOP,
          );
        } else {
          print('Meeting is currently ongoing.');

          Get.snackbar(
            "Success",
            "Meeting is currently ongoing.",
            snackPosition: SnackPosition.TOP,
          );
          // Proceed to join the meeting
          Get.to(() =>
              CallPage(callID: roomID, userID: userId, userName: userName));
        }
      } else {
        print('Meeting not found.');
        Get.snackbar(
          "Error",
          "Somthing Gonna wrong.",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('Error fetching meeting details: $e');
      Get.snackbar(
        "Error",
        "Somthing Gonna wrong.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<List<MeetingCollectionWithId>> getAllDoctorMeeting(
    String doctorUserID,
    String filter,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    print("Today is: $now");
    final allDoctorMeetingListSnapshot = await db
        .collection("Meeting")
        .where("DoctorUserID", isEqualTo: doctorUserID)
        .get();
    final allDoctorMeetingListDocs = allDoctorMeetingListSnapshot.docs;
    List<MeetingCollectionWithId> meetings = [];
    for (var doc in allDoctorMeetingListDocs) {
      Map<String, dynamic> meetingData = doc.data();
      String meetingDateStr = meetingData["Date"];
      String meetingTimeStr = convertTo24HourFormat(meetingData["Time"]);

      DateTime meetingDateOnly = DateTime.parse(meetingDateStr);

      String meetingStatus;
      if (meetingDateOnly.isBefore(today)) {
        // Past meeting
        meetingStatus = "Past";
      } else if (meetingDateOnly.isAfter(today)) {
        // Current meeting
        meetingStatus = "Upcoming";
      } else {
        // Upcoming meeting
        meetingStatus = "Current";
      }

      MeetingCollectionWithId meetingWithId = MeetingCollectionWithId(
        id: doc.id,
        patientEmail: meetingData["PatientEmail"] ?? "",
        roomId: meetingData["RoomID"] ?? "",
        password: meetingData["Password"] ?? "",
        date: meetingData["Date"] ?? "",
        time: meetingData["Time"] ?? "",
        doctorUserId: meetingData["DoctorUserID"] ?? "",
        patientName: meetingData["PatienName"] ?? "",
      );

      if (filter == "Past" && meetingStatus == "Past") {
        meetings.add(meetingWithId);
      } else if (filter == "Current" && meetingStatus == "Current") {
        meetings.add(meetingWithId);
      } else if (filter == "Upcoming" && meetingStatus == "Upcoming") {
        meetings.add(meetingWithId);
      }
    }

    // Sort meetings based on your criteria here if needed.
    meetings.sort((a, b) {
      String aConvertTime = convertTo24HourFormat(a.time ?? '');
      String bConvertTime = convertTo24HourFormat(b.time ?? '');
      DateTime aDateTime = DateTime.parse("${a.date} $aConvertTime");
      DateTime bDateTime = DateTime.parse("${b.date} $bConvertTime");
      // Sort in descending order by time
      return bDateTime.compareTo(aDateTime);
    });
    return meetings;
  }

  Future<List<Map<String, dynamic>>> getAllPatientMeeting(
      String patientEmail, String filter) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    print(now);
    final allDoctorMeetingListSnapshot = await db
        .collection("Meeting")
        .where("PatientEmail", isEqualTo: patientEmail)
        .get();
    final allDoctorMeetingListDocs = allDoctorMeetingListSnapshot.docs;
    List<Map<String, dynamic>> meetings = [];
    for (var doc in allDoctorMeetingListDocs) {
      Map<String, dynamic> meetingData = doc.data();
      String meetingDateStr = meetingData["Date"];
      //String meetingTimeStr = convertTo24HourFormat(meetingData["Time"]);

      DateTime meetingDateOnly = DateTime.parse(meetingDateStr);

      if (meetingDateOnly.isBefore(today)) {
        // Past meeting

        meetingData["MeetingStatus"] = "Past";
      } else if (meetingDateOnly.isAfter(today)) {
        // Current meeting

        meetingData["MeetingStatus"] = "Upcoming";
      } else {
        // Upcoming meeting

        meetingData["MeetingStatus"] = "Current";
      }

      meetings.add(meetingData);
    }

    if (filter == "Past") {
      meetings = meetings
          .where((meeting) => meeting["MeetingStatus"] == "Past")
          .toList();
    } else if (filter == "Current") {
      meetings = meetings
          .where((meeting) => meeting["MeetingStatus"] == "Current")
          .toList();
    } else if (filter == "Upcoming") {
      meetings = meetings
          .where((meeting) => meeting["MeetingStatus"] == "Upcoming")
          .toList();
    }

    meetings.sort((a, b) {
      var statusComparison = a["MeetingStatus"].compareTo(b["MeetingStatus"]);
      if (statusComparison != 0) {
        return statusComparison;
      }
      String aConvertTime = convertTo24HourFormat(a["Time"]);
      String bConvertTime = convertTo24HourFormat(b["Time"]);
      DateTime aDateTime = DateTime.parse("${a["Date"]} $aConvertTime");
      DateTime bDateTime = DateTime.parse("${b["Date"]} $bConvertTime");
      // Sort in descending order by time
      return bDateTime.compareTo(aDateTime);
    });

    return meetings;
  }

  Future<void> updateMeeting(
      sessionId, newTime, newDate, patientEmail, roomId, password) async {
    try {
      final meetingRef = db.collection("Meeting").doc(sessionId);
      String email = patientEmail;
      String date = newDate;
      String time = newTime;
      String subject = "Updated Session";
      String description =
          "Your Doctor update your session .Your new session deatiels are:\n RoomId:$roomId\n Password:$password\n Date:$date\n Time:$time";
      // Update the meeting data with the new time and date
      await meetingRef.update({
        "Time": newTime,
        "Date": newDate,
      });

      print("Meeting updated successfully");
      Get.snackbar(
        "Success",
        "Meeting updated successfully",
      );
      controller.sendEmail(email, subject, description);
      Get.to(() => const Dashboard());
    } catch (e) {
      print("Error updating meeting: $e");
      Get.snackbar(
        "Error",
        "Something gone Wrong",
      );
      throw e;
    }
  }
}

String convertTo24HourFormat(String time12Hour) {
  // Splitting the time into hours, minutes, and AM/PM components
  final parts = time12Hour.split(' ');
  final timeParts = parts[0].split(':');
  final hours = int.parse(timeParts[0]);
  final minutes = int.parse(timeParts[1]);
  final isPM = parts[1].toUpperCase() == 'PM';

  // Converting to 24-hour format
  int convertedHours = hours;
  if (isPM && hours != 12) {
    convertedHours = hours + 12;
  } else if (!isPM && hours == 12) {
    convertedHours = 0;
  }

  // Formatting the time in 24-hour format
  final formattedTime =
      '${convertedHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  return formattedTime;
}
