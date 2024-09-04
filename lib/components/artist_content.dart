import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/components/artist_placeholder.dart';
import 'package:artist_profile/components/loading_error.dart';
import 'package:artist_profile/components/artist_row.dart';
import 'package:artist_profile/models/artist.dart';

class ArtistContent extends StatefulWidget {
  // Only genre section has selectedGenre
  final String? selectedGenre;

  // For other sections like Global Top Artists
  // Genre section has artists provided by the genre, no need to provide artists list
  final List<Artist>? artists;

  // Fetch artists based on parent widget's apiFunction
  final Future<void> Function() apiFunction;

  const ArtistContent(
      {super.key, this.selectedGenre, this.artists, required this.apiFunction});

  @override
  State<ArtistContent> createState() => _ArtistContentState();
}

class _ArtistContentState extends State<ArtistContent> {
  bool isLoading = true;
  bool isError = false;
  Timer? _timer; // Timer to check if API data failed to fetch

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
      _getRecommendations(widget.apiFunction);
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

  void _getRecommendations(Future<void> Function() apiFunction) {
    apiFunction().then((_) {
      setState(() {
        isLoading = false;
        // If recommendations loaded successfully, cancel the timer
        _timer?.cancel();
      });
    });
  }

  void onRetry() {
    setState(() {
      isLoading = true;
      isError = false;
    });

    // Reset the timer and get recommendations
    _startTimer();
    _getRecommendations(widget.apiFunction);
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();

    return Column(
      children: [
        // If isLoading, display LoadingArtistCard
        if (isLoading)
          const ArtistPlaceholder()
        else if (isError)
          // Display error message and retry button
          LoadingError(onRetry: onRetry)
        else if (widget.selectedGenre != null)
          // Display artists based on selected genre
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ArtistRow(
              key: ValueKey<String>(widget
                  .selectedGenre!), // Unique key for animation switcher to work
              artists: apiService.recommendedArtists
                  .where((artist) => artist.genres
                      // Check if the selected genre is in the artist's genres list
                      .any((genre) =>
                          genre == widget.selectedGenre!.toLowerCase()))
                  .toList(),
            ),
          )
        else if (widget.artists != null)
          // Display all artists
          ArtistRow(
            artists: widget.artists!,
          )
      ],
    );
  }
}
