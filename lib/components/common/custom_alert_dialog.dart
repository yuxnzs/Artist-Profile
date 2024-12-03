import 'package:flutter/material.dart';
import 'package:artist_profile/components/common/dialog_button.dart';
import 'package:artist_profile/utility/custom_colors.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final double width;
  final String? actionText;
  final Function()? onActionTap;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.width,
    this.actionText,
    this.onActionTap,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  bool isLongPress = false;
  late bool isActionNotNull;

  @override
  void initState() {
    super.initState();
    // Check if actionText and onActionTap are not null
    isActionNotNull = widget.actionText != null && widget.onActionTap != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: widget.width,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text
              Column(
                children: [
                  // Title
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  // Content
                  Text(
                    widget.content,
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // OK Button
                  DialogButton(
                    text: 'OK',
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: CustomColors.background,
                    longPressColor: Colors.grey[300]!,
                    textColor: Colors.black,
                    width: isActionNotNull ? 130 : 95,
                    height: isActionNotNull ? 30 : 30,
                  ),

                  // Action Button
                  if (isActionNotNull) ...[
                    const SizedBox(width: 20),
                    DialogButton(
                      text: widget.actionText!,
                      onTap: widget.onActionTap!,
                      backgroundColor: Colors.black,
                      longPressColor: Colors.black.withOpacity(0.8),
                      textColor: Colors.white,
                      width: 130,
                      height: 30,
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
