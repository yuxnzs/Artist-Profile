import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/custom_country_flag.dart';

class ArtistBioHeader extends StatelessWidget {
  final String artistName;
  final String countryCode;
  final String activeCountry;
  const ArtistBioHeader({
    super.key,
    required this.artistName,
    required this.countryCode,
    required this.activeCountry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.artistBioPageMargin),
      child: Row(
        children: [
          Text(
            artistName,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 13),
          CustomCountryFlag(
            countryCode: countryCode,
            activeCountry: activeCountry,
          ),
        ],
      ),
    );
  }
}
