import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 45,
      left: 5,
      child: BackButton(color: Colors.grey[600]),
    );
  }
}
