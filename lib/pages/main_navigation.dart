import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:artist_profile/utility/global_tab_controller.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/pages/homepage.dart';
import 'package:artist_profile/pages/search_page.dart';
import 'package:artist_profile/pages/setting_page.dart';
import 'package:artist_profile/managers/display_manager.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    globalTabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    globalTabController.dispose();
    super.dispose();
  }

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: const Homepage(),
        item: ItemConfig(
          icon: Icon(globalTabController.index == 0
              ? Icons.home
              : Icons.home_outlined),
          activeForegroundColor: Colors.blue,
          inactiveForegroundColor: Colors.grey,
        ),
      ),
      PersistentTabConfig(
        screen: SearchPage(isKeyboardVisible: isKeyboardVisible),
        item: ItemConfig(
          icon: const Icon(
              Icons.search), // Search icon doesn't have a filled version
          activeForegroundColor: Colors.blue,
          inactiveForegroundColor: Colors.grey,
        ),
      ),
      PersistentTabConfig(
        screen: const SettingPage(),
        item: ItemConfig(
          icon: Icon(globalTabController.index == 2
              ? Icons.settings
              : Icons.settings_outlined),
          activeForegroundColor: Colors.blue,
          inactiveForegroundColor: Colors.grey,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final displayManager = context.watch<DisplayManager>();
    // SearchPage cannot detect the keyboard visibility, so need to check it here
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AbsorbPointer(
          // Temporarily disable the navigation bar interaction while animating to hide
          absorbing: displayManager.isNavBarDisabled,
          child: PersistentTabView(
            controller: globalTabController.tabController,
            tabs: _tabs(),
            navBarBuilder: (navBarConfig) => Style4BottomNavBar(
              navBarConfig: navBarConfig,
              navBarDecoration: const NavBarDecoration(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
            ),
            navBarOverlap: const NavBarOverlap.full(),
            navBarHeight: AppConstants.bottomNavBarHeight,
            avoidBottomPadding: false,
            margin: const EdgeInsets.only(bottom: 18),
            hideNavigationBar: displayManager.hideNavigationBar,
          ),
        ),

        // Fill the bottom margin
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.translationValues(
              0, displayManager.hideNavigationBar ? 18 : 0, 0),
          child: Container(
            color: Colors.white,
            height: 18,
          ),
        ),
      ],
    );
  }
}
