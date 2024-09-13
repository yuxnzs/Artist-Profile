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
      default:
        throw Exception("Unknown variable name");
    }
    notifyListeners();
  }
}
