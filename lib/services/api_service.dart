import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:artist_profile/models/artist.dart';

class APIService with ChangeNotifier {
  final String baseUrl = dotenv.get('BASE_URL');
  List<Artist> hot100Artists = [];
  List<Artist> top50Artists = [];
  List<Artist> mostStreamedArtists = [];
  List<Artist> recommendedArtists = [];

  String hot100Title = "";
  String top50Title = "";
  String mostStreamedTitle = "";
  String recommendedTitle = "";

  String hot100InfoTitle = "";
  String top50InfoTitle = "";
  String mostStreamedInfoTitle = "";
  String hot100InfoContent = "";
  String top50InfoContent = "";
  String mostStreamedInfoContent = "";

  String hot100Link = "";
  String top50Link = "";
  String mostStreamedLink = "";

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
        if (jsonData.containsKey('artists')) {
          // Used when retrying to fetch artists after an error
          return {
            'title': jsonData['title']?.toString() ?? '',
            'artists': jsonData['artists']
                .map<Artist>((item) => fromJson(item))
                .toList(),
            'sectionTitle': jsonData['sectionTitle']?.toString() ?? '',
            'sectionContent': jsonData['sectionContent']?.toString() ?? '',
            'playlistLink': jsonData['playlistLink']?.toString() ?? '',
          };
        } else {
          // Used for Homepage or ArtistBio page (Artist or ArtistBio object)
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
    String endpoint,
    List<Artist> targetList,
    void Function(String) setTitle,
    void Function(String)? setInfoTitle,
    void Function(String)? setInfoContent,
    void Function(String)? setLink,
  ) async {
    final artistsData =
        await _fetchArtistsData<Artist>(endpoint, Artist.fromJson);
    setTitle(artistsData['title']);
    targetList.clear(); // For multiple calls on the same endpoint's targetList
    targetList.addAll(artistsData['artists']);
    setInfoTitle?.call(artistsData['sectionTitle']);
    setInfoContent?.call(artistsData['sectionContent']);
    setLink?.call(artistsData['playlistLink']);

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
        '/spotify-artists/homepage',
        (json) => json,
      ); // (json) => json, gets the original JSON data without any changes

      if (allArtistsData != null) {
        // Add data to lists based on JSON keys
        if (allArtistsData.containsKey('hot100')) {
          hot100Artists.addAll(
              _convertToArtistList(allArtistsData['hot100']['artists']));
          hot100Title = allArtistsData['hot100']['title'];
          hot100InfoTitle = allArtistsData['hot100']['sectionTitle'];
          hot100InfoContent = allArtistsData['hot100']['sectionContent'];
          hot100Link = allArtistsData['hot100']['playlistLink'];
        }
        if (allArtistsData.containsKey('top50')) {
          top50Artists
              .addAll(_convertToArtistList(allArtistsData['top50']['artists']));
          top50Title = allArtistsData['top50']['title'];
          top50InfoTitle = allArtistsData['top50']['sectionTitle'];
          top50InfoContent = allArtistsData['top50']['sectionContent'];
          top50Link = allArtistsData['top50']['playlistLink'];
        }
        if (allArtistsData.containsKey('mostStreamed')) {
          mostStreamedArtists.addAll(
              _convertToArtistList(allArtistsData['mostStreamed']['artists']));
          mostStreamedTitle = allArtistsData['mostStreamed']['title'];
          mostStreamedInfoTitle =
              allArtistsData['mostStreamed']['sectionTitle'];
          mostStreamedInfoContent =
              allArtistsData['mostStreamed']['sectionContent'];
          mostStreamedLink = allArtistsData['mostStreamed']['playlistLink'];
        }
        if (allArtistsData.containsKey('recommendations')) {
          recommendedArtists.addAll(_convertToArtistList(
              allArtistsData['recommendations']['artists']));
          recommendedTitle = allArtistsData['recommendations']['title'];
        }

        notifyListeners();
      }
    } catch (e) {
      throw Exception('Error fetching homepage artists: $e');
    }
  }

  // For retry functions
  // Fetch Hot 100 artists
  Future<void> getHot100Artists() => fetchArtistsForCategory(
        '/spotify-artists/hot100',
        hot100Artists,
        (title) => hot100Title = title,
        (infoTitle) => hot100InfoTitle = infoTitle,
        (infoContent) => hot100InfoContent = infoContent,
        (link) => hot100Link = link,
      );

  // Fetch Top 50 artists
  Future<void> getTop50Artists() => fetchArtistsForCategory(
        '/spotify-artists/top50',
        top50Artists,
        (title) => top50Title = title,
        (infoTitle) => top50InfoTitle = infoTitle,
        (infoContent) => top50InfoContent = infoContent,
        (link) => top50Link = link,
      );

  // Fetch Most Streamed artists
  Future<void> getMostStreamedArtists() => fetchArtistsForCategory(
        '/spotify-artists/most-streamed',
        mostStreamedArtists,
        (title) => mostStreamedTitle = title,
        (infoTitle) => mostStreamedInfoTitle = infoTitle,
        (infoContent) => mostStreamedInfoContent = infoContent,
        (link) => mostStreamedLink = link,
      );

  // Fetch recommended artists
  Future<void> getRecommendations() => fetchArtistsForCategory(
        '/recommendations',
        recommendedArtists,
        (title) => recommendedTitle = title,
        null,
        null,
        null,
      );

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
