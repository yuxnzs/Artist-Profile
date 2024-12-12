import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WikiLanguageManager with ChangeNotifier {
  String _wikiLanguage = 'en'; // Default language
  String get wikiLanguage => _wikiLanguage;

  WikiLanguageManager() {
    _loadWikiLanguage(); // Load saved value when initialized
  }

  // Set and save language
  void setWikiLanguage(String language) async {
    _wikiLanguage = language;
    notifyListeners();
    await _saveWikiLanguage(language);
  }

  // Save language to SharedPreferences
  Future<void> _saveWikiLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wikiLanguage', language);
  }

  // Load language from SharedPreferences
  Future<void> _loadWikiLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    // If not saved, use default value
    _wikiLanguage = prefs.getString('wikiLanguage') ?? 'en';
    notifyListeners();
  }
}
