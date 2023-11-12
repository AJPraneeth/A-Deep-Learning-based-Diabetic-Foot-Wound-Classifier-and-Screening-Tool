import 'package:cloud_firestore/cloud_firestore.dart';

class WoundCollection {
  final String? id;
  final String woundClassification;
  final String woundImageUrl;
  final double woundArea;
  final DateTime timestamp;
  const WoundCollection(
      {required this.woundClassification,
      required this.woundArea,
      required this.woundImageUrl,
      required this.timestamp,
      this.id});

  toJson() {
    return {
      "wound_classification": woundClassification,
      "wound_area": woundArea,
      "wound_imageurl": woundImageUrl,
      "timestamp": timestamp
    };
  }

  factory WoundCollection.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    return WoundCollection(
        id: document.id,
        woundClassification: data?['wound_classification'],
        woundImageUrl: data?["wound_imagefile"],
        woundArea: data?['wound_area'],
        timestamp: data?['timestamp']);
  }
}
