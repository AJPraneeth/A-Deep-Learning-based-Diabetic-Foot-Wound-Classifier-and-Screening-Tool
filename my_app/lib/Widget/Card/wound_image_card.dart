import 'package:flutter/material.dart';
import 'package:my_app/Theme/theme.dart';

class WoundImageCard extends StatefulWidget {
  final String imageUrl;
  final String day;
  const WoundImageCard({
    super.key,
    required this.imageUrl,
    required this.day,
  });

  @override
  State<WoundImageCard> createState() => _WoundImageCardState();
}

class _WoundImageCardState extends State<WoundImageCard> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Image.asset(
          //   "assets/Loging.png",
          //   height: screenHeight * 0.3,
          // ),
          Image.network(
            widget.imageUrl,
            height: screenHeight * 0.3,
          ),
          Container(
              width: double.infinity,
              height: screenHeight * 0.04,
              decoration: BoxDecoration(
                  color: gray1, borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Text(
                " Day ${widget.day}",
                style: cardH3,
              )))
        ],
      ),
    );
  }
}
