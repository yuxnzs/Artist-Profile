import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart'
    as intl; // Avoid conflict with Flutter's TextDirection
import 'package:artist_profile/models/artist.dart';
import 'package:artist_profile/utility/custom_colors.dart';
import 'package:artist_profile/components/homepage/rounded_artist_image.dart';
import 'package:artist_profile/pages/artist_bio_page.dart';

class ArtistCard extends StatefulWidget {
  final Artist artist;
  // For Hero() tag parameter
  final String category;

  const ArtistCard({
    super.key,
    required this.artist,
    required this.category,
  });

  @override
  State<ArtistCard> createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  bool isTextTooLong = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextWidth();
    });
  }

  void _checkTextWidth() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.artist.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: 140); // 160 width - 20 padding
    if (textPainter.didExceedMaxLines) {
      setState(() {
        isTextTooLong = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ArtistBioPage(
              artistName: widget.artist.name,
              apiIncludeSpotifyInfo: false,
              passedArtist: widget.artist,
              category: widget.category,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        height: 180,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: CustomColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Artist Image
            Hero(
              tag: "${widget.artist.name}-${widget.category}",
              child: RoundedArtistImage(imageUrl: widget.artist.image ?? ""),
            ),
            const SizedBox(height: 10),

            // Artist Name
            // ClipRRect hides overflowed text
            ClipRRect(
              // Use Stack to create a gradient effect on the long artist name
              child: Stack(
                children: [
                  Text(
                    widget.artist.name,
                    maxLines: 1,
                    softWrap: false, // To prevent text from going to next line
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isTextTooLong)
                    // Gradient effect on the long artist name
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                CustomColors.background.withOpacity(0.1),
                                CustomColors.background,
                              ],
                              stops: const [0.5, 0.9],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 3),

            // Followers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.people,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 3),
                Text(
                  intl.NumberFormat.compact().format(widget.artist.followers),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
