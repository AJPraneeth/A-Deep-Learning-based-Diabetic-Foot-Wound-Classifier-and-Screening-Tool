import 'package:flutter/material.dart';
import 'package:my_app/Theme/theme.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ButtonPrimary({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor: gray1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              )),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
