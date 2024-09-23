import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/link_button.dart';

class ExternalLinksSection extends StatelessWidget {
  final dynamic apiArtistData;
  final bool apiIncludeSpotifyInfo;
  // Spotify URL is included in Artist object, not in ArtistBio object
  final String spotifyUrl;

  const ExternalLinksSection({
    super.key,
    required this.apiArtistData,
    required this.apiIncludeSpotifyInfo,
    required this.spotifyUrl,
  });

  @override
  Widget build(BuildContext context) {
    // If apiIncludeSpotifyInfo use Artist object, otherwise use ArtistBio object
    dynamic artistData =
        apiIncludeSpotifyInfo ? apiArtistData.bio : apiArtistData;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.artistBioPageMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'External links',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          LinkButton(
            url: spotifyUrl,
            text: 'Open in Spotify',
            backgroundColor: Colors.green[500]!,
            textColor: Colors.green,
            isSpotify: true,
          ),
          const SizedBox(height: 10),
          if (artistData.musicBrainzUrl != null) ...[
            LinkButton(
              url: artistData.musicBrainzUrl ?? "",
              text: 'Open in MusicBrainz',
              backgroundColor: Colors.blue[500]!,
              textColor: Colors.blue,
            ),
            const SizedBox(height: 10),
          ],
          if (artistData.wikiUrl != null)
            LinkButton(
              url: artistData.wikiUrl ?? "",
              text: 'Open in Wikipedia',
              backgroundColor: Colors.grey[500]!,
              textColor: Colors.grey[800]!,
            )
        ],
      ),
    );
  }
}
