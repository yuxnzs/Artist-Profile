import 'dart:convert';
import 'dart:developer';
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

  // Fetch data from the API based on the endpoint
  Future<dynamic> _fetchArtistsData<T>(
      String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Check if the response body is empty (response.body is a string)
        if (response.body.isEmpty) {
          log("Response body is empty");
          return null;
        }

        // Parse the JSON response
        final dynamic jsonData = jsonDecode(response.body);

        // Convert each JSON object to the designated type object
        if (jsonData is List) {
          // List of Artist objects, List<Artist>
          return jsonData.map((item) => fromJson(item)).toList();
        } else {
          // An Artist or ArtistBio object
          return fromJson(jsonData);
        }
      } else {
        throw Exception(
            'Failed to load data from $endpoint. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Network error or other exceptions
      throw Exception('Error fetching data from $endpoint: $e');
    }
  }

  // Fetch artists for a specific category
  Future<void> fetchArtistsForCategory(
      String endpoint, List<Artist> targetList) async {
    final artists = await _fetchArtistsData<Artist>(endpoint, Artist.fromJson);
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

  // Fetch artist data for ArtistBio page
  Future<dynamic> getArtistData({
    required String artistName,
    required bool includeSpotifyInfo,
  }) async {
    try {
      if (includeSpotifyInfo) {
        // includeSpotifyInfo is true, return Artist
        final Artist? artist = await _fetchArtistsData<Artist>(
          '/artist-bio/$artistName?includeSpotifyInfo=$includeSpotifyInfo',
          Artist.fromJson,
        );
        return artist;
      } else {
        // includeSpotifyInfo is false, return ArtistBio
        final ArtistBio? artistBio = await _fetchArtistsData<ArtistBio>(
          '/artist-bio/$artistName?includeSpotifyInfo=$includeSpotifyInfo',
          // Handle nested JSON, extract bio
          (json) => ArtistBio.fromJson(json['bio']),
        );
        return artistBio;
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
