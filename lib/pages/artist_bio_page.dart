import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/managers/display_manager.dart';
import 'package:artist_profile/models/artist.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/components/artist_bio_page/drag_indicator.dart';
import 'package:artist_profile/components/artist_bio_page/artist_bio_header.dart';
import 'package:artist_profile/components/artist_bio_page/stat_row.dart';
import 'package:artist_profile/components/artist_bio_page/birth_info_row.dart';
import 'package:artist_profile/components/artist_bio_page/bio_text.dart';
import 'package:artist_profile/pages/loading_artist_bio_page.dart';
import 'package:artist_profile/components/artist_bio_page/external_links_section.dart';
import 'package:artist_profile/components/common/exit_button.dart';
import 'package:artist_profile/components/artist_bio_page/problem_button.dart';
import 'package:artist_profile/pages/error_artist_bio_page.dart';
import 'package:artist_profile/components/artist_bio_page/artist_bio_image.dart';
import 'package:artist_profile/managers/notification_manager.dart';

class ArtistBioPage extends StatefulWidget {
  final String artistName;
  final bool apiIncludeSpotifyInfo;
  // Pass from homepage's ArtistCard
  final Artist? passedArtist;
  // For Hero() tag parameter, passed from ArtistCard
  final String? category;

  const ArtistBioPage({
    super.key,
    required this.artistName,
    required this.apiIncludeSpotifyInfo,
    this.passedArtist,
    this.category,
  });

  @override
  State<ArtistBioPage> createState() => _ArtistBioPageState();
}

class _ArtistBioPageState extends State<ArtistBioPage> {
  final ScrollController _listViewController = ScrollController();
  final NotificationManager _notificationManager = NotificationManager();
  late APIService apiService;
  late DisplayManager displayManager;
  late dynamic apiArtistData; // Type will be Artist, ArtistBio, or null
  bool isLoading = true;
  bool isError = false;
  bool isNoData = false;

  @override
  void initState() {
    super.initState();
    apiService = context.read<APIService>();
    displayManager = context.read<DisplayManager>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      displayManager.setHideNavigationBar(true);
      _fetchArtistData();
    });
  }

  @override
  void dispose() {
    // If there is a notification showing when the user leaves the page, remove it
    _notificationManager.hideNotificationBar();

    // Toggle hideNavigationBar and remove notification after widget tree is unlocked
    WidgetsBinding.instance.addPostFrameCallback((_) {
      displayManager.setHideNavigationBar(false);
    });
    super.dispose();
  }

  // Fetch artist data from API
  void _fetchArtistData() async {
    dynamic data;
    final startTime = DateTime.now();

    try {
      data = await apiService.getArtistData(
        // For Homepage
        passedArtist: widget.passedArtist,
        // For SearchPage; passed from both Homepage and SearchPage, but not used for Homepage
        artistName: widget.artistName,
        includeSpotifyInfo: widget.apiIncludeSpotifyInfo,
      );
      // Use mounted to prevent error caused by quickly leaving the page after API call
      if (mounted) {
        // If data is a Map and is empty, means no data returned from API
        if (data is Map && data.isEmpty) {
          await _waitForMinimumTime(startTime);

          setState(() {
            isNoData = true;
            isLoading = false;
          });
        } else {
          await _waitForMinimumTime(startTime);

          setState(() {
            if (widget.apiIncludeSpotifyInfo) {
              // If need Spotify info, set Artist as data type
              apiArtistData = data as Artist;
            } else {
              // If need artist bio only, set ArtistBio as data type
              apiArtistData = data as ArtistBio;
            }
            // Set loading to false if API call is successful
            isLoading = false;

            if (apiArtistData is Artist &&
                apiArtistData.bio.hasRetriedWithEnglish) {
              // Show notification bar
              _showNotification();
            } else if (apiArtistData is ArtistBio &&
                apiArtistData.hasRetriedWithEnglish) {
              // Show notification bar
              _showNotification();
            }
          });
        }
      }
    } catch (e) {
      await _waitForMinimumTime(startTime);

      log('$e');
      // Set loading to false and error to true if API call fails
      if (mounted) {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    }
  }

  void _showNotification() {
    _notificationManager.showNotification(
      context: context,
      message:
          "Artist not found in Chinese Wikipedia\nRetrieved data from English Wikipedia",
      duration: 8,
      isSlideHorizontal: false,
    );
  }

  // Wait for 1.5 seconds before showing no data to prevent flickering
  Future<void> _waitForMinimumTime(DateTime startTime) async {
    const minDuration = Duration(milliseconds: 1500);
    final elapsedTime = DateTime.now().difference(startTime);

    // Wait for the remaining time
    if (elapsedTime < minDuration) {
      await Future.delayed(minDuration - elapsedTime);
    }
  }

  void _onRetry() {
    // Reset loading and error
    setState(() {
      isLoading = true;
      isError = false;
    });

    _fetchArtistData();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double topSafeArea = MediaQuery.of(context).padding.top;

    if (isLoading) {
      return LoadingArtistBioPage(
        artist: widget.passedArtist,
        category: widget.category ?? "",
      );
    } else if (isError || isNoData) {
      return ErrorArtistBioPage(
        onRetry: _onRetry,
        isNoData: isNoData,
        artistName: widget.artistName,
      );
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Artist image on the top
          ArtistBioImage(
            imageUrl: widget.apiIncludeSpotifyInfo
                ? apiArtistData.image ?? ""
                : widget.passedArtist?.image ?? "",
          ),

          // Make sure sheet cover the exit button
          const ExitButton(),

          // Sheet for artist bio
          DraggableScrollableSheet(
            initialChildSize: (screenHeight - 355) / screenHeight,
            minChildSize: (screenHeight - 380) / screenHeight,
            // Subtract top safe area from max size
            maxChildSize: 1.0 - (topSafeArea / screenHeight),
            builder: (BuildContext context, ScrollController sheetController) {
              return Stack(
                children: [
                  // Sheet style
                  Container(
                    width: double.infinity,
                    // Clip ListView to prevent overflow
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, -10),
                          blurRadius: 10,
                        ),
                      ],
                    ),

                    // Sheet content
                    child: ListView(
                      controller: _listViewController,
                      padding: EdgeInsets.zero,
                      children: [
                        // Reserve space for drag indicator
                        const SizedBox(height: 30),

                        // Artist name and active country flag
                        ArtistBioHeader(
                          artistName: widget.apiIncludeSpotifyInfo
                              ? apiArtistData.name
                              : widget.passedArtist?.name ?? "",
                          countryCode:
                              // If Spotify info included from API: use Artist.bio
                              // If not: use ArtistBio
                              widget.apiIncludeSpotifyInfo
                                  ? apiArtistData.bio?.countryCode ?? ""
                                  : apiArtistData?.countryCode ?? "",
                          activeCountry: widget.apiIncludeSpotifyInfo
                              ? apiArtistData.bio?.activeCountry ?? ""
                              : apiArtistData?.activeCountry ?? "",
                        ),

                        const SizedBox(height: 10),

                        // Stats row
                        StatRow(
                            artistData: widget.apiIncludeSpotifyInfo
                                ? apiArtistData
                                : widget.passedArtist!),
                        const SizedBox(height: 20),

                        // Birth info
                        BirthInfoRow(
                          birthday: widget.apiIncludeSpotifyInfo
                              ? apiArtistData.bio?.birthday
                              : apiArtistData?.birthday,
                          birthPlace: widget.apiIncludeSpotifyInfo
                              ? apiArtistData.bio?.birthPlace
                              : apiArtistData?.birthPlace,
                        ),
                        const SizedBox(height: 13.5),

                        // Bio
                        BioText(
                          bio: widget.apiIncludeSpotifyInfo
                              ? apiArtistData.bio?.description
                              : apiArtistData?.description,
                        ),

                        const SizedBox(height: 10),

                        // Disclaimer
                        const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                                size: 15,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Data may be inaccurate. Check important info.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // External links
                        ExternalLinksSection(
                          apiArtistData: apiArtistData,
                          apiIncludeSpotifyInfo: widget.apiIncludeSpotifyInfo,
                          // If Spotify info included from API: use Artist.spotifyUrl
                          // If not, use spotifyUrl from passed Artist object
                          spotifyUrl: widget.apiIncludeSpotifyInfo
                              ? apiArtistData.spotifyUrl
                              : widget.passedArtist?.spotifyUrl,
                        ),

                        const SizedBox(height: 10),

                        // Problem button to inform user about the data source
                        const ProblemButton(),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),

                  // Drag indicator on the top of the sheet
                  DragIndicator(
                    sheetController: sheetController,
                    listViewController: _listViewController,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
