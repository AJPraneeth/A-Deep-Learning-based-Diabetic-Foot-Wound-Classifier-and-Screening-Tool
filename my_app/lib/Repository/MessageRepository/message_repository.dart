import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/message_collection.dart';

class MessageRepository extends GetxController {
  static MessageRepository get instance => Get.find();
  final db = FirebaseFirestore.instance;

  Future<void> addMessageToChat(
    String senderId,
    String receiverId,
    String receiverEmail,
    MessageCollection message,
  ) async {
    try {
      // Add the message to the sender's chat
      await db
          .collection('Users')
          .doc(senderId)
          .collection('chat')
          .doc(receiverId) // Use receiverDocId as the document ID
          .collection('messages')
          .add(message.toJson());

      // Add the message to the receiver's chat
      await db
          .collection('Users')
          .doc(receiverId)
          .collection('chat')
          .doc(senderId) // Use senderId as the document ID
          .collection('messages')
          .add(message.toJson());
// get message after send nad display it
      //getChatMessages(senderId, receiverEmail);
    } catch (error) {
      // Handle any errors here
      print('Error adding message: $error');
    }
  }

  Future<void> addTextMessage(
      {required String content,
      required String receiverEmail,
      required String senderId}) async {
    final receiverDocId = await getReciverDocID(receiverEmail) ?? '';
    final message = MessageCollection(
        content: content,
        sentTime: DateTime.now(),
        receiverId: receiverDocId,
        messageType: MessageType.text,
        senderId: senderId);
    print("ReceiEmail in addMessageToChat :$receiverEmail");

    await addMessageToChat(senderId, receiverDocId, receiverEmail, message);
  }

  Future<String?> getReciverDocID(String receiverEmail) async {
    print("ReceiEmail in getReciverDocID :$receiverEmail");
    final receiverQuerySnapshot = await db
        .collection('Users')
        .where('Email', isEqualTo: receiverEmail)
        .get();

    if (receiverQuerySnapshot.docs.isEmpty) {
      print('Sender or receiver not found');
      return null;
    }
    final receiverDocId = receiverQuerySnapshot.docs.first.id;
    // print(receiverDocId);
    return receiverDocId;
  }

// future to stream
  Future<List<MessageCollection>> getChatMessages(
      String currentId, String receiverEmail) async {
    try {
      final receiverDocId = await getReciverDocID(receiverEmail);
      // Use the parent document's reference to access the messages sub-collection
      CollectionReference messagesCollection = db
          .collection('Users')
          .doc(currentId)
          .collection('chat')
          .doc(receiverDocId)
          .collection('messages');

      QuerySnapshot messageCollectionSnapshot =
          await messagesCollection.orderBy('sentTime', descending: false).get();

      final messages = messageCollectionSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        if (data != null) {
          return MessageCollection.fromJson(data);
        } else {
          throw Exception('Message data is null');
        }
      }).toList();

      //return to yeild
      return messages;
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }
}
