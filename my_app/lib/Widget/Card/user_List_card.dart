import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/admin_user_profile_screen.dart';
import 'package:my_app/Theme/theme.dart';

class UserListCard extends StatelessWidget {
  final String userName;

  final UserCollection user;
  const UserListCard({super.key, required this.userName, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Add elevation to give it a shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        // Adjust the radius as needed
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            userName,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            user.email,
            style: TextStyle(fontSize: 15),
          ),
          leading: CircleAvatar(
            backgroundColor: blackColor.withOpacity(0.6),
            foregroundColor: white,
            child: user.userType == "Doctor"
                ? const Icon(FontAwesomeIcons.userDoctor)
                : const Icon(FontAwesomeIcons.user),
          ),
          trailing: Text(user.status.toString()),
          tileColor: Colors.black12,
          onTap: () {
            Get.to(() => AdminUserProfileScreen(
                  user: user,
                ));
          },
        ),
      ),
    );
  }
}
