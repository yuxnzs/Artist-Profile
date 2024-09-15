import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final double fontSize;

  // Only the homepage title text should be 25px, other headings should be 20px by default
  const HeadingText({super.key, required this.text, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: AppConstants.globalMargin),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
