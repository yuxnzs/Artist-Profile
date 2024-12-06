import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';

class NotificationBar extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;
  final int duration;
  final bool isSlideHorizontal;

  const NotificationBar({
    super.key,
    required this.message,
    required this.onDismiss,
    required this.duration,
    required this.isSlideHorizontal,
  });

  @override
  State<NotificationBar> createState() => NotificationBarState();
}

class NotificationBarState extends State<NotificationBar> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAndHideNotificationBar();
    });
  }

  void showAndHideNotificationBar() {
    setState(() {
      isVisible = true;
    });

    Future.delayed(Duration(seconds: widget.duration), () {
      if (isVisible) {
        hideNotificationBar();
      }
    });
  }

  void hideNotificationBar() {
    setState(() {
      isVisible = false;
    });

    // Wait for animation to complete before remove notification bar
    Future.delayed(const Duration(milliseconds: 400), () {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double bottomPosition = widget.isSlideHorizontal
        ? 100 // Slide horizontally
        : (isVisible ? 40 : -100); // Slide vertically

    double leftPosition = widget.isSlideHorizontal
        // Slide horizontally
        ? (isVisible
            ? AppConstants.searchPageMargin
            : -MediaQuery.of(context).size.width) // Make sure it's off-screen
        : AppConstants.artistBioPageMargin; // Slide vertically

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      left: leftPosition,
      bottom: bottomPosition,
      // If slide horizontally, no need to set right
      right: widget.isSlideHorizontal ? null : AppConstants.artistBioPageMargin,
      child: Container(
        width: screenWidth -
            (widget.isSlideHorizontal
                ? AppConstants.searchPageMargin * 2
                : AppConstants.artistBioPageMargin * 2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: hideNotificationBar,
          child: Center(
            child: Text(
              widget.message,
              style: const TextStyle(
                fontSize: 15,
                height: 1.8,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
