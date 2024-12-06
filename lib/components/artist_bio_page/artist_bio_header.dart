import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/artist_bio_page/custom_country_flag.dart';

class ArtistBioHeader extends StatelessWidget {
  final String artistName;
  final String countryCode;
  final String activeCountry;

  late final String artistNameLastWord;
  late final String artistNameWithoutLastWord;

  ArtistBioHeader({
    super.key,
    required this.artistName,
    required this.countryCode,
    required this.activeCountry,
  }) {
    // Make sure last word is with the flag
    artistNameLastWord = artistName.trim().split(' ').last;
    artistNameWithoutLastWord = artistName.substring(
      0,
      artistName.trim().length - artistNameLastWord.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 1,
        left: AppConstants.artistBioPageMargin,
        right: AppConstants.artistBioPageMargin,
      ),
      width: screenWidth,
      child: RichText(
        text: TextSpan(
          children: [
            // Artist name without the last word
            TextSpan(
              text: artistNameWithoutLastWord,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
                color: Colors.black,
              ),
            ),
            WidgetSpan(
              // Align flag with text baseline for vertical alignment
              alignment: PlaceholderAlignment.baseline,
              // Use alphabetic baseline to match the vertical alignment of Latin text
              baseline: TextBaseline.alphabetic,
              // Use Wrap to prevent one-word artist names from overflowing
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Last word with the flag
                  Text(
                    artistNameLastWord,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 13), // Spacing between flag and text
                    child: CustomCountryFlag(
                      countryCode: countryCode,
                      activeCountry: activeCountry,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        softWrap: true,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
