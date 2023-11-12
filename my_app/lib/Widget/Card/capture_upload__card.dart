import 'package:flutter/material.dart';
import 'package:my_app/Theme/theme.dart';

class CapturUploadCard extends StatelessWidget {
  const CapturUploadCard(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.title});
  final String title;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        color: Colors.grey.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 50,
              ),
              Text(
                title,
                style: tpharagraph3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
