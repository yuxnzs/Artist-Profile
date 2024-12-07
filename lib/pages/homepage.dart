import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/managers/display_manager.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/homepage/heading_text.dart';
import 'package:artist_profile/components/homepage/homepage_banner.dart';
import 'package:artist_profile/components/homepage/genre_section.dart';
import 'package:artist_profile/components/homepage/artist_content.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late APIService apiService;
  late DisplayManager displayManager;
  double sectionSpacing = 25;

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
    try {
      await apiService.getAllHomepageArtists();
      displayManager.toggleLoading(category: 'allHomepageArtists');
    } catch (e) {
      displayManager.toggleError(category: 'allHomepageArtists');
      log("Error in homepage initialization: $e");
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
              SizedBox(height: sectionSpacing),

              // Hot 100 Section
              // Even if the artists are empty after fetching, loading placeholder will still be shown
              if (displayManager.isHot100Loading ||
                  displayManager.isHot100Error ||
                  apiService.hot100Artists.isNotEmpty) ...[
                ArtistContent(
                  title: apiService.hot100Title,
                  artists: apiService.hot100Artists,
                  apiFunction: apiService.getHot100Artists,
                  isLoading: displayManager.isHot100Loading,
                  toggleLoading: () =>
                      displayManager.toggleLoading(category: 'hot100'),
                  isError: displayManager.isHot100Error,
                  toggleError: () =>
                      displayManager.toggleError(category: 'hot100'),
                  category: "hot100",
                  sectionInfoTitle: apiService.hot100InfoTitle,
                  sectionInfoContent: apiService.hot100InfoContent,
                  playlistLink: apiService.hot100Link,
                ),
                SizedBox(height: sectionSpacing),
              ],

              // Top 50 Section
              if (displayManager.isTop50Loading ||
                  displayManager.isTop50Error ||
                  apiService.top50Artists.isNotEmpty) ...[
                ArtistContent(
                  title: apiService.top50Title,
                  artists: apiService.top50Artists,
                  apiFunction: apiService.getTop50Artists,
                  isLoading: displayManager.isTop50Loading,
                  toggleLoading: () =>
                      displayManager.toggleLoading(category: 'top50'),
                  isError: displayManager.isTop50Error,
                  toggleError: () =>
                      displayManager.toggleError(category: 'top50'),
                  category: "top50",
                  sectionInfoTitle: apiService.top50InfoTitle,
                  sectionInfoContent: apiService.top50InfoContent,
                  playlistLink: apiService.top50Link,
                ),
                SizedBox(height: sectionSpacing),
              ],

              // Artists With Most Streamed Songs Section
              if (displayManager.isMostStreamedLoading ||
                  displayManager.isMostStreamedError ||
                  apiService.mostStreamedArtists.isNotEmpty) ...[
                ArtistContent(
                  title: apiService.mostStreamedTitle,
                  artists: apiService.mostStreamedArtists,
                  apiFunction: apiService.getMostStreamedArtists,
                  isLoading: displayManager.isMostStreamedLoading,
                  toggleLoading: () =>
                      displayManager.toggleLoading(category: 'mostStreamed'),
                  isError: displayManager.isMostStreamedError,
                  toggleError: () =>
                      displayManager.toggleError(category: 'mostStreamed'),
                  category: "mostStreamed",
                  sectionInfoTitle: apiService.mostStreamedInfoTitle,
                  sectionInfoContent: apiService.mostStreamedInfoContent,
                  playlistLink: apiService.mostStreamedLink,
                ),
                SizedBox(height: sectionSpacing),
              ],

              // Recommended Genres Section
              if (displayManager.isRecommendationsLoading ||
                  displayManager.isRecommendationsError ||
                  apiService.recommendedArtists.isNotEmpty) ...[
                const GenreSection(),
                SizedBox(height: sectionSpacing + 20),
              ],
              const SizedBox(
                height: AppConstants.bottomNavBarHeight + 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
