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

        // Return null to getArtistData() to return an empty map
        if (jsonData.isEmpty) {
          log("No data found");
          return null;
        }

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

  // Fetch artists for a specific endpoint
  Future<void> fetchArtistsForCategory(
      String endpoint, List<Artist> targetList) async {
    final artists = await _fetchArtistsData<Artist>(endpoint, Artist.fromJson);
    targetList.clear(); // For multiple calls on the same endpoint's targetList
    targetList.addAll(artists);

    notifyListeners();
  }

  List<Artist> _convertToArtistList(dynamic data) {
    if (data is List) {
      // Convert each JSON object to an Artist object
      return data.map((item) => Artist.fromJson(item)).toList();
    }
    return [];
  }

  // Get all artists for homepage
  Future<void> getAllHomepageArtists() async {
    try {
      final allArtistsData = await _fetchArtistsData<Map<String, dynamic>>(
          '/spotify-artists/homepage', (json) => json);

      if (allArtistsData != null) {
        // Add data to lists based on JSON keys
        if (allArtistsData.containsKey('global')) {
          globalTopArtists
              .addAll(_convertToArtistList(allArtistsData['global']));
        }
        if (allArtistsData.containsKey('us')) {
          usaTopArtists.addAll(_convertToArtistList(allArtistsData['us']));
        }
        if (allArtistsData.containsKey('tw')) {
          taiwanTopArtists.addAll(_convertToArtistList(allArtistsData['tw']));
        }
        if (allArtistsData.containsKey('recommendations')) {
          recommendedArtists
              .addAll(_convertToArtistList(allArtistsData['recommendations']));
        }

        notifyListeners();
      }
    } catch (e) {
      throw Exception('Error fetching homepage artists: $e');
    }
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
        // Return an empty map to ArtistBioPage to display error message
        if (artist == null) {
          return {};
        }
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
