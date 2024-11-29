import 'package:flutter/material.dart';

class DisplayManager with ChangeNotifier {
  bool isGlobalLoading = true;
  bool isTaiwanLoading = true;
  bool isUSALoading = true;
  bool isRecommendationsLoading = true;

  bool isGlobalError = false;
  bool isTaiwanError = false;
  bool isUSAError = false;
  bool isRecommendationsError = false;

  bool hasHomepageInitialized = false;

  bool hideNavigationBar = false;
  bool isNavBarDisabled = false;

  void toggleLoading({required String category}) {
    switch (category) {
      case 'global':
        isGlobalLoading = !isGlobalLoading;
        break;
      case 'taiwan':
        isTaiwanLoading = !isTaiwanLoading;
        break;
      case 'usa':
        isUSALoading = !isUSALoading;
        break;
      case 'recommendations':
        isRecommendationsLoading = !isRecommendationsLoading;
        break;
      case 'allHomepageArtists':
        isGlobalLoading = false;
        isTaiwanLoading = false;
        isUSALoading = false;
        isRecommendationsLoading = false;
        break;
      default:
        throw Exception("Unknown variable name");
    }
    notifyListeners();
  }

  void toggleError({required String category}) {
    switch (category) {
      case 'global':
        isGlobalError = !isGlobalError;
        break;
      case 'taiwan':
        isTaiwanError = !isTaiwanError;
        break;
      case 'usa':
        isUSAError = !isUSAError;
        break;
      case 'recommendations':
        isRecommendationsError = !isRecommendationsError;
        break;
      case 'allHomepageArtists':
        isGlobalError = true;
        isTaiwanError = true;
        isUSAError = true;
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
