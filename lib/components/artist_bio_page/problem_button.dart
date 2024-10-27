import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:artist_profile/components/common/apple_dialog.dart';
import 'package:artist_profile/utility/app_constants.dart';

class ProblemButton extends StatelessWidget {
  const ProblemButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.artistBioPageMargin),
      child: TextButton(
        onPressed: () {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return const AppleDialog(
                title: "About the Artist Information",
                content:
                    "The birth details, active country, and bio are sourced from Wikipedia and the MusicBrainz database based on the artist's name. The information may not be entirely accurate.",
              );
            },
          );
        },
        style: TextButton.styleFrom(
          overlayColor: Colors.red.withOpacity(0.1), // Color on tap
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Problem with this information?',
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
