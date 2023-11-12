import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/meeting_controller.dart';
import 'package:my_app/DatabaseCollection/meeting_collection.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Card/schedual_card.dart';
import 'package:my_app/Widget/bottomNavBar.dart';

class DoctorSchedualScreen extends StatefulWidget {
  final String? usertype;
  final String? doctorUserID;
  final String? doctorName;
  final UserCollection userData;
  const DoctorSchedualScreen(
      {super.key,
      this.doctorUserID,
      this.usertype,
      this.doctorName,
      required this.userData});

  @override
  State<DoctorSchedualScreen> createState() => _SchedualScreenState();
}

class _SchedualScreenState extends State<DoctorSchedualScreen> {
  final meetingController = Get.put(MeetingContoller());
  late Future<List<MeetingCollectionWithId>> doctorMeetings;
  String selectedFilter = "Current";
  @override
  void initState() {
    super.initState();
    doctorMeetings = meetingController.getDoctorMeeting(
        widget.doctorUserID ?? "",
        selectedFilter); // Replace with actual doctorUserID
  }

  bool shouldShowMeeting(MeetingCollectionWithId meetingData) {
    try {
      String convertTime = convertTo24HourFormat(meetingData.time ?? '');

      String formattedTime = '${meetingData.date} $convertTime:00';
      final scheduleTime = DateTime.parse(formattedTime);
      final currentTime = DateTime.now();
      final timeDifference = scheduleTime.difference(currentTime);

      // Check if the meeting is scheduled within the next hour
      return timeDifference.inHours >= 0 && timeDifference.inHours <= 1;
    } catch (e) {
      print(e.toString());
      return false; // Return an appropriate value in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: white,
            leading: IconButton(
              onPressed: () {
                Get.to(() => const Dashboard());
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              color: blackColor,
            ),
            centerTitle: true,
            title: Text(
              "Schedual",
              style: tpharagraph4.copyWith(color: blackColor),
            ),
          ),
          bottomNavigationBar: BottomNavBar(userData: widget.userData),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = "Past";
                          doctorMeetings = meetingController.getDoctorMeeting(
                              widget.doctorUserID ?? "", selectedFilter);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedFilter == "Past" ? Colors.white : gray1,
                          foregroundColor:
                              selectedFilter == "Past" ? blackColor : white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          )),
                      child: const Center(
                        child: Text(
                          "Past",
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = "Current";
                          doctorMeetings = meetingController.getDoctorMeeting(
                              widget.doctorUserID ?? "", selectedFilter);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectedFilter == "Current"
                              ? Colors.white
                              : gray1,
                          foregroundColor:
                              selectedFilter == "Current" ? blackColor : white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          )),
                      child: const Center(
                        child: Text(
                          "Current",
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = "Upcoming";
                          doctorMeetings = meetingController.getDoctorMeeting(
                              widget.doctorUserID ?? "", selectedFilter);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectedFilter == "Upcoming"
                              ? Colors.white
                              : gray1,
                          foregroundColor:
                              selectedFilter == "Upcoming" ? blackColor : white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          )),
                      child: const Center(
                        child: Text(
                          "Upcomming",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<MeetingCollectionWithId>>(
                      future: doctorMeetings,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data!.map((meetingData) {
                                print(meetingData);
                                final isMeetingTime =
                                    shouldShowMeeting(meetingData);
                                final dateParts = meetingData.date?.split('-');
                                final year = dateParts?[0];
                                final month = dateParts?[1];
                                final day = dateParts?[2];
                                return SchedualCardWidget(
                                  year: year,
                                  mounth: month,
                                  date: day,
                                  roomId: meetingData.roomId,
                                  password: meetingData.password,
                                  isMeetingTime: isMeetingTime,
                                  usertype: widget.usertype,
                                  patientName: meetingData.patientName,
                                  time: meetingData.time,
                                  doctorName: widget.doctorName,
                                  id: meetingData.id,
                                  patientEmail: meetingData.patientEmail,
                                  meetingStatus: selectedFilter,
                                );
                              }).toList(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          } else {
                            return const Center(
                                child: Text("Something Went wrong"));
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              ),
            ],
          )),
    );
  }
}

String convertTo24HourFormat(String time12Hour) {
  final parts = time12Hour.split(' ');
  final timeParts = parts[0].split(':');
  final hours = int.parse(timeParts[0]);
  final minutes = int.parse(timeParts[1]);
  final isPM = parts[1].toUpperCase() == 'PM';

  int convertedHours = hours;
  if (isPM && hours != 12) {
    convertedHours = hours + 12;
  } else if (!isPM && hours == 12) {
    convertedHours = 0;
  }

  // final formattedTime = '$convertedHours:${minutes.toString().padLeft(2, '0')}';
  final formattedTime =
      '${convertedHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  return formattedTime;
}
