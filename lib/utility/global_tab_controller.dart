import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

class GlobalTabController extends ChangeNotifier {
  // Global controller for MainNavigation and HomepageBanner to control and get the tab index
  final PersistentTabController _tabController =
      PersistentTabController(initialIndex: 0);

  static final GlobalTabController _instance = GlobalTabController._internal();
  factory GlobalTabController() => _instance;

  GlobalTabController._internal() {
    // To notify listeners when the tab index changes
    _tabController.addListener(() {
      notifyListeners();
    });
  }

  PersistentTabController get tabController => _tabController;

  // Get current tab index
  int get index => _tabController.index;

  void jumpToTab(int index) {
    _tabController.jumpToTab(index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Global instance of GlobalTabController
final globalTabController = GlobalTabController();
