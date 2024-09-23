import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/artist_image_placeholder.dart';
import 'package:artist_profile/components/drag_indicator.dart';
import 'package:artist_profile/components/placeholder_block.dart';
import 'package:artist_profile/components/birth_info_row.dart';
import 'package:artist_profile/components/exit_button.dart';

class LoadingArtistBioPage extends StatelessWidget {
  const LoadingArtistBioPage({super.key});

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
            const ArtistImagePlaceholder(
              imageWidth: double.infinity,
              imageHeight: 380,
              isCircular: false,
            ),

            // Sheet for artist bio
            Positioned(
              top: 355,
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
