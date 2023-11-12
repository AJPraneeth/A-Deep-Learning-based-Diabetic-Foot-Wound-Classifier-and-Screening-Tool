import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/wound_controller.dart';
import 'package:my_app/Repository/WoundRepository/wound_repository.dart';
import 'package:my_app/Theme/theme.dart';

class WoundCard extends StatefulWidget {
  final String userId;
  final double average;
  const WoundCard({super.key, required this.userId, required this.average});

  @override
  State<WoundCard> createState() => _WoundCardState();
}

class _WoundCardState extends State<WoundCard> {
  double Difference(prvArea, LastArea) {
    return LastArea - prvArea;
  }

  double SeverityPrecentage(diffrence, lastArea) {
    double precentage = (diffrence / lastArea) * 100;
    return precentage;
  }

  final controller = Get.put(WoundController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Card(
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              color: gray1.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FutureBuilder(
                future: controller.woundCardDetails(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<WoundDetailsCard>? woundCarddata = snapshot.data;
                    if (woundCarddata != null) {
                      final classification = woundCarddata.first.woundType;
                      final lastDate = woundCarddata.first.lastDate;
                      final lastWoundArea = woundCarddata.first.lastWoundArea;
                      final roundLastWoundArea =
                          lastWoundArea.toStringAsFixed(2);
                      final prvWoundArea =
                          woundCarddata.first.prevLastWoundArea;

                      final difference =
                          Difference(prvWoundArea, lastWoundArea);

                      if (difference < 0) {
                        final roundDifferenceminus =
                            (difference * (-1)).toStringAsFixed(2);
                        final precentageMinus =
                            (SeverityPrecentage(difference, lastWoundArea) *
                                    (-1))
                                .toStringAsFixed(2);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Wound Type:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      classification.toUpperCase(),
                                      style: tpharagraph7.copyWith(
                                          color: Color(0xFF008000)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Last Date:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      lastDate,
                                      style: tpharagraph7.copyWith(
                                          color: const Color(0xFF008000)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: AutoSizeText(
                                      "Last day Wound Area:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                      maxLines: 1,
                                      minFontSize: 12,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "$roundLastWoundArea cm²",
                                      style: tpharagraph7.copyWith(
                                          color: const Color(0xFF008000)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Average Wound Area:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "${widget.average.toStringAsFixed(2)} cm²",
                                      style: tpharagraph7.copyWith(
                                          color: const Color(0xFF008000)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Difference of Wound:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        "$roundDifferenceminus  cm²",
                                        style: tpharagraph7.copyWith(
                                            color: const Color(0xFF008000)),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Severity Precentage:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        "$precentageMinus %",
                                        style: tpharagraph7.copyWith(
                                            color: const Color(0xFF008000)),
                                      )),
                                  const Icon(
                                    FontAwesomeIcons.arrowDown,
                                    color: Color(0xFF008000),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        final roundDifferenceplus =
                            (difference).toStringAsFixed(2);
                        final precentageplus =
                            (SeverityPrecentage(difference, lastWoundArea))
                                .toStringAsFixed(2);

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Wound Type:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      classification.toUpperCase(),
                                      style: tpharagraph7.copyWith(
                                          color: Color(0xFF008000)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Last Date:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      lastDate,
                                      style: tpharagraph7.copyWith(
                                          color: const Color(0xFF008000)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Last day Wound Area:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "$roundLastWoundArea cm²",
                                      style: tpharagraph7.copyWith(
                                          color: const Color(0xFF008000)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Average Wound Area:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${widget.average.toStringAsFixed(2)} cm²",
                                      style: tpharagraph7.copyWith(
                                          color: const Color(0xFF008000)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Difference of Wound:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "$roundDifferenceplus cm²",
                                      style: tpharagraph7.copyWith(
                                          color: const Color(0xFFFF0000)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Severity Precentage:",
                                      style: tpharagraph7.copyWith(
                                          color: menuBackground),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "$precentageplus %",
                                      style: tpharagraph7.copyWith(
                                          color: const Color(0xFFFF0000)),
                                    ),
                                  ),
                                  const Icon(
                                    FontAwesomeIcons.arrowUp,
                                    color: Color(0xFFFF0000),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return Text("No Wound Data, Please Update");
                    }
                  }
                  return Text("Something Gone Wrong. Try Again");
                }),
          ),
        ),
      ),
    );
  }
}
