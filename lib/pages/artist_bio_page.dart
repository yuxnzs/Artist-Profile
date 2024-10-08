import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:artist_profile/managers/display_manager.dart';
import 'package:artist_profile/models/artist.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/components/artist_image_placeholder.dart';
import 'package:artist_profile/components/drag_indicator.dart';
import 'package:artist_profile/components/artist_bio_header.dart';
import 'package:artist_profile/components/stat_row.dart';
import 'package:artist_profile/components/birth_info_row.dart';
import 'package:artist_profile/components/bio_text.dart';
import 'package:artist_profile/components/loading_artist_bio_page.dart';
import 'package:artist_profile/components/external_links_section.dart';
import 'package:artist_profile/components/exit_button.dart';
import 'package:artist_profile/components/problem_button.dart';
import 'package:artist_profile/components/error_artist_bio_page.dart';

class ArtistBioPage extends StatefulWidget {
  final String artistName;
  final bool apiIncludeSpotifyInfo;
  // Pass from homepage's ArtistCard
  final Artist? passedArtist;

  const ArtistBioPage({
    super.key,
    required this.artistName,
    required this.apiIncludeSpotifyInfo,
    this.passedArtist,
  });

  @override
  State<ArtistBioPage> createState() => _ArtistBioPageState();
}

class _ArtistBioPageState extends State<ArtistBioPage> {
  late APIService apiService;
  late DisplayManager displayManager;
  late dynamic apiArtistData; // Type will be Artist, ArtistBio, or null
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    apiService = context.read<APIService>();
    displayManager = context.read<DisplayManager>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchArtistData();
    });
  }

  // Fetch artist data from API
  void _fetchArtistData() async {
    dynamic data;
    try {
      data = await apiService.getArtistData(
        artistName: widget.artistName,
        includeSpotifyInfo: widget.apiIncludeSpotifyInfo,
      );
      // Prevent error caused by quickly leaving the page after API call
      if (mounted) {
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
        });
      }
    } catch (e) {
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
      return const LoadingArtistBioPage();
    } else if (isError) {
      return ErrorArtistBioPage(onRetry: _onRetry);
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Artist image on the top
          CachedNetworkImage(
            width: double.infinity,
            height: 380,
            imageUrl: widget.apiIncludeSpotifyInfo
                ? apiArtistData.image ?? ""
                : widget.passedArtist?.image ?? "",
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const ArtistImagePlaceholder(isCircular: false),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // Make sure sheet cover the exit button
          const ExitButton(),

          // Sheet for artist bio
          DraggableScrollableSheet(
            initialChildSize: (screenHeight - 355) / screenHeight,
            minChildSize: (screenHeight - 380) / screenHeight,
            // Subtract top safe area from max size
            maxChildSize: 1.0 - (topSafeArea / screenHeight),
            builder: (BuildContext context, ScrollController scrollController) {
              return Stack(
                children: [
                  // Sheet style
                  Container(
                    width: double.infinity,
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
                        const SizedBox(height: 20),

                        // Bio
                        BioText(
                          bio: widget.apiIncludeSpotifyInfo
                              ? apiArtistData.bio?.description
                              : apiArtistData?.description,
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
                  DragIndicator(scrollController: scrollController),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
