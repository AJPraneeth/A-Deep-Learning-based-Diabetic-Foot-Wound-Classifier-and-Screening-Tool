import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/manage_user_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/manage_user_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/button_primary.dart';
import 'package:my_app/Widget/field_widget.dart';

class AdminUserProfileScreen extends StatelessWidget {
  final UserCollection user;
  const AdminUserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final manageUserController = Get.put(ManageUserController());
    final String userName = "${user.firstName} ${user.lastName}";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
            onPressed: () {
              Get.to(() => const ManageUserScreen());
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            color: blackColor,
          ),
          centerTitle: true,
          title: Text(
            "User Profile",
            style: tpharagraph4.copyWith(color: blackColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              user.userType == "Doctor"
                                  ? CircleAvatar(
                                      backgroundColor:
                                          blackColor.withOpacity(0.7),
                                      foregroundColor: white,
                                      radius: 50,
                                      child: const Icon(
                                        FontAwesomeIcons.userDoctor,
                                        size: 50,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor:
                                          blackColor.withOpacity(0.7),
                                      foregroundColor: white,
                                      radius: 50,
                                      child: const Icon(
                                        FontAwesomeIcons.user,
                                        size: 50,
                                      ),
                                    )
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FiledWidget(
                              title: "Full Name",
                              fact: userName,
                            ),
                            FiledWidget(
                              title: "Email",
                              fact: user.email,
                            ),
                            FiledWidget(
                              title: "Mobile",
                              fact: user.mobileNo,
                            ),
                            FiledWidget(
                              title: "Date Of Birth",
                              fact: user.dOB,
                            ),
                            FiledWidget(
                              title: "Gender",
                              fact: user.gender,
                            ),
                            FiledWidget(
                              title: "Address",
                              fact: user.address,
                            ),
                          ],
                        ),
                        ButtonPrimary(
                            text: user.status == "Active"
                                ? "Deactivation"
                                : "Activation",
                            onTap: () {
                              if (user.status == "Active") {
                                manageUserController.deactiveUser(
                                    user.email, userName);
                              } else {
                                manageUserController.activeUser(
                                    user.email, userName);
                              }
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
