import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Theme/theme.dart';

class DashboradCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;

  const DashboradCard(
      {super.key,
      required this.onTap,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: screenHeight * 0.2,
        width: screenWidth * 0.3,
        child: Card(
          elevation: 8,
          color: bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  title,
                  style: tpharagraph3.copyWith(fontSize: 18),
                  minFontSize: 12,
                  maxLines: 3,
                ),
              ),
              Icon(
                icon,
                size: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
