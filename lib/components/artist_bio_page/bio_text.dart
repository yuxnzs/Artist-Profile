import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/managers/wiki_language_manager.dart';
import 'package:artist_profile/utility/app_constants.dart';

class BioText extends StatelessWidget {
  final String? bio;

  const BioText({super.key, this.bio});

  @override
  Widget build(BuildContext context) {
    final wikiLanguageManager = context.read<WikiLanguageManager>();

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.artistBioPageMargin),
      child: Text(
        bio ??
            "No relevant bio found in ${wikiLanguageManager.wikiLanguage == "en" ? "English" : "中文"} Wikipedia",
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
