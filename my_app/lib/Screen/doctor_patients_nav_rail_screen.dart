import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/doctor_patient_controller.dart';
import 'package:my_app/Controller/wound_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Repository/DoctorPatientRepository/doctor_patient_repository.dart';
import 'package:my_app/Repository/WoundRepository/wound_repository.dart';
import 'package:my_app/Screen/chats_screen.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Card/dialog_card.dart';
import 'package:my_app/Widget/Card/wound_card.dart';
import 'package:my_app/Widget/Card/wound_image_card.dart';
import 'package:my_app/Widget/bottomNavBar.dart';
import 'package:my_app/Widget/chart/lineChart.dart';
import 'package:my_app/Widget/field_widget.dart';

class DoctorPatientNavRailScreen extends StatefulWidget {
  final PatientDetails patient;
  final UserCollection userData;
  const DoctorPatientNavRailScreen({
    required this.patient,
    required this.userData,
  });

  @override
  State<DoctorPatientNavRailScreen> createState() =>
      _DoctorPatientNavRailScreenState();
}

class _DoctorPatientNavRailScreenState
    extends State<DoctorPatientNavRailScreen> {
  final controller = Get.put(DoctorPatientController());
  final woundController = Get.put(WoundController());
  int _selectedIndex = 0;
  bool _isExpanded = false;
  Widget _buildNavigationRail() {
    return NavigationRail(
      elevation: 8,
      backgroundColor: Colors.white70,
      extended: _isExpanded,
      labelType: NavigationRailLabelType.none,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(FontAwesomeIcons.user),
          selectedIcon: Icon(FontAwesomeIcons.user),
          label: Text('Profile'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.analytics),
          selectedIcon: Icon(Icons.analytics),
          label: Text('Analyze'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.image_aspect_ratio_outlined),
          selectedIcon: Icon(Icons.image_aspect_ratio_outlined),
          label: Text('Wound'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final patientName =
        "${widget.patient.firstName.capitalizeFirst} ${widget.patient.lastName.capitalizeFirst}";
    double screenHeight = MediaQuery.of(context).size.height;
    patientProfile() {
      return Expanded(
        child: SingleChildScrollView(
          child: FutureBuilder<UserCollection>(
            future: controller.patientProfile(widget.patient.email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return DialogCard(
                  dialogTitle: "Connection",
                  message: "You have some connection Errors . Check Again",
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
                final patient = snapshot.data;

                if (patient != null) {
                  return Column(
                    children: [
                      FiledWidget(
                        title: "Name",
                        fact: patientName,
                      ),
                      FiledWidget(
                        title: "Date Of Birth",
                        fact: patient.dOB,
                      ),
                      FiledWidget(
                        title: "Gender",
                        fact: patient.gender,
                      ),
                      FiledWidget(
                        title: "Mobile",
                        fact: patient.mobileNo,
                      ),
                      FiledWidget(
                        title: "Email",
                        fact: patient.email,
                      ),
                      FiledWidget(
                        title: "Address",
                        fact: patient.address,
                      ),
                      FiledWidget(
                        title: "Current Medication",
                        fact: patient.currentMedication,
                      ),
                    ],
                  );
                } else {
                  return const Text("Patient doesn't have any details");
                }
              }
              return Text("Something Gone Wrong");
            },
          ),
        ),
      );
    }

    analyzePatient() {
      double minX(List<WoundChartData> chartData) {
        double minDay = double.infinity;
        for (var data in chartData) {
          if (data.day < minDay) {
            minDay = data.day.toDouble();
          }
        }
        if (minDay == double.infinity) {
          return 0.0;
        }
        return minDay;
      }

      double maxX(List<WoundChartData> chartData) {
        double maxDay = double.negativeInfinity;
        for (var data in chartData) {
          if (data.day > maxDay) {
            maxDay = data.day.toDouble();
          }
        }
        if (maxDay == double.negativeInfinity) {
          return 0.0;
        }
        return maxDay;
      }

      double minWoundArea(List<WoundChartData> chartData) {
        double minArea = double.infinity;
        for (var data in chartData) {
          if (data.woundArea < minArea) {
            minArea = data.woundArea;
          }
        }
        if (minArea == double.infinity) {
          return 0.0;
        }
        return minArea;
      }

      double maxWoundArea(List<WoundChartData> chartData) {
        double maxArea = double.negativeInfinity;
        for (var data in chartData) {
          if (data.woundArea > maxArea) {
            maxArea = data.woundArea;
          }
        }
        if (maxArea == double.negativeInfinity) {
          return 0.0;
        }
        return maxArea;
      }

      double woundAreaSportsAverage(List<WoundChartData> chartData) {
        // Collect wound areas for each day

        List<double> wound = [];
        double sumWound = 0;
        // Collect wound areas for each day
        for (var data in chartData) {
          wound.add(data.woundArea);
        }
        for (var i = 0; i < wound.length; i++) {
          sumWound = sumWound + wound[i];
        }
        var avg = sumWound / wound.length;

        return avg;
      }

      return FutureBuilder(
        future: woundController.woundChartList(widget.patient.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(' Error: ${snapshot.error}');
            return DialogCard(
              dialogTitle: "Connection",
              message: "You have some connection Errors . Check Again",
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
            List<WoundChartData>? chartData = snapshot.data ?? [];
            print("${chartData?.length} lengh chart data");

            if (chartData.isEmpty == false) {
              if (chartData.length != 1) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //line chart

                    Container(
                      color: menuBackground,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Wound Area",
                                  style: title.copyWith(
                                      color: white.withOpacity(0.7)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "cm²",
                                    style: tpharagraph.copyWith(
                                        color: white.withOpacity(0.7)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LineChartWidget(
                              chartData: chartData,
                              maxx: maxX(chartData),
                              minx: minX(chartData),
                              maxy: maxWoundArea(chartData),
                              miny: minWoundArea(chartData),
                              avg: woundAreaSportsAverage(chartData)),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Wound Details",
                        style: cardH1.copyWith(
                            color: menuBackground, fontSize: 25),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                            child: WoundCard(
                          userId: widget.patient.id,
                          average: woundAreaSportsAverage(chartData),
                        )),
                      ),
                    )
                  ],
                );
              } else {
                print(
                    "This Patient has already saved his Wound Data , But Not enough for the Analyzing,At least 2 days wound details need For Analyzing ");
                return DialogCard(
                  dialogTitle: "Info",
                  message:
                      "This Patient has already saved his Wound Data , But Not enough for the Analyzing,At least 2 days wound details need For Analyzing",
                  onCancelActionName: "Go Back",
                  OnOKActionName: "Chats",
                  OnOKAction: () async {
                    Get.to(() => ChatsScreen(userdata: widget.userData));
                  },
                  OnCancelAction: () {
                    Get.back();
                  },
                  dialogIcon: const Icon(
                    FontAwesomeIcons.circleInfo,
                    size: 75,
                    color: Colors.blueAccent,
                  ),
                );
              }
            } else {
              print("This patient Dont have any details about  Wound");
              return DialogCard(
                dialogTitle: "Info",
                message: "This patient Dont have any details about  Wound",
                onCancelActionName: "Go Back",
                OnOKActionName: "Chats",
                OnOKAction: () async {
                  Get.to(() => ChatsScreen(userdata: widget.userData));
                },
                OnCancelAction: () {
                  Get.back();
                },
                dialogIcon: const Icon(
                  FontAwesomeIcons.circleInfo,
                  size: 75,
                  color: Colors.blueAccent,
                ),
              );
            }
          }

          return DialogCard(
            dialogTitle: "Error",
            message: "Something Gone wrong, Try Again",
            onCancelActionName: "Go Back",
            OnOKActionName: "DashBoard",
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
        },
      );
    }

    woundImageWidget() {
      return Expanded(
        child: SingleChildScrollView(
          child: FutureBuilder<List<woundImage>>(
            future: controller.getwoundImage(widget.patient.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print("Error:${snapshot.error}");
                return DialogCard(
                  dialogTitle: "Connection",
                  message: "You have some connection Errors . Check Again",
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
                final List<woundImage>? images = snapshot.data;

                if (images != null) {
                  return Expanded(
                    child: Column(
                      children: images.map((image) {
                        // Replace 'day' and 'imageUrl' with actual values from 'image'
                        return WoundImageCard(
                          day: image.woundDay.toString(),
                          imageUrl: image.woundUrl,
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return DialogCard(
                    dialogTitle: "Info",
                    message: "Patient Dont have any details about Your Wound",
                    onCancelActionName: "Go Back",
                    OnOKActionName: "Chats",
                    OnOKAction: () async {
                      Get.to(() => ChatsScreen(userdata: widget.userData));
                    },
                    OnCancelAction: () {
                      Get.back();
                    },
                    dialogIcon: const Icon(
                      FontAwesomeIcons.circleInfo,
                      size: 75,
                      color: Colors.blueAccent,
                    ),
                  );
                }
              }
              return DialogCard(
                dialogTitle: "Error",
                message: "Something Gone wrong, Try Again",
                onCancelActionName: "Go Back",
                OnOKActionName: "DashBoard",
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
            },
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            color: blackColor,
          ),
          centerTitle: true,
          title: Text(
            patientName,
            style: tpharagraph4.copyWith(color: blackColor),
          ),
        ),
        bottomNavigationBar: BottomNavBar(userData: widget.userData),
        body: Row(
          children: [
            _buildNavigationRail(),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  patientProfile(),
                  analyzePatient(),
                  woundImageWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
