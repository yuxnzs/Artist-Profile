import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/managers/display_manager.dart';
import 'package:artist_profile/utility/app_constants.dart';

class BioText extends StatelessWidget {
  final String? bio;

  const BioText({super.key, this.bio});

  @override
  Widget build(BuildContext context) {
    final displayManager = context.read<DisplayManager>();

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.artistBioPageMargin),
      child: Text(
        bio ??
            "No relevant bio found in ${displayManager.wikiLanguage == "en" ? "English" : "中文"} Wikipedia",
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
