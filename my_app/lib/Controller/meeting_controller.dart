import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/meeting_collection.dart';
import 'package:my_app/Repository/Meeting_Repository/meeting_repository.dart';

class MeetingContoller extends GetxController {
  static MeetingContoller get instance => Get.find();
  final meetingRepo = Get.put(MeetingRepository());

  Future<void> createMeeting(MeetingCollection meeting) async {
    await meetingRepo.createMeeting(meeting);
  }

  Future<void> joinMeeting(
      String roomId, String password, String userId, String userName) async {
    await meetingRepo.checkMeetingDetails(roomId, password, userId, userName);
  }

  Future<void> doctorJoinMeeting(
      String roomId, String userId, String userName) async {
    await meetingRepo.doctorCheckMeetingDetails(roomId, userId, userName);
  }

  Future<List<MeetingCollectionWithId>> getDoctorMeeting(
    String doctorUserID,
    String filter,
  ) async {
    return await meetingRepo.getAllDoctorMeeting(doctorUserID, filter);
  }

  Future<List<Map<String, dynamic>>> getPatientMeeting(
      String patientEmail, filter) async {
    return await meetingRepo.getAllPatientMeeting(patientEmail, filter);
  }

  Future<void> updateMeeting(
      sessionId, roomId, password, patientEmail, newDate, newTime) async {
    return await meetingRepo.updateMeeting(
        sessionId, newTime, newDate, patientEmail, roomId, password);
  }
}
