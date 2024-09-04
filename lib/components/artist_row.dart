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
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          const SizedBox(width: 20), // Visual spacing
          ...artists.map((artist) {
            return Padding(
              padding: const EdgeInsets.only(right: 25),
              child: ArtistCard(artist: artist),
            );
          }),
        ],
      ),
    );
  }
}
