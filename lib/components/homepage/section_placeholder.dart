import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/homepage/loading_artist_card.dart';
import 'package:artist_profile/components/common/placeholder_block.dart';

class SectionPlaceholder extends StatelessWidget {
  const SectionPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Placeholder for the section title
        PlaceholderBlock(
          width: 250,
          height: 25,
          borderRadius: 5,
          leftMargin: AppConstants.globalMargin,
        ),
        SizedBox(height: 19),
        // Placeholder for the artist cards
        Row(
          // Simulate the layout of an artist_row
          children: [
            SizedBox(width: AppConstants.globalMargin),
            LoadingArtistCard(),
            SizedBox(width: 25),
            LoadingArtistCard(),
          ],
        ),
      ],
    );
  }
}
