import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:artist_profile/models/artist.dart';
import 'package:artist_profile/utility/custom_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:artist_profile/components/artist_image_placeholder.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;

  const ArtistCard({super.key, required this.artist});

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
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: artist.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ArtistImagePlaceholder(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 10),

          // Artist Name
          Text(
            artist.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
                NumberFormat.compact().format(artist.followers),
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
    );
  }
}
