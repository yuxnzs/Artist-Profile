import 'package:flutter/material.dart';
import 'package:artist_profile/helpers/database_helper.dart';

class SearchHistoryManager extends ChangeNotifier {
  // List to store search history
  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> get history => _history;

  // Fetch search history from the database when the app starts
  Future<void> fetchHistory() async {
    _history = await DatabaseHelper().getHistory();
    notifyListeners();
  }

  // Add a new search history to the database
  Future<void> addHistory(String searchText) async {
    await DatabaseHelper().addHistory(searchText);
    await fetchHistory(); // Update the list
  }

  // Delete a search history from the database
  Future<void> deleteHistory(int index) async {
    final id = _history[index]['id'];
    await DatabaseHelper().deleteHistory(id);
    await fetchHistory(); // Update the list
  }

  // Update the timestamp of a search history to display the most recent search at the top
  Future<void> updateTimestamp({
    required int index,
    required int timestamp,
  }) async {
    final id = _history[index]['id'];
    await DatabaseHelper().updateTimestamp(id: id, timestamp: timestamp);
    await fetchHistory(); // Update the list
  }
}
