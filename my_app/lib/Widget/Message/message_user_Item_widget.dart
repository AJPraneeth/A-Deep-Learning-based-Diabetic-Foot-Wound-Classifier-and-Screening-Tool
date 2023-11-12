import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/chat_screen.dart';

import 'package:my_app/Theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageUserItemWidget extends StatefulWidget {
  final Map<String, dynamic> patient;
  final UserCollection userdata;
  const MessageUserItemWidget(
      {super.key, required this.patient, required this.userdata});

  @override
  State<MessageUserItemWidget> createState() => _MessageUserItemWidgetState();
}

class _MessageUserItemWidgetState extends State<MessageUserItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 30,
              child: Icon(
                FontAwesomeIcons.user,
              ),
              backgroundColor: blackColor.withOpacity(0.6),
              foregroundColor: white,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 10),
            //   child: CircleAvatar(
            //     backgroundColor:
            //         widget.user.isOnline ? Colors.green : Colors.grey,
            //     radius: 5,
            //   ),
            // ),
          ],
        ),
        title: Text(
          widget.patient['name'],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // subtitle: Text(
        //   'Last Active : ${timeago.format(widget.user.lastActive)}',
        //   maxLines: 2,
        //   style: const TextStyle(
        //     color: mainColor,
        //     fontSize: 15,
        //     overflow: TextOverflow.ellipsis,
        //   ),
        // ),
        onTap: () {
          Get.to(() => ChatScreen(
                userdata: widget.userdata,
                patient: widget.patient,
              ));
        },
      ),
    );
  }
}
