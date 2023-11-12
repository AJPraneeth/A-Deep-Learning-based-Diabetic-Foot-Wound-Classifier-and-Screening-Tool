import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/DatabaseCollection/wound_collection.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WoundRepository extends GetxController {
  static WoundRepository get instance => Get.find();
  final db = FirebaseFirestore.instance;

  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref('files').child(fileName);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {
            print("Upload is completed"),
            Get.snackbar("Success", 'Wound image uploaded')
          });
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> addWoundDetails(
      woundClassification, woundImageurl, woundArea, userId) async {
    try {
      final wound = WoundCollection(
          woundClassification: woundClassification,
          woundArea: woundArea,
          woundImageUrl: woundImageurl,
          timestamp: DateTime.now());
      await db
          .collection("Users")
          .doc(userId)
          .collection("Wound")
          .add(wound.toJson());
      Get.snackbar("Successfull", "Your Wound Detials stored");
    } catch (e) {
      print('Error adding document $e');
      Get.snackbar("Error", "Somthing Gone Wrong , ");
    }
  }

  Future<bool> isCurrentDateAlreadyExist(userId) async {
    try {
      final currentDate = DateTime.now();
      final querySnapshot =
          await db.collection("Users").doc(userId).collection("Wound").get();
      final documents = querySnapshot.docs;
      if (documents.isEmpty) {
        return false; // No data available.
      }

      for (var document in documents) {
        final timestamp = (document.data())['timestamp'] as Timestamp;
        final woundDate = timestamp.toDate();

        if (woundDate.day == currentDate.day &&
            woundDate.month == currentDate.month &&
            woundDate.year == currentDate.year) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error adding document $e');
      Get.snackbar("Error", "Somthing Gone Wrong ");
      return false;
    }
  }

  Future<void> updateWoundDetails(
      userid, woundCallsification, woundArea, woundImageurl) async {
    try {
      final currentDate = DateTime.now();
      final querySnapshot =
          await db.collection("Users").doc(userid).collection("Wound").get();
      final documents = querySnapshot.docs;
      for (var document in documents) {
        final timestamp = (document.data())['timestamp'] as Timestamp;
        final woundDate = timestamp.toDate();

        if (woundDate.day == currentDate.day &&
            woundDate.month == currentDate.month &&
            woundDate.year == currentDate.year) {
          // Update the existing record
          await db
              .collection("Users")
              .doc(userid)
              .collection("Wound")
              .doc(document.id)
              .update({
            'wound_classification': woundCallsification,
            'wound_area': woundArea,
            'wound_imageurl': woundImageurl,
            'timestamp': DateTime.now(),
          });
          Get.snackbar("Successful", "Your Wound Details updated");
          return;
        }
      }
    } catch (e) {
      print('Error adding document $e');
      Get.snackbar("Error", "Somthing Gone Wrong  ");
      return;
    }
  }

  Future<List<WoundChartData>> getWoundChartData(userId) async {
    try {
      final querySnapshot =
          await db.collection("Users").doc(userId).collection("Wound").get();
      final documents = querySnapshot.docs;

      if (documents.isEmpty) {
        return []; // No data available.
      }
      print(documents.length);
      // Sort documents by timestamp in ascending order.
      documents.sort((a, b) {
        final timestampA = (a.data())['timestamp'] as Timestamp;

        final timestampB = (b.data())['timestamp'] as Timestamp;
        return timestampA.compareTo(timestampB);
      });

      final firstTimestamp = (documents.first.data())['timestamp'] as Timestamp;
      final List<WoundChartData> chartData = [];

      for (var i = 0; i < documents.length; i++) {
        final timestamp = (documents[i].data())['timestamp'] as Timestamp;
        final woundArea = (documents[i].data())['wound_area'] as double;

        final difference =
            timestamp.toDate().difference(firstTimestamp.toDate());
        final day = difference.inDays + 1;

        chartData.add(WoundChartData(day: day, woundArea: woundArea));
      }

      return chartData;
    } catch (e) {
      print('Error fetching wound data: $e');
      return []; // Handle the error as needed.
    }
  }

  Future<List<WoundDetailsCard>> getWoundCardDetails(userId) async {
    try {
      final querySnapshot =
          await db.collection("Users").doc(userId).collection("Wound").get();
      final documents = querySnapshot.docs;

      if (documents.isEmpty) {
        return []; // No data available.
      }

      // Sort documents by timestamp in descending order to get the latest entry first.
      documents.sort((a, b) {
        final timestampA = (a.data())['timestamp'] as Timestamp;
        final timestampB = (b.data())['timestamp'] as Timestamp;
        return timestampB.compareTo(timestampA);
      });

      final List<WoundDetailsCard> cardDetails = [];

      // Get the details of the latest entry.
      final latestEntry = documents.first;
      final latestTimestamp = (latestEntry.data())['timestamp'];
      // Get the formatted date of the latest entry.
      final lastWoundDate = latestTimestamp.toDate();
      final lastWoundArea = (latestEntry.data())['wound_area'] as double;
      final woundClassification =
          (latestEntry.data())['wound_classification'] as String;

      // Find the previous day's entry.
      final chartData = await getWoundChartData(userId);
      if (chartData.isNotEmpty) {
        chartData.removeLast();
      }
      double prevLastWoundArea =
          chartData.isNotEmpty ? chartData.last.woundArea : 0.0;

      cardDetails.add(WoundDetailsCard(
        woundType: woundClassification,
        lastDate: DateFormat('yMd').format(lastWoundDate),
        lastWoundArea: lastWoundArea,
        prevLastWoundArea: prevLastWoundArea,
      ));

      return cardDetails;
    } catch (e) {
      print('Error fetching wound card details: $e');
      return []; // Handle the error as needed.
    }
  }

  Future<List<woundImage>> getWoundImage(userId) async {
    try {
      final querySnapshot =
          await db.collection("Users").doc(userId).collection("Wound").get();
      final documents = querySnapshot.docs;

      if (documents.isEmpty) {
        return []; // No data available.
      }
      print(documents.length);
      // Sort documents by timestamp in ascending order.
      documents.sort((a, b) {
        final timestampA = (a.data())['timestamp'] as Timestamp;

        final timestampB = (b.data())['timestamp'] as Timestamp;
        return timestampA.compareTo(timestampB);
      });

      final firstTimestamp = (documents.first.data())['timestamp'] as Timestamp;
      final List<woundImage> image = [];

      for (var i = 0; i < documents.length; i++) {
        final timestamp = (documents[i].data())['timestamp'] as Timestamp;
        final woundUrl = (documents[i].data())['wound_imageurl'] as String;

        final difference =
            timestamp.toDate().difference(firstTimestamp.toDate());
        final day = difference.inDays + 1;

        image.add(woundImage(woundUrl: woundUrl, woundDay: day));
      }

      return image;
    } catch (e) {
      print('Error fetching wound data: $e');
      return []; // Handle the error as needed.
    }
  }
}

class WoundChartData {
  final int day;
  final double woundArea;

  WoundChartData({required this.day, required this.woundArea});
}

class WoundDetailsCard {
  final String woundType;
  final String lastDate;
  final double lastWoundArea;
  final double prevLastWoundArea;

  WoundDetailsCard(
      {required this.woundType,
      required this.lastDate,
      required this.lastWoundArea,
      required this.prevLastWoundArea});
}

class woundImage {
  final String woundUrl;
  final int woundDay;

  woundImage({required this.woundUrl, required this.woundDay});
}
