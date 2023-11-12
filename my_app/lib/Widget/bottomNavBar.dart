import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:get/get.dart";
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/chats_screen.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Screen/patient_chat_screen.dart';
import 'package:my_app/Screen/profile_screen.dart';
import 'package:my_app/Theme/theme.dart';

class BottomNavBar extends StatefulWidget {
  final UserCollection userData;
  const BottomNavBar({super.key, required this.userData});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      backgroundColor: gray1,
      selectedItemColor: blackColor,
      unselectedItemColor: blackColor,
      selectedLabelStyle: tpharagraph7,
      unselectedLabelStyle: tpharagraph7,
      onTap: (value) {
        // Respond to item press.
        setState(() {
          _currentIndex = value;
          if (_currentIndex == 1) {
            Get.to(() => ProfileScreen(
                  userdata: widget.userData,
                  bottomNegigatorIndex: _currentIndex,
                ));
          } else if (_currentIndex == 2) {
            if (widget.userData.userType == "Doctor") {
              Get.to(() => ChatsScreen(
                    userdata: widget.userData,
                  ));
            } else {
              Get.to(() => PatientChatScreen(userdata: widget.userData));
            }
          } else {
            Get.to(() => const Dashboard());
          }
        });
      },
      items: [
        const BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        const BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(FontAwesomeIcons.user),
        ),
        if (widget.userData.userType != "Admin")
          const BottomNavigationBarItem(
            label: "Message",
            icon: Icon(Icons.chat_bubble_outline),
          ),
      ],
    );
  }
}
