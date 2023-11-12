import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/meeting_controller.dart';
import 'package:my_app/Screen/update_meeting_screen.dart';
import 'package:my_app/Theme/theme.dart';

class SchedualCardWidget extends StatefulWidget {
  final String? usertype;
  final String? year;
  final String? mounth;
  final String? date;
  final String? roomId;
  final String? password;
  final String? patientName;
  final String? time;
  final bool? isMeetingTime;
  final String? doctorName;
  final String? id;
  final String? patientEmail;
  final String? meetingStatus;

  SchedualCardWidget(
      {super.key,
      this.year,
      this.mounth,
      this.date,
      this.password,
      this.roomId,
      this.patientName,
      this.isMeetingTime,
      this.time,
      this.usertype,
      this.doctorName,
      this.id,
      this.patientEmail,
      this.meetingStatus});

  @override
  State<SchedualCardWidget> createState() => _SchedualCardWidgetState();
}

class _SchedualCardWidgetState extends State<SchedualCardWidget> {
  final Controller = Get.put(MeetingContoller());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: gray2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // Define how the card's content should be clipped
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            if (widget.usertype == "Doctor")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Patient Name: ${widget.patientName}",
                        style: cardH3.copyWith(
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    if (widget.meetingStatus != "Past")
                      IconButton(
                        onPressed: () {
                          Get.to(() => UpdateMeetingScreen(
                                sessionId: widget.id ?? '',
                                password: widget.password ?? '',
                                roomId: widget.roomId ?? '',
                                patientName: widget.patientName ?? '',
                                patientEmail: widget.patientEmail ?? '',
                              ));
                        },
                        icon: const Icon(Icons.edit),
                        color: white,
                      )
                  ],
                ),
              ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      widget.year ?? "",
                      style: cardH1,
                    ),
                    Text(
                      widget.mounth ?? "",
                      style: cardH3,
                    ),
                    Text(
                      widget.date ?? "",
                      style: cardH1Large,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Time : ${widget.time}",
                      style: cardH3,
                    ),
                    Text(
                      "Room ID : ${widget.roomId}",
                      style: cardH3,
                    ),
                    Text(
                      "Password : ${widget.password}",
                      style: cardH3,
                    ),
                  ],
                ),
              ],
            ),
            if (widget.isMeetingTime == true)
              SizedBox(
                height: 35, // Set the desired height
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.usertype == "Doctor") {
                      Controller.doctorJoinMeeting(widget.roomId ?? '', '12344',
                          widget.doctorName ?? '');
                    } else {
                      Controller.joinMeeting(
                          widget.roomId ?? '',
                          widget.password ?? '',
                          '1234',
                          widget.patientName ?? '');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white70, // Text color
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Join",
                        style: tpharagraph3,
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
