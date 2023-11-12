import 'package:flutter/material.dart';
import 'package:my_app/Theme/theme.dart';

class UserType extends StatelessWidget {
  const UserType({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      color: bgColor,
      child: Column(
        children: [
          Image.asset(
            "assets/doctor.png",
            height: screenHeight * 0.2,
            width: screenWidth * 0.4,
          ),
          Text(
            "Doctor",
            style: cardtext,
          ),
        ],
      ),
    );
  }
}
