import 'package:flutter/material.dart';
import 'package:artist_profile/models/artist.dart';
import 'package:artist_profile/components/artist_card.dart';

class ArtistRow extends StatelessWidget {
  final List<Artist> artists;

  const ArtistRow({
    super.key,
    required this.artists,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length + 1, // +1 for initial spacing
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox(width: 20); // Initial spacing,
          }
          final artist = artists[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 25),
            child: ArtistCard(artist: artist),
          );
        },
      ),
    );
  }
}
