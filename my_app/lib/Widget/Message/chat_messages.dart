import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/message_controller.dart';
import 'package:my_app/DatabaseCollection/message_collection.dart';
import 'package:my_app/Repository/MessageRepository/message_repository.dart';
// import 'package:provider/provider.dart';
// import '../../model/message.dart';
// import '../../provider/firebase_provider.dart';
import 'empty_widget.dart';
import 'message_bubble.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages(
      {super.key, required this.receiverEmail, required this.currentUserId});
  final String receiverEmail;
  final String currentUserId;

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final msgController = Get.put(MessageController());

  String? receiverId;

  @override
  void initState() {
    super.initState();
    // Fetch the receiver's ID using the controller.
    initializeReceiverId();
  }

  Future<void> initializeReceiverId() async {
    try {
      final String? id =
          await msgController.getReceiverId(widget.receiverEmail);
      print("ReceiEmail Msg:${widget.receiverEmail}");
      print("CurrentIdEmail msg:${widget.currentUserId}");
      if (id != null && id.isNotEmpty) {
        setState(() {
          receiverId = id;
        });
      }
      print(receiverId);
    } catch (error) {
      print("Error initializing receiverId: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    //  StreamBuilder<List<MessageCollection>>(
    //   stream:
    //       msgController.getMessage(widget.currentUserId, widget.receiverEmail),
    return FutureBuilder<List<MessageCollection>>(
      future:
          msgController.getMessage(widget.currentUserId, widget.receiverEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error fetching messages: ${snapshot.error}");
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No messages available.'));
        } else {
          final messages = snapshot.data!;
          print(messages);
          return Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isMe = receiverId == messages[index].senderId;
                print(
                    "SenderId:${messages[index].senderId} / receiverId $receiverId");

                final isTextMessage =
                    messages[index].messageType == MessageType.text;
                return isTextMessage
                    ? MessageBubble(
                        isMe: isMe,
                        isImage: false,
                        message: messages[index],
                      )
                    : MessageBubble(
                        isMe: isMe,
                        isImage: true,
                        message: messages[index],
                      );
              },
            ),
          );
        }
      },
    );
  }
}
