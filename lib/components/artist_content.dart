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

  // Parent widget passes states and toggle functions from DisplayManager
  final bool isLoading;
  final void Function() toggleLoading;
  final bool isError;
  final void Function() toggleError;

  // For Hero() tag parameter
  final String category;

  const ArtistContent({
    super.key,
    this.selectedGenre,
    this.artists,
    required this.apiFunction,
    required this.isLoading,
    required this.toggleLoading,
    required this.isError,
    required this.toggleError,
    required this.category,
  });

  @override
  State<ArtistContent> createState() => _ArtistContentState();
}

class _ArtistContentState extends State<ArtistContent> {
  Timer? _timer; // Timer to check if API data failed to fetch

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 10), () {
      if (widget.isLoading) {
        widget.toggleError();
        widget.toggleLoading(); // Stop loading and display error message
      }
    });
  }

  void _fetchArtists(Future<void> Function() apiFunction) {
    apiFunction().then((_) {
      widget.toggleLoading();
      // If artists loaded successfully, cancel the timer
      _timer?.cancel();
    });
  }

  void onRetry() {
    widget.toggleLoading();
    widget.toggleError();

    // Reset the timer and get artists
    _startTimer();
    _fetchArtists(widget.apiFunction);
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();

    return Column(
      children: [
        // If isLoading, display LoadingArtistCard
        if (widget.isLoading)
          const ArtistPlaceholder()
        else if (widget.isError)
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
              category: widget.category,
            ),
          )
        else if (widget.artists != null)
          // Display all artists
          ArtistRow(
            artists: widget.artists!,
            category: widget.category,
          )
      ],
    );
  }
}
