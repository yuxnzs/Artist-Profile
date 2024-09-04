import 'dart:async';
import 'package:flutter/material.dart';
import 'package:artist_profile/components/heading_text.dart';
import 'package:artist_profile/components/homepage_banner.dart';
import 'package:artist_profile/components/genre_row.dart';
import 'package:artist_profile/components/artist_row.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/components/artist_placeholder.dart';
import 'package:artist_profile/components/loading_error.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;
  bool isError = false;
  Timer? _timer; // Timer to check if API data failed to fetch
  String selectedGenre = "POP"; // Display POP by default

  @override
  void initState() {
    super.initState();

    // Fetch recommendations when the page is initialized
    _initializeRecommendations();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeRecommendations() {
    // Set a timer to check if recommendations failed to fetch after 10 seconds
    _startTimer();

    // Get recommendations after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getRecommendations();
    });
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 10), () {
      if (isLoading) {
        setState(() {
          isError = true;
          isLoading = false; // Stop loading and display error message
        });
      }
    });
  }

  void _getRecommendations() {
    context.read<APIService>().getRecommendations().then((_) {
      setState(() {
        isLoading = false;
        // If recommendations loaded successfully, cancel the timer
        _timer?.cancel();
      });
    });
  }

  void retryGetRecommendations() {
    setState(() {
      isLoading = true;
      isError = false;
    });

    // Reset the timer and get recommendations
    _startTimer();
    _getRecommendations();
  }

  // Set selected genre, and render corresponding artists
  void onGenreSelected(String genre) {
    setState(() {
      selectedGenre = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: const Column(
                  children: [
                    // Header Text
                    HeadingText(text: "Artists Profile", fontSize: 25),
                    SizedBox(height: 15),

                    // Banner
                    HomepageBanner(),
                    SizedBox(height: 15),

                    // Genres Section
                    HeadingText(text: "Recommended Genres"),
                    SizedBox(height: 15),
                  ],
                ),
              ),

              // Recommended Genres Section
              // No margin, separate from the container above
              Column(
                children: [
                  GenreRow(
                    onGenreSelected: onGenreSelected,
                    selectedGenre: selectedGenre,
                  ),
                  const SizedBox(height: 15),

                  // If isLoading, display LoadingArtistCard
                  if (isLoading)
                    const ArtistPlaceholder()
                  else if (isError)
                    // Display error message and retry button
                    LoadingError(onRetry: retryGetRecommendations)
                  else
                    // Display artists based on selected genre
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: ArtistRow(
                        key: ValueKey<String>(
                            selectedGenre), // Unique key for animation switcher to work
                        artists: apiService.recommendedArtists
                            .where((artist) => artist.genres
                                // Check if the selected genre is in the artist's genres list
                                .any((genre) =>
                                    genre == selectedGenre.toLowerCase()))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
