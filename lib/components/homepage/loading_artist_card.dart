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
          const SizedBox(height: 10),

          // Artist Name
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: const SizedBox(
              width: 80,
              height: 16,
              child: LoadingPlaceholder(),
            ),
          ),
          const SizedBox(height: 9),

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
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: const SizedBox(
                  width: 39,
                  height: 12,
                  child: LoadingPlaceholder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
