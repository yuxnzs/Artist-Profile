import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:artist_profile/components/artist_image_placeholder.dart';

class ArtistBioImage extends StatelessWidget {
  final String imageUrl;

  const ArtistBioImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: double.infinity,
      height: 380,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          const ArtistImagePlaceholder(isCircular: false),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
