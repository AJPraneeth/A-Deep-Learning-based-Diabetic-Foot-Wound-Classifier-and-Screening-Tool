import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Repository/Authentication_Repostoty/authentication_repository.dart';
import 'package:my_app/Screen/add_doctor_screen.dart';
import 'package:my_app/Screen/change_password.dart';
import 'package:my_app/Screen/doctor_profile_screen.dart';
import 'package:my_app/Screen/profile_screen.dart';
import 'package:my_app/Screen/send_email_screen.dart';
import 'package:my_app/Theme/theme.dart';

class NavDrawer extends StatefulWidget {
  final String userType;
  final bool hasDoctor;
  final String userEmail;
  final UserCollection userdata;
  const NavDrawer(
      {super.key,
      required this.userType,
      required this.hasDoctor,
      required this.userEmail,
      required this.userdata});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    print('hasdoctor');
    print(widget.userdata.hasDoctor);
    print('usertype');
    print(widget.userType);
    print('useremail');
    print(widget.userEmail);
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          child: Text(
            "Dashborad",
            style: tpharagraph4,
          ),
        ),
        if (widget.userType != "Admin")
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text(
              "Profile",
              style: tpharagraph3,
            ),
            onTap: () {
              Get.to(() => ProfileScreen(
                    userdata: widget.userdata,
                    bottomNegigatorIndex: 1,
                  ));
            },
          ),
        if (widget.userType == "Patient" && widget.hasDoctor == false)
          ListTile(
            leading: const Icon(Icons.medication_outlined),
            title: Text(
              "Add Doctor",
              style: tpharagraph3,
            ),
            onTap: () {
              Get.to(() => AddDoctorScreen(patientEmail: widget.userEmail));
            },
          ),
        if (widget.userType == "Patient" && widget.hasDoctor == true)
          ListTile(
            leading: const Icon(FontAwesomeIcons.userDoctor),
            title: Text(
              "Doctor Profile",
              style: tpharagraph3,
            ),
            onTap: () {
              Get.to(() => DoctorProfileScreen(
                    patientEmail: widget.userdata.email,
                    userData: widget.userdata,
                  ));
            },
          ),
        if (widget.userType != "Patient")
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(
              "Send Email",
              style: tpharagraph3,
            ),
            onTap: () {
              Get.to(() => const SendEmailScreen());
            },
          ),
        ListTile(
          leading: const Icon(Icons.change_circle),
          title: Text(
            "Change Password",
            style: tpharagraph3,
          ),
          onTap: () {
            Get.to(() => ChangePassword(
                  userEmail: widget.userEmail,
                ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout_outlined),
          title: Text(
            "logout",
            style: tpharagraph3,
          ),
          onTap: () {
            Get.dialog(AlertDialog(
              title: const Text("Message"),
              content: const Text("Do You Want to log out from this account?"),
              actions: [
                TextButton(
                    onPressed: () {
                      AuthenticationRepository.instance.logout();
                    },
                    child: const Text("OK")),
                TextButton(
                    onPressed: (() {
                      Get.back();
                    }),
                    child: const Text("Cancel"))
              ],
            ));
          },
        ),
      ],
    ));
  }
}
