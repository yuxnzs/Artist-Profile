import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:artist_profile/utility/global_tab_controller.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/pages/homepage.dart';
import 'package:artist_profile/pages/search_page.dart';
import 'package:artist_profile/managers/display_manager.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: const Homepage(),
        item: ItemConfig(
          icon: const Icon(Icons.home),
          activeForegroundColor: Colors.blue,
          inactiveForegroundColor: Colors.grey,
        ),
      ),
      PersistentTabConfig(
        screen: const SearchPage(),
        item: ItemConfig(
          icon: const Icon(Icons.search),
          activeForegroundColor: Colors.blue,
          inactiveForegroundColor: Colors.grey,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final displayManager = context.watch<DisplayManager>();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AbsorbPointer(
          // Temporarily disable the navigation bar interaction while animating to hide
          absorbing: displayManager.isNavBarDisabled,
          child: PersistentTabView(
            controller: globalTabController,
            tabs: _tabs(),
            navBarBuilder: (navBarConfig) => Style4BottomNavBar(
              navBarConfig: navBarConfig,
              navBarDecoration: const NavBarDecoration(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10),
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
        Container(
          color: Colors.white,
          height: 18,
        ),
      ],
    );
  }
}