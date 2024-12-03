import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:artist_profile/components/common/apple_dialog.dart';

class LinkButton extends StatelessWidget {
  final String url;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool isSpotify;

  const LinkButton({
    super.key,
    required this.url,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.isSpotify = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String platform = text.split(' ').last;
        try {
          if (isSpotify) {
            final spotifyUri =
                url.replaceAll('https://open.spotify.com/', 'spotify://');
            // If the user doesn't have Spotify installed, open the web link
            if (!await launchUrl(Uri.parse(spotifyUri))) {
              launchUrl(Uri.parse(url));
            }
          } else {
            await launchUrl(Uri.parse(url));
          }
        } catch (e) {
          // Check if the context is still mounted for this async function
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AppleDialog(
                  title: "Error",
                  content: "Failed to open $platform link\n Please try again",
                );
              },
            );
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Icon(
              Icons.open_in_new,
              size: 20,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
