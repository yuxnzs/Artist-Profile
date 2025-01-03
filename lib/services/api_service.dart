import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:artist_profile/models/artist.dart';
import 'package:artist_profile/managers/wiki_language_manager.dart';
import 'package:artist_profile/managers/cache_manager.dart';
import 'package:artist_profile/models/artist_hive.dart';
import 'package:artist_profile/utility/app_constants.dart';

class APIService with ChangeNotifier {
  final String baseUrl = dotenv.get('BASE_URL');
  final WikiLanguageManager wikiLanguageManager;
  final cacheManager = CacheManager('homepageArtistsCache');

  // For main to pass displayManager with context
  APIService(this.wikiLanguageManager);

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
      return data.map((item) {
        // Cached JSON data is Map<dynamic, dynamic>
        // Convert it to Map<String, dynamic> for Artist.fromJson
        final mapItem = Map<String, dynamic>.from(item);
        return Artist.fromJson(mapItem);
      }).toList();
    }
    return [];
  }

  void _addArtistData(
    Map<String, dynamic> allArtistsData,
    String key,
    List<Artist> artistList, {
    Function(String)? updateTitle,
    Function(String)? updateInfoTitle,
    Function(String)? updateInfoContent,
    Function(String)? updateLink,
  }) {
    // Add data to lists based on JSON keys
    if (allArtistsData.containsKey(key)) {
      final data = allArtistsData[key];
      artistList.addAll(_convertToArtistList(data['artists']));
      updateTitle?.call(data['title']);
      updateInfoTitle?.call(data['sectionTitle']);
      updateInfoContent?.call(data['sectionContent']);
      updateLink?.call(data['playlistLink']);
    }
  }

  // Get all artists for homepage
  Future<void> getAllHomepageArtists() async {
    try {
      Map<String, dynamic> allArtistsData;
      final cachedData = await cacheManager.getCache<Map<String, dynamic>>(
        key: 'homepageArtists',
        isMap: true,
      );

      if (cachedData != null) {
        allArtistsData = cachedData;
      } else {
        allArtistsData = await _fetchArtistsData<Map<String, dynamic>>(
          '/spotify-artists/homepage',
          (json) => json,
        ); // (json) => json, gets the original JSON data without any changes

        // Cache the data if it's not cached
        await cacheManager.saveCache<Map<String, dynamic>>(
          key: 'homepageArtists',
          data: allArtistsData,
          cacheDuration: AppConstants.cacheDuration,
        );
      }

      _addArtistData(allArtistsData, 'hot100', hot100Artists,
          updateTitle: (title) => hot100Title = title,
          updateInfoTitle: (infoTitle) => hot100InfoTitle = infoTitle,
          updateInfoContent: (infoContent) => hot100InfoContent = infoContent,
          updateLink: (link) => hot100Link = link);

      _addArtistData(allArtistsData, 'top50', top50Artists,
          updateTitle: (title) => top50Title = title,
          updateInfoTitle: (infoTitle) => top50InfoTitle = infoTitle,
          updateInfoContent: (infoContent) => top50InfoContent = infoContent,
          updateLink: (link) => top50Link = link);

      _addArtistData(allArtistsData, 'mostStreamed', mostStreamedArtists,
          updateTitle: (title) => mostStreamedTitle = title,
          updateInfoTitle: (infoTitle) => mostStreamedInfoTitle = infoTitle,
          updateInfoContent: (infoContent) =>
              mostStreamedInfoContent = infoContent,
          updateLink: (link) => mostStreamedLink = link);

      _addArtistData(allArtistsData, 'recommendations', recommendedArtists,
          updateTitle: (title) => recommendedTitle = title);

      notifyListeners();
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
        '/spotify-artists/recommendations',
        recommendedArtists,
        (title) => recommendedTitle = title,
        null,
        null,
        null,
      );

  // For SearchPage: fetch artist ID by user input
  Future<String?> _fetchArtistIdByName(String artistName) async {
    try {
      final cachedData = await cacheManager.getCache<String>(
        key: artistName,
      );

      if (cachedData != null) {
        if (cachedData == "NULL") {
          return null;
        }
        return cachedData;
      } else {
        final response =
            await http.get(Uri.parse('$baseUrl/get-artist-id/$artistName'));

        if (response.statusCode == 200) {
          final id = response.body;
          if (id.isNotEmpty) {
            await cacheManager.saveCache<String>(
              key: artistName,
              data: id,
              cacheDuration: AppConstants.cacheDuration,
            );
            return id;
          }
          // If no id, save null to cache to avoid future calls
          await cacheManager.saveCache(
            key: artistName,
            data:
                "NULL", // Use string NULL to avoid mix-up with actual null checking
            cacheDuration: AppConstants.cacheDuration,
          );
          return null;
        } else {
          throw Exception(
              'Failed to load data from /get-artist-id/$artistName. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      log('Error fetching artist ID: $e');
      return null;
    }
  }

  // Fetch artist data for ArtistBio page
  Future<dynamic> getArtistData({
    Artist? passedArtist, // From Homepage, to fetch artist data directly
    required String artistName, // From SearchPage, to fetch artist ID
    required bool includeSpotifyInfo,
  }) async {
    try {
      String? fetchedArtistId;
      // If includeSpotifyInfo, is from SearchPage, need to fetch artist ID
      if (includeSpotifyInfo) {
        fetchedArtistId = await _fetchArtistIdByName(artistName);
        if (fetchedArtistId == null) {
          // Return an empty map to ArtistBioPage to display error message
          return {};
        }
      }

      // Get cached data
      final cachedData = await cacheManager.getCache<ArtistHive>(
        // If includeSpotifyInfo (from SearchPage), use fetchedArtistId
        // If not (from Homepage), use passedArtistId
        key: includeSpotifyInfo
            ? "$fetchedArtistId-${wikiLanguageManager.wikiLanguage}"
            : "${passedArtist!.id}-${wikiLanguageManager.wikiLanguage}",
        // passedArtistId is not null if is from Homepage (includeSpotifyInfo is false)
      );

      if (cachedData != null) {
        if (includeSpotifyInfo) {
          return Artist.fromHiveModel(cachedData);
        } else {
          return ArtistBio.fromHiveModel(cachedData.bio!);
        }
      } else {
        if (includeSpotifyInfo) {
          // For SearchPage: includeSpotifyInfo is true, return Artist
          final Artist artist = await _fetchArtistsData<Artist>(
            '/artist-bio/$fetchedArtistId?includeSpotifyInfo=$includeSpotifyInfo&wikiLanguage=${wikiLanguageManager.wikiLanguage}',
            Artist.fromJson,
          );

          await cacheManager.saveCache<ArtistHive>(
            key: "$fetchedArtistId-${wikiLanguageManager.wikiLanguage}",
            data: artist.toHiveModel(),
            cacheDuration: AppConstants.cacheDuration,
          );

          return artist;
        } else {
          // For Homepage: includeSpotifyInfo is false, return ArtistBio
          final ArtistBio artistBio = await _fetchArtistsData<ArtistBio>(
            '/artist-bio/${passedArtist!.id}?name=$artistName&includeSpotifyInfo=$includeSpotifyInfo&wikiLanguage=${wikiLanguageManager.wikiLanguage}',
            // Handle nested JSON, extract bio
            (json) => ArtistBio.fromJson(json['bio']),
          );

          // Combine Artist from Homepage and ArtistBio from API to a Artist object
          Artist combinedArtist = Artist(
            id: passedArtist.id,
            name: passedArtist.name,
            image: passedArtist.image,
            popularity: passedArtist.popularity,
            followers: passedArtist.followers,
            genres: passedArtist.genres,
            spotifyUrl: passedArtist.spotifyUrl,
            bio: artistBio,
          );

          await cacheManager.saveCache<ArtistHive>(
            key: "${passedArtist.id}-${wikiLanguageManager.wikiLanguage}",
            data: combinedArtist.toHiveModel(),
            cacheDuration: AppConstants.cacheDuration,
          );

          return artistBio;
        }
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
