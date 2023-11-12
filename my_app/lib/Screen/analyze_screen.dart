import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/wound_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Repository/WoundRepository/wound_repository.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Screen/wound_capture_upload_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Card/dialog_card.dart';
import 'package:my_app/Widget/Card/wound_card.dart';
import 'package:my_app/Widget/bottomNavBar.dart';
import 'package:my_app/Widget/chart/lineChart.dart';

class AnalyzeScreen extends StatefulWidget {
  final UserCollection userData;
  const AnalyzeScreen({super.key, required this.userData});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final controller = Get.put(WoundController());
  // Add a GlobalKey for the RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  // Add a variable to track whether the data is being refreshed
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
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
          centerTitle: true,
          title: Text(
            "Analyze",
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
          child: FutureBuilder(
            future: controller.woundChartList(widget.userData.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<WoundChartData> chartData = snapshot.data ?? [];
                //print("${chartData?.length} lengh chart data");

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
                              userId: widget.userData.id!,
                              average: woundAreaSportsAverage(chartData),
                            )),
                          ),
                        )
                      ],
                    );
                  } else {
                    return DialogCard(
                      dialogTitle: "Info",
                      message:
                          "You have already saved your Wound Data , But Not enough for the Analyzing.At least 2 days wound details need For Analyzing ",
                      onCancelActionName: "Go Back",
                      OnOKActionName: "Wound Screen",
                      OnOKAction: () async {
                        Get.to(() => WoundCaptureUploadScreen(
                            userId: widget.userData.id ?? '',
                            userType: widget.userData.userType ?? '',
                            userData: widget.userData));
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
                  return DialogCard(
                    dialogTitle: "Info",
                    message: "You Dont have any details about Your Wound",
                    onCancelActionName: "Go Back",
                    OnOKActionName: "Wound Screen",
                    OnOKAction: () async {
                      Get.to(() => WoundCaptureUploadScreen(
                          userId: widget.userData.id ?? '',
                          userType: widget.userData.userType ?? '',
                          userData: widget.userData));
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
      ),
    );
  }
}
