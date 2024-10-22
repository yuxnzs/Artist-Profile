import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/managers/display_manager.dart';
import 'package:artist_profile/components/heading_text.dart';
import 'package:artist_profile/components/homepage_banner.dart';
import 'package:artist_profile/components/genre_section.dart';
import 'package:artist_profile/components/artist_content.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late APIService apiService;
  late DisplayManager displayManager;

  @override
  void initState() {
    super.initState();
    apiService = context.read<APIService>();
    displayManager = context.read<DisplayManager>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Avoid initializing the homepage after re-rendering
      if (!displayManager.hasHomepageInitialized) {
        initialize();
        displayManager.hasHomepageInitialized = true;
      }
    });
  }

  void initialize() async {
    await performAPICall(apiService.getGlobalTopArtists, 'global');
    await performAPICall(apiService.getTaiwanTopArtists, 'taiwan');
    await performAPICall(apiService.getUSATopArtists, 'usa');
    await performAPICall(apiService.getRecommendations, 'recommendations');
  }

  // Use function to toggle loading after API call
  Future<void> performAPICall(
      Future<void> Function() apiCall, String category) async {
    try {
      await apiCall();
      displayManager.toggleLoading(category: category);
    } catch (e) {
      // ArtistContent will display error message and retry button after 10 seconds if isLoading is still true
      log('API Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();
    final displayManager = context.watch<DisplayManager>();

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Text
              const SizedBox(height: 20),
              const HeadingText(text: "Artists Profile", fontSize: 25),
              const SizedBox(height: 15),

              // Banner
              const HomepageBanner(),
              const SizedBox(height: 30),

              // Global Top Artists Section
              const HeadingText(text: "Global Top Artists Today"),
              const SizedBox(height: 15),
              ArtistContent(
                artists: apiService.globalTopArtists,
                apiFunction: apiService.getGlobalTopArtists,
                isLoading: displayManager.isGlobalLoading,
                toggleLoading: () =>
                    displayManager.toggleLoading(category: 'global'),
                isError: displayManager.isGlobalError,
                toggleError: () =>
                    displayManager.toggleError(category: 'global'),
                category: "global",
              ),
              const SizedBox(height: 30),

              // Taiwan's Top Artists Section
              const HeadingText(text: "Taiwan Top Artists Today"),
              const SizedBox(height: 15),
              ArtistContent(
                artists: apiService.taiwanTopArtists,
                apiFunction: apiService.getTaiwanTopArtists,
                isLoading: displayManager.isTaiwanLoading,
                toggleLoading: () =>
                    displayManager.toggleLoading(category: 'taiwan'),
                isError: displayManager.isTaiwanError,
                toggleError: () =>
                    displayManager.toggleError(category: 'taiwan'),
                category: "taiwan",
              ),
              const SizedBox(height: 30),

              // USA's Top Artists Section
              const HeadingText(text: "USA Top Artists Today"),
              const SizedBox(height: 15),
              ArtistContent(
                artists: apiService.usaTopArtists,
                apiFunction: apiService.getUSATopArtists,
                isLoading: displayManager.isUSALoading,
                toggleLoading: () =>
                    displayManager.toggleLoading(category: 'usa'),
                isError: displayManager.isUSAError,
                toggleError: () => displayManager.toggleError(category: 'usa'),
                category: "usa",
              ),
              const SizedBox(height: 30),

              // Recommended Genres Section
              const HeadingText(text: "Recommended Genres"),
              const SizedBox(height: 15),
              const GenreSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
