import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:artist_profile/models/artist.dart';

class APIService with ChangeNotifier {
  final String baseUrl = dotenv.get('BASE_URL');
  List<Artist> recommendedArtists = [];
  List<Artist> globalTopArtists = [];
  List<Artist> taiwanTopArtists = [];
  List<Artist> usaTopArtists = [];

  // Fetch artists from the API based on the endpoint
  Future<List<Artist>> _fetchArtists(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> jsonData = jsonDecode(response.body);

      // Convert each JSON object to an Artist object
      return jsonData.map((artist) => Artist.fromJson(artist)).toList();
    } else {
      throw Exception('Failed to load artists from $endpoint');
    }
  }

  // Fetch artists for a specific category
  Future<void> fetchArtistsForCategory(
      String endpoint, List<Artist> targetList) async {
    final artists = await _fetchArtists(endpoint);
    targetList.clear();
    targetList.addAll(artists);

    notifyListeners();
  }

  // Fetch recommended artists
  Future<void> getRecommendations() =>
      fetchArtistsForCategory('/recommendations', recommendedArtists);

  // Fetch global top artists
  Future<void> getGlobalTopArtists() =>
      fetchArtistsForCategory('/spotify-artists/global', globalTopArtists);

  // Fetch USA top artists
  Future<void> getUSATopArtists() =>
      fetchArtistsForCategory('/spotify-artists/us', usaTopArtists);

  // Fetch Taiwan top artists
  Future<void> getTaiwanTopArtists() =>
      fetchArtistsForCategory('/spotify-artists/tw', taiwanTopArtists);
}
