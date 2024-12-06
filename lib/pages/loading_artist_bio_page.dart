import 'dart:async';
import 'package:flutter/material.dart';
import 'package:artist_profile/models/artist.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/artist_bio_page/artist_image_placeholder.dart';
import 'package:artist_profile/components/artist_bio_page/drag_indicator.dart';
import 'package:artist_profile/components/common/placeholder_block.dart';
import 'package:artist_profile/components/artist_bio_page/birth_info_row.dart';
import 'package:artist_profile/components/common/exit_button.dart';
import 'package:artist_profile/components/artist_bio_page/artist_bio_image.dart';
import 'package:artist_profile/managers/notification_manager.dart';

class LoadingArtistBioPage extends StatefulWidget {
  final Artist? artist;
  // For Hero() tag parameter
  final String? category;

  const LoadingArtistBioPage({super.key, this.artist, required this.category});

  @override
  State<LoadingArtistBioPage> createState() => _LoadingArtistBioPageState();
}

class _LoadingArtistBioPageState extends State<LoadingArtistBioPage> {
  final NotificationManager _notificationManager = NotificationManager();

  bool _isSheetVisible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Make sure the page is rendered before updating isSheetVisible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isSheetVisible = true;
      });
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      _showNotification();
    });
  }

  void _showNotification() {
    _notificationManager.showNotification(
      context: context,
      message:
          "We're preparing your artist's information.\nJust a few more seconds...",
      duration: 10,
      isSlideHorizontal: false,
    );
  }

  @override
  void dispose() {
    _notificationManager.hideNotificationBar();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Artist image on the top
            widget.artist == null
                ? const ArtistImagePlaceholder(
                    imageWidth: double.infinity,
                    imageHeight: 380,
                    isCircular: false,
                  )
                // For Homepage to ArtistBioPage animation
                : Hero(
                    tag: "${widget.artist!.name}-${widget.category}",
                    child: ArtistBioImage(
                      imageUrl: widget.artist!.image ?? "",
                    ),
                  ),

            // Sheet for artist bio
            // Sheet animation to avoid image on top of the sheet at the beginning
            AnimatedPositioned(
              duration: const Duration(milliseconds: 550),
              curve: Curves.easeInOut,
              // Screen size for bottom of the screen
              top: _isSheetVisible ? 355 : MediaQuery.of(context).size.height,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  // Sheet background
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
                    // Content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reserve space for drag indicator
                        const SizedBox(height: 40),

                        // Artist name and active country flag
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.artistBioPageMargin,
                          ),
                          child: Row(
                            children: [
                              PlaceholderBlock(
                                width: 180,
                                height: 30,
                                borderRadius: 10,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Stats row
                        const Row(
                          children: [
                            PlaceholderBlock(
                              width: 70,
                              height: 30,
                              borderRadius: 10,
                              leftMargin: AppConstants.artistBioPageMargin,
                            ),
                            PlaceholderBlock(
                              width: 70,
                              height: 30,
                              borderRadius: 10,
                              leftMargin: AppConstants.artistBioPageMargin,
                            ),
                            PlaceholderBlock(
                              width: 70,
                              height: 30,
                              borderRadius: 10,
                              leftMargin: AppConstants.artistBioPageMargin,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Birth info
                        const BirthInfoRow(
                          birthday: null,
                          birthPlace: null,
                          isPlaceholder: true,
                        ),
                        const SizedBox(height: 20),

                        // Bio
                        PlaceholderBlock(
                          width: screenWidth,
                          height: 20,
                          borderRadius: 5,
                          topMargin: 5,
                          leftMargin: AppConstants.artistBioPageMargin,
                          rightMargin: AppConstants.artistBioPageMargin,
                        ),
                        const SizedBox(height: 10),

                        PlaceholderBlock(
                          width: screenWidth - 100,
                          height: 20,
                          borderRadius: 5,
                          leftMargin: AppConstants.artistBioPageMargin,
                          rightMargin: AppConstants.artistBioPageMargin,
                        ),
                        const SizedBox(height: 10),
                        PlaceholderBlock(
                          width: screenWidth - 100,
                          height: 20,
                          borderRadius: 5,
                          leftMargin: AppConstants.artistBioPageMargin,
                          rightMargin: AppConstants.artistBioPageMargin,
                        ),
                        const SizedBox(height: 10),

                        PlaceholderBlock(
                          width: screenWidth - 150,
                          height: 20,
                          borderRadius: 5,
                          leftMargin: AppConstants.artistBioPageMargin,
                          rightMargin: AppConstants.artistBioPageMargin,
                        ),
                        const SizedBox(height: 10),
                        PlaceholderBlock(
                          width: screenWidth - 200,
                          height: 20,
                          borderRadius: 5,
                          leftMargin: AppConstants.artistBioPageMargin,
                          rightMargin: AppConstants.artistBioPageMargin,
                        ),
                      ],
                    ),
                  ),

                  // Drag indicator on the top of the sheet
                  const DragIndicator(scrollController: null),
                ],
              ),
            ),

            const ExitButton(),
          ],
        ),
      ),
    );
  }
}
