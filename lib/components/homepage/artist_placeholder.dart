import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/homepage/loading_artist_card.dart';

class ArtistPlaceholder extends StatelessWidget {
  const ArtistPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      // Simulate the layout of an artist_row
      children: [
        SizedBox(width: AppConstants.globalMargin),
        LoadingArtistCard(),
        SizedBox(width: 25),
        LoadingArtistCard(),
      ],
    );
  }
}
