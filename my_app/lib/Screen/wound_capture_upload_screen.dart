import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Screen/wound_result_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Card/capture_upload__card.dart';
import 'package:my_app/Widget/bottomNavBar.dart';
import 'package:my_app/Widget/button_primary.dart';

class WoundCaptureUploadScreen extends StatefulWidget {
  final String userId;
  final String userType;
  final UserCollection userData;
  const WoundCaptureUploadScreen(
      {super.key,
      required this.userId,
      required this.userType,
      required this.userData});

  @override
  State<WoundCaptureUploadScreen> createState() =>
      _WoundCaptureUploadScreenState();
}

class _WoundCaptureUploadScreenState extends State<WoundCaptureUploadScreen> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: IconButton(
          onPressed: () {
            Get.to(() => const Dashboard());
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: blackColor,
        ),
        centerTitle: false,
        title: const Text(
          "back",
          style: TextStyle(color: blackColor),
        ),
      ),
      bottomNavigationBar: BottomNavBar(userData: widget.userData),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Wound Screen",
              style: title,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Note:",
              style: tpharagraph7,
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "When you're capturing a new image of the wound, make sure to focus the camera properly on the wound itself. This will ensure that the image turns out clear and in focus. Once you've taken the picture, select it to make sure it's a sharp and clear image of the wound",
                style: tpharagraph7,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CapturUploadCard(
                      icon: Icons.camera_enhance_outlined,
                      onTap: () {
                        pickWoundImageFromCamera();
                      },
                      title: "Camera"),
                  CapturUploadCard(
                      icon: FontAwesomeIcons.images,
                      onTap: () {
                        pickWoundImageFromGallary();
                      },
                      title: "Gallery"),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    selectedImage != null
                        ? Column(
                            children: [
                              Image.file(
                                selectedImage!,
                                height: screenHeight * 0.35,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  clearSelectedImage();
                                },
                                child: Text("Clear Image"),
                              ),
                              ButtonPrimary(
                                  text: 'Check Wound Result',
                                  onTap: () {
                                    Get.to(WoundResultScreen(
                                      woundImage: selectedImage!,
                                      userId: widget.userId,
                                      Usertype: widget.userType,
                                      userData: widget.userData,
                                    ));
                                  }),
                            ],
                          )
                        : Text(
                            "Select the Image",
                            style: tpharagraph2,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> pickWoundImageFromGallary() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(returnImage.path);
    });
  }

  Future<void> pickWoundImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(returnImage.path);
    });
  }

  void clearSelectedImage() {
    setState(() {
      selectedImage = null;
    });
  }
}
