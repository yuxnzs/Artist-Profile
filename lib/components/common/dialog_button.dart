import 'package:flutter/material.dart';

class DialogButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color longPressColor;
  final Color textColor;
  final double width;
  final double height;

  const DialogButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.backgroundColor,
    required this.longPressColor,
    required this.textColor,
    required this.width,
    required this.height,
  });

  @override
  State<DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<DialogButton> {
  bool isLongPress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onPanDown: (_) {
        setState(() {
          isLongPress = true;
        });
      },
      onPanCancel: () {
        setState(() {
          isLongPress = false;
        });
      },
      onPanEnd: (_) {
        setState(() {
          isLongPress = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: isLongPress ? widget.longPressColor : widget.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 15,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
