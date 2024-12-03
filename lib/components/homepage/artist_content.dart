import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/components/homepage/section_placeholder.dart';
import 'package:artist_profile/components/common/loading_error.dart';
import 'package:artist_profile/components/common/custom_alert_dialog.dart';
import 'package:artist_profile/components/homepage/artist_row.dart';
import 'package:artist_profile/components/homepage/heading_text.dart';
import 'package:artist_profile/models/artist.dart';

class ArtistContent extends StatefulWidget {
  // Title for the section
  final String? title;

  // Only genre section has selectedGenre
  final String? selectedGenre;

  // For other sections like Most Appearances on Top 100
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

  // Section info
  final String? sectionInfoTitle;
  final String? sectionInfoContent;

  // Spotify playlist link
  final String? playlistLink;

  const ArtistContent({
    super.key,
    this.title,
    this.selectedGenre,
    this.artists,
    required this.apiFunction,
    required this.isLoading,
    required this.toggleLoading,
    required this.isError,
    required this.toggleError,
    required this.category,
    this.sectionInfoTitle,
    this.sectionInfoContent,
    this.playlistLink,
  });

  @override
  State<ArtistContent> createState() => _ArtistContentState();
}

class _ArtistContentState extends State<ArtistContent> {
  // Used for UI delay, actual error is passed via widget.isError
  bool _showError = false;
  // Prevent multiple calls to didUpdateWidget after toggleLoading is triggered
  // (since isLoading is passed from the parent, calling toggleLoading will trigger didUpdateWidget again)
  bool _hasCalledDidUpdateWidgetOnce = false;

  @override
  void didUpdateWidget(covariant ArtistContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If API call fails, display error message and retry button after 2 seconds to avoid flickering
    if (widget.isError && !_showError && !_hasCalledDidUpdateWidgetOnce) {
      _hasCalledDidUpdateWidgetOnce = true;
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showError = true;
          });
        }
        // Set isLoading to false to display error message
        widget.toggleLoading();
      });
    }
  }

  void _fetchArtists(Future<void> Function() apiFunction) {
    apiFunction().then((_) {
      widget.toggleLoading();
    }).catchError((e) {
      log(e.toString());
      widget.toggleError();
    });
  }

  void onRetry() {
    widget.toggleLoading();
    widget.toggleError();
    _showError = false;
    _hasCalledDidUpdateWidgetOnce = false;

    // Fetch artists again
    _fetchArtists(widget.apiFunction);
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();

    return Column(
      children: [
        // If isLoading, display LoadingArtistCard
        if (widget.isLoading)
          const SectionPlaceholder()
        else if (_showError)
          // Display error message and retry button
          LoadingError(onRetry: onRetry)
        // Recommendation section at the bottom of homepage
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
        // Charts section at the top of homepage
        else if (widget.artists != null) ...[
          Row(
            children: [
              HeadingText(text: widget.title ?? ""),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  // Show section info dialog
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: widget.sectionInfoTitle ?? "",
                      content:
                          "${widget.sectionInfoContent ?? ""}\n\nVisit Spotify to explore the full chart.",
                      width: 310,
                      actionText: "Open Spotify",
                      onActionTap: () async {
                        final spotifyUri = widget.playlistLink!.replaceAll(
                            'https://open.spotify.com/', 'spotify://');
                        // If the user doesn't have Spotify installed, open the web link
                        if (!await launchUrl(Uri.parse(spotifyUri))) {
                          launchUrl(Uri.parse(widget.playlistLink!));
                        }
                      },
                    ),
                  );
                },
                child:
                    Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Display all artists
          ArtistRow(
            artists: widget.artists!,
            category: widget.category,
          )
        ] else
          const SizedBox.shrink()
      ],
    );
  }
}
