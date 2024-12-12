import 'package:flutter/material.dart';

class DisplayManager with ChangeNotifier {
  bool isHot100Loading = true;
  bool isTop50Loading = true;
  bool isMostStreamedLoading = true;
  bool isRecommendationsLoading = true;

  bool isHot100Error = false;
  bool isTop50Error = false;
  bool isMostStreamedError = false;
  bool isRecommendationsError = false;

  bool hasHomepageInitialized = false;

  bool hideNavigationBar = false;
  bool isNavBarDisabled = false;

  void toggleLoading({required String category}) {
    switch (category) {
      case 'hot100':
        isHot100Loading = !isHot100Loading;
        break;
      case 'top50':
        isTop50Loading = !isTop50Loading;
        break;
      case 'mostStreamed':
        isMostStreamedLoading = !isMostStreamedLoading;
        break;
      case 'recommendations':
        isRecommendationsLoading = !isRecommendationsLoading;
        break;
      case 'allHomepageArtists':
        isHot100Loading = false;
        isTop50Loading = false;
        isMostStreamedLoading = false;
        isRecommendationsLoading = false;
        break;
      default:
        throw Exception("Unknown variable name");
    }
    notifyListeners();
  }

  void toggleError({required String category}) {
    switch (category) {
      case 'hot100':
        isHot100Error = !isHot100Error;
        break;
      case 'top50':
        isTop50Error = !isTop50Error;
        break;
      case 'mostStreamed':
        isMostStreamedError = !isMostStreamedError;
        break;
      case 'recommendations':
        isRecommendationsError = !isRecommendationsError;
        break;
      case 'allHomepageArtists':
        isHot100Error = true;
        isTop50Error = true;
        isMostStreamedError = true;
        isRecommendationsError = true;
        break;
      default:
        throw Exception("Unknown variable name");
    }
    notifyListeners();
  }

  void setHideNavigationBar(bool shouldHide) {
    hideNavigationBar = shouldHide;
    isNavBarDisabled = shouldHide;

    // Temporarily disable the navigation bar interaction while animating to hide
    // Prevent user from switching tabs while it's disappearing
    if (shouldHide) {
      // Enable interaction after the navigation bar is hidden
      // So that when it reappears, user can interact with it immediately
      Future.delayed(const Duration(milliseconds: 350), () {
        isNavBarDisabled = false;
        notifyListeners();
      });
    }

    notifyListeners();
  }
}
