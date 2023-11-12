import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/doctor_collection.dart';
import 'package:my_app/DatabaseCollection/patient_collection.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/manage_user_screen.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;

  createPatient(PatientCollection user) async {
    await db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar(
            "Success", "Your Account has been created",
            // snackPosition: SnackPosition.BOTTOM,
            // backgroundColor: Colors.green.withOpacity(0.1),
            // colorText: Colors.green
          ),
        )
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error", "Somthing went Wrong",
        // snackPosition: SnackPosition.BOTTOM,
        // backgroundColor: Colors.redAccent.withOpacity(0.1),
        // colorText: Colors.red
      );
    });
  }

  createDoctor(DoctorCollection user) async {
    await db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar(
            "Success", "Your Account has been created",
            // snackPosition: SnackPosition.BOTTOM,
            // backgroundColor: Colors.green.withOpacity(0.1),
            // colorText: Colors.green
          ),
        )
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error", "Somthing went Wrong",
        // snackPosition: SnackPosition.BOTTOM,
        // backgroundColor: Colors.redAccent.withOpacity(0.1),
        // colorText: Colors.red
      );
    });
  }

  Future<PatientCollection> getPatientDetatils(String email) async {
    final snapshot =
        await db.collection("Users").where("Email", isEqualTo: email).get();
    final userData =
        snapshot.docs.map((e) => PatientCollection.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<PatientCollection>> allPatient(String email) async {
    final snapshot = await db.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => PatientCollection.fromSnapshot(e)).toList();
    return userData;
  }

  Future<UserCollection> getUserDetails(String email) async {
    final snapshot =
        await db.collection("Users").where("Email", isEqualTo: email).get();
    final userData =
        snapshot.docs.map((e) => UserCollection.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserCollection>> allUser() async {
    final snapshot = await db.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => UserCollection.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> accountDeactive(String email, String userName) async {
    final userSnapshot =
        await db.collection("Users").where("Email", isEqualTo: email).get();

    final userDoc = userSnapshot.docs;
    if (userDoc.isNotEmpty) {
      final userRef = userDoc.first.reference;

      await userRef.update({"status": "Deactive"});

      Get.snackbar("Done", "You Deactivated $userName");
      Future.microtask(() {
        Get.to(const ManageUserScreen());
      });
    } else {
      Get.snackbar("Error", "Something Gone wrong");
    }
  }

  Future<void> accountActive(String email, String userName) async {
    final userSnapshot =
        await db.collection("Users").where("Email", isEqualTo: email).get();

    final userDoc = userSnapshot.docs;
    if (userDoc.isNotEmpty) {
      final userRef = userDoc.first.reference;
      await userRef.update({"status": "Active"});
      Get.snackbar("Done", "You Activated $userName");
      Future.microtask(() {
        Get.to(const ManageUserScreen());
      });
    } else {
      Get.snackbar("Error", "Something Gone wrong");
    }
  }

  Future<bool> doesAccountExist(String email) async {
    final snapshot =
        await db.collection("Users").where("Email", isEqualTo: email).get();
    print(snapshot.docs.isNotEmpty);
    return snapshot.docs.isNotEmpty;
  }
}
