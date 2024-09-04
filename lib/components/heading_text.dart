import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final double fontSize;

  // Only the homepage title text should be 25px, other headings should be 22px by default
  const HeadingText({super.key, required this.text, this.fontSize = 22});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
