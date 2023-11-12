import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/message_collection.dart';
import 'package:my_app/Repository/MessageRepository/message_repository.dart';

class MessageController extends GetxController {
  static MessageController get instance => Get.find();

  final msgRepo = Get.put(MessageRepository());

  Future<void> sendTextMessage(senderId, receiverEmail, content) async {
    return await msgRepo.addTextMessage(
        content: content, receiverEmail: receiverEmail, senderId: senderId);
  }

  Future<List<MessageCollection>> getMessage(
      currentUserId, receiverEmail) async {
    print("ReceiEmail in getMessage con :$receiverEmail");
    return await msgRepo.getChatMessages(currentUserId, receiverEmail);
  }

  Future<String?> getReceiverId(receiverEmail) async {
    return await msgRepo.getReciverDocID(receiverEmail);
  }
}
