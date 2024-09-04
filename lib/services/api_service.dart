import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:artist_profile/models/artist.dart';

class APIService with ChangeNotifier {
  final String baseUrl = dotenv.get('BASE_URL');
  List<Artist> recommendedArtists = [];

  Future<void> getRecommendations() async {
    final response = await http.get(Uri.parse('$baseUrl/recommendations'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      // Convert each JSON object to an Artist object
      recommendedArtists = jsonData.map((artist) {
        return Artist.fromJson(artist);
      }).toList();

      notifyListeners();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}
