import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';

class BioText extends StatelessWidget {
  final String? bio;

  const BioText({super.key, this.bio});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.artistBioPageMargin),
      child: Text(
        bio ?? "No bio available",
        style: TextStyle(
          height: 1.8,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
