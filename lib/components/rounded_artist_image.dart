import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:artist_profile/components/artist_image_placeholder.dart';

class RoundedArtistImage extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;

  const RoundedArtistImage({
    super.key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => const ArtistImagePlaceholder(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
