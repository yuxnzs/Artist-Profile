import 'package:flutter/material.dart';
import 'package:artist_profile/components/common/notification_bar.dart';

class NotificationManager {
  OverlayEntry? _notificationEntry;
  final GlobalKey<NotificationBarState> _notificationKey =
      GlobalKey<NotificationBarState>();

  void showNotification({
    required BuildContext context,
    required String message,
    required int duration,
    required bool isSlideHorizontal,
  }) {
    // If there is already a notification showing, do nothing
    if (_notificationEntry != null) return;

    // Create a new Notification OverlayEntry
    _notificationEntry = OverlayEntry(
      builder: (context) => NotificationBar(
        key: _notificationKey,
        message: message,
        onDismiss: removeNotification,
        duration: duration,
        isSlideHorizontal: isSlideHorizontal,
      ),
    );

    // Insert the new notification into the Overlay with the given context
    Overlay.of(context).insert(_notificationEntry!);
  }

  void hideNotificationBar() {
    // Animate the notification bar to hide and remove it in NotificationBar
    if (_notificationKey.currentState != null) {
      // addPostFrameCallback to prevent update UI when widget tree is locked,
      // when parent widget calls this method in dispose()
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notificationKey.currentState!.hideNotificationBar();
      });
    }
  }

  // This will be called after the notification bar is animated hidden in NotificationBar
  // Call hideNotificationBar() will trigger this method in NotificationBar
  void removeNotification() {
    _notificationEntry?.remove();
    _notificationEntry = null;
  }
}
