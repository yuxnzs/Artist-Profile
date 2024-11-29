import 'package:flutter/material.dart';

class KeyboardDismissibleScrollView extends StatelessWidget {
  final Widget child;

  const KeyboardDismissibleScrollView({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // When the user's finger touches the screen, dismiss the keyboard
      onPanDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          // Enable bouncing effect
          parent: BouncingScrollPhysics(),
        ),
        child: child,
      ),
    );
  }
}
