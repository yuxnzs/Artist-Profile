import 'package:flutter/material.dart';
import 'package:artist_profile/components/loading_placeholder.dart';

class ArtistImagePlaceholder extends StatelessWidget {
  const ArtistImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClipOval(
      child: SizedBox(
        width: 100,
        height: 100,
        child: LoadingPlaceholder(),
      ),
    );
  }
}
