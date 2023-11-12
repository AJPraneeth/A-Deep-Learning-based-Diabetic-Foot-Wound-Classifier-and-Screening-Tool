import 'dart:io';

import 'package:get/get.dart';
import 'package:my_app/Repository/WoundRepository/wound_repository.dart';

class WoundController extends GetxController {
  static WoundController get instance => Get.find();

  Future<String?> uploadImage(File imageFile) async {
    return await WoundRepository().uploadImage(imageFile);
  }

  Future<bool> IscurrentDateAlreadyExist(userId) async {
    return await WoundRepository().isCurrentDateAlreadyExist(userId);
  }

  Future<void> addWoundDeatils(
      woundClassification, woundImageurl, woundArea, userId) async {
    return await WoundRepository()
        .addWoundDetails(woundClassification, woundImageurl, woundArea, userId);
  }

  Future<void> updateWoundDeatils(
      woundClassification, woundImageurl, woundArea, userId) async {
    return await WoundRepository().updateWoundDetails(
        userId, woundClassification, woundArea, woundImageurl);
  }

  Future<List<WoundChartData>> woundChartList(userID) {
    return WoundRepository().getWoundChartData(userID);
  }

  Future<List<WoundDetailsCard>> woundCardDetails(userID) {
    return WoundRepository().getWoundCardDetails(userID);
  }
}
