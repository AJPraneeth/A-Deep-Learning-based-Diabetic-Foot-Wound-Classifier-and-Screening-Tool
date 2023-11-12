import 'package:flutter/material.dart';

import 'package:my_app/Theme/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FiledWidget extends StatelessWidget {
  final String? title;
  final String? fact;
  const FiledWidget({super.key, this.fact, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 2,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title:",
                style: tpharagraph5,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                color: lightBlue,
                child: AutoSizeText(
                  fact ?? '',
                  style: tpharagraph3,
                  maxLines: 10, // Set the maximum number of lines
                  minFontSize: 12.0, // Minimum font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
