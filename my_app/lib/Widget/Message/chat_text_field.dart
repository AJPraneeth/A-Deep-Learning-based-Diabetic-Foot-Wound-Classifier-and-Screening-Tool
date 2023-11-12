import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/message_controller.dart';
import 'package:my_app/Theme/theme.dart';
import 'custom_text_form_field.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField(
      {super.key, required this.receiverEmail, required this.senderId});

  final String receiverEmail;
  final String senderId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();
  final msgController = Get.put(MessageController());
  //final notificationsService = NotificationsService();

  Uint8List? file;

  // @override
  // void initState() {
  //   notificationsService
  //       .getReceiverToken(widget.receiverId);
  //   super.initState();
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: controller,
              hintText: 'Add Message...',
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: mainColor,
            radius: 20,
            child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    msgController.sendTextMessage(widget.senderId,
                        widget.receiverEmail, controller.text.trim());
                    controller.clear();
                    FocusScope.of(context).unfocus();
                  } else {
                    Get.snackbar("Error", "Type Your message");
                  }
                  FocusScope.of(context).unfocus();
                }
                //_sendText(context),
                ),
          ),
          // const SizedBox(width: 5),
          // CircleAvatar(
          //   backgroundColor: mainColor,
          //   radius: 20,
          //   child: IconButton(
          //       icon: const Icon(Icons.camera_alt, color: Colors.white),
          //       onPressed: () {}
          //       // _sendImage,
          //       ),
          // ),
        ],
      );

  // Future<void> _sendImage() async {
  //   final pickedImage = await MediaService.pickImage();
  //   setState(() => file = pickedImage);
  //   if (file != null) {
  //     await FirebaseFirestoreService.addImageMessage(
  //       receiverId: widget.receiverId,
  //       file: file!,
  //     );
  //     await notificationsService.sendNotification(
  //       body: 'image........',
  //       senderId: FirebaseAuth.instance.currentUser!.uid,
  //     );
  //   }
  // }
}
