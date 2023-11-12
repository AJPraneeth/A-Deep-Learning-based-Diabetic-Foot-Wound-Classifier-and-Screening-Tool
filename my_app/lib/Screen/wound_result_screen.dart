import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/Constrain/constrain.dart';
import 'package:my_app/Controller/wound_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/dashboard.dart';

import 'package:my_app/Screen/wound_capture_upload_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Card/dialog_card.dart';
import 'package:my_app/Widget/bottomNavBar.dart';
import 'package:my_app/Widget/button_primary.dart';
import 'package:my_app/Widget/field_widget.dart';
import 'package:http/http.dart' as http;

class WoundResultScreen extends StatefulWidget {
  final File woundImage;
  final String userId;
  final String Usertype;
  final UserCollection userData;
  const WoundResultScreen(
      {super.key,
      required this.woundImage,
      required this.userId,
      required this.Usertype,
      required this.userData});

  @override
  State<WoundResultScreen> createState() => _WoundResultScreenState();
}

class _WoundResultScreenState extends State<WoundResultScreen> {
  // Add a GlobalKey for the RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  // Add a variable to track whether the data is being refreshed
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    File woundImage = widget.woundImage;

    final controller = Get.put(WoundController());

    Future<Map<String, dynamic>?> allModelsApiCall() async {
      try {
        // final resizewoundImage = await resizeImage(woundImage, 256);
        print("attempting to connect to server......");
        var uri = Uri.parse('$httpaddress/model');
        print("connection established.");
        var request = http.MultipartRequest("POST", uri);
        final header = {"Content-type": "multipart/form-data"};

        request.files.add(http.MultipartFile(
            'img', woundImage.readAsBytes().asStream(), woundImage.lengthSync(),
            filename: woundImage.path.split('/').last));
        request.headers.addAll(header);
        final response = await request.send();
        http.Response res = await http.Response.fromStream(response);

        if (res.statusCode == 200) {
          final responseJson = jsonDecode(res.body);
          print(responseJson);
          final woundClassificationResult = responseJson['classification'];
          final woundSegmetationMaskBase64 = responseJson['wound'];
          final woundSegmentationMaskBytes =
              base64Decode(woundSegmetationMaskBase64);
          final stickerSegmetationMaskBase64 = responseJson['sticker'];
          final stickerSegmentationMaskBytes =
              base64Decode(stickerSegmetationMaskBase64);
          final woundArea = responseJson['area'];

          final result = {
            'classification': woundClassificationResult,
            'woundSegmentationMaskBytes': woundSegmentationMaskBytes,
            'stickerSegmentationMaskBytes': stickerSegmentationMaskBytes,
            'woundArea': woundArea
          };

          return result;
        } else {
          print('API error: ${res.body}');
          return null;
        }
      } catch (e) {
        print('Network error: $e');
        return null;
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            color: blackColor,
          ),
          centerTitle: true,
          title: Text(
            "Wound Result",
            style: tpharagraph4.copyWith(color: blackColor),
          ),
        ),
        bottomNavigationBar: BottomNavBar(userData: widget.userData),
        body: RefreshIndicator(
          key: _refreshKey,
          onRefresh: () async {
            // Implement your refresh  again
            setState(() {
              // Set the isRefreshing flag to true
              isRefreshing = true;
            });
            // Simulate a delay for the refresh
            await Future.delayed(const Duration(seconds: 2));

            setState(() {
              // Set the isRefreshing flag to false after refreshing
              isRefreshing = false;
            });
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: Image.file(
                    widget.woundImage,
                    width: double.infinity,
                    height: screenHeight * 0.3,
                  ),
                ),
                FutureBuilder<Map<String, dynamic>?>(
                    future: allModelsApiCall(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print('wound result Error: ${snapshot.error}');
                        return DialogCard(
                          dialogTitle: "Connection",
                          message:
                              "You have some connection Errors . Check Again",
                          onCancelActionName: "Go Back",
                          OnOKActionName: "Dashboard",
                          OnOKAction: () async {
                            Get.to(() => const Dashboard());
                          },
                          OnCancelAction: () {
                            Get.back();
                          },
                          dialogIcon: const Icon(
                            FontAwesomeIcons.plugCircleExclamation,
                            size: 75,
                            color: Colors.redAccent,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final Map<String, dynamic>? data = snapshot.data;

                        if (data != null) {
                          final woundClassificationResult =
                              data['classification'];
                          final woundSegmentationMaskBytes =
                              data['woundSegmentationMaskBytes'];
                          final stickerSegmentationMaskBytes =
                              data['stickerSegmentationMaskBytes'];
                          final woundArea = data['woundArea'];

                          print(woundClassificationResult);
                          print(woundSegmentationMaskBytes);
                          print(stickerSegmentationMaskBytes);

                          if (woundClassificationResult != null &&
                              woundSegmentationMaskBytes != null &&
                              stickerSegmentationMaskBytes != null) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      color: gray1.withOpacity(0.35),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: double.infinity,
                                    height: screenHeight * 0.075,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Diabetic Foot Wound Type: $woundClassificationResult",
                                          style: tpharagraph3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (woundClassificationResult != 'none')
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Segmented Wound Mask",
                                      style: tpharagraph3,
                                    ),
                                  ),
                                if (woundClassificationResult != 'none')
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.memory(
                                      woundSegmentationMaskBytes as Uint8List,
                                      width: screenWidth,
                                      height: screenHeight * 0.2,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Text('Error loading image');
                                      },
                                    ),
                                  ),
                                if (woundClassificationResult != 'none')
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Segmented Sticker Mask",
                                      style: tpharagraph3,
                                    ),
                                  ),
                                if (woundClassificationResult != 'none')
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.memory(
                                      stickerSegmentationMaskBytes as Uint8List,
                                      width: screenWidth,
                                      height: screenHeight * 0.2,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Text('Error loading image');
                                      },
                                    ),
                                  ),
                                if (woundClassificationResult != 'none')
                                  FiledWidget(
                                    title: "Wound Area (cm²)",
                                    fact: woundArea.toString(),
                                  ),
                                //forDoctorButton
                                if (widget.Usertype == 'Doctor' &&
                                    woundClassificationResult != 'none')
                                  ButtonPrimary(
                                      text: "Check Again",
                                      onTap: () {
                                        Get.to(() => WoundCaptureUploadScreen(
                                              userId: widget.userId,
                                              userType: widget.Usertype,
                                              userData: widget.userData,
                                            ));
                                      }),

                                //for Patient button
                                if (widget.Usertype == 'Patient' &&
                                    woundClassificationResult != 'none')
                                  ButtonPrimary(
                                      text: "save",
                                      onTap: () async {
                                        final iscurrentDateAlreadyExist =
                                            await controller
                                                .IscurrentDateAlreadyExist(
                                                    widget.userId);

                                        print(iscurrentDateAlreadyExist);
                                        if (woundArea == 0) {
                                          Get.snackbar("Message",
                                              "You needs to capture the wound with sticker");
                                        } else {
                                          if (iscurrentDateAlreadyExist) {
                                            // Get.snackbar("Message",
                                            //     'You already store wound data today.Do you want store again?',
                                            //     duration:
                                            //         const Duration(seconds: 5));
                                            Get.dialog(AlertDialog(
                                              title: const Text("Message"),
                                              content: const Text(
                                                  "You already store wound data today.Do you want store again?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    // Close the dialog
                                                    Get.back();

                                                    final woundimageurl =
                                                        await controller
                                                            .uploadImage(
                                                                woundImage);
                                                    if (woundimageurl == null) {
                                                      Get.snackbar("Failed",
                                                          'Wound image is not uploaded');
                                                    } else {
                                                      await controller
                                                          .updateWoundDeatils(
                                                              woundClassificationResult,
                                                              woundimageurl,
                                                              woundArea,
                                                              widget.userId);
                                                    }
                                                  },
                                                  child: Text("Ok"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Close the dialog
                                                    Get.back();
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                              ],
                                            ));
                                          } else {
                                            final woundimageurl =
                                                await controller
                                                    .uploadImage(woundImage);
                                            if (woundimageurl == null) {
                                              Get.snackbar("Failed",
                                                  'Wound image is not uploaded');
                                            } else {
                                              //notnulurl
                                              controller.addWoundDeatils(
                                                  woundClassificationResult,
                                                  woundimageurl,
                                                  woundArea,
                                                  widget.userId);
                                            }
                                          }
                                        }
                                      }),
                              ],
                            );
                          }

                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                                child: Text('Something Gone Wrong!,Try Again')),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: DialogCard(
                              dialogTitle: "Connection",
                              message:
                                  "Data is not available , Check again server.",
                              onCancelActionName: "Go Back",
                              OnOKActionName: "Dashboard",
                              OnOKAction: () async {
                                Get.to(() => const Dashboard());
                              },
                              OnCancelAction: () {
                                Get.back();
                              },
                              dialogIcon: const Icon(
                                FontAwesomeIcons.plugCircleExclamation,
                                size: 75,
                                color: Colors.redAccent,
                              ),
                            ),
                          );
                        }
                      } else {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DialogCard(
                              dialogTitle: "Connection",
                              message: "Data is Null , Check again server.",
                              onCancelActionName: "Go Back",
                              OnOKActionName: "Dashboard",
                              OnOKAction: () async {
                                Get.to(() => const Dashboard());
                              },
                              OnCancelAction: () {
                                Get.back();
                              },
                              dialogIcon: const Icon(
                                FontAwesomeIcons.plugCircleExclamation,
                                size: 75,
                                color: Colors.redAccent,
                              ),
                            )

                            // Text('data is null,Try again'),
                            );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
