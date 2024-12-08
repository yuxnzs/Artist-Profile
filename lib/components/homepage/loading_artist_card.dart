import 'package:flutter/material.dart';
import 'package:artist_profile/utility/custom_colors.dart';
import 'package:artist_profile/components/common/loading_placeholder.dart';
import 'package:artist_profile/components/artist_bio_page/artist_image_placeholder.dart';

class LoadingArtistCard extends StatelessWidget {
  const LoadingArtistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const ArtistImagePlaceholder(),
          const SizedBox(height: 11),

          // Artist Name
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const SizedBox(
              width: 85,
              height: 18,
              child: LoadingPlaceholder(),
            ),
          ),
          const SizedBox(height: 9),

          // Followers
          Transform.translate(
            offset: const Offset(0, -1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.people,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: const SizedBox(
                    width: 40,
                    height: 12,
                    child: LoadingPlaceholder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
