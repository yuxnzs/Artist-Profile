import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:artist_profile/models/artist.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/artist_bio_page/stat_tag.dart';

class StatRow extends StatelessWidget {
  final Artist artistData;

  const StatRow({super.key, required this.artistData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: AppConstants.artistBioPageMargin),
          StatTag(
            type: 'Spotify popularity',
            label: (artistData.popularity % 1 == 0)
                // Remove decimal point if it's an integer
                ? artistData.popularity.toInt().toString()
                // Keep the decimal point if it's not an integer
                : artistData.popularity.toString(),
            icon: Icons.star,
          ),
          const SizedBox(width: 10),
          StatTag(
            type: 'Spotify followers',
            label: NumberFormat('#,###').format(artistData.followers),
            icon: Icons.people,
          ),
          const SizedBox(width: 10),
          if (artistData.genres.isNotEmpty) ...[
            StatTag(
              type: 'Genres',
              // Display first five genres
              label: artistData.genres
                  .take(5)
                  .map((genre) => genre.toUpperCase())
                  .join(', '),
              icon: Icons.music_note,
            ),
            const SizedBox(width: AppConstants.artistBioPageMargin)
          ]
        ],
      ),
    );
  }
}
