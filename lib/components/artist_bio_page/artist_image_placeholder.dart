import 'package:flutter/material.dart';
import 'package:artist_profile/components/common/loading_placeholder.dart';

class ArtistImagePlaceholder extends StatelessWidget {
  final bool isCircular;
  final double imageWidth;
  final double imageHeight;

  const ArtistImagePlaceholder({
    super.key,
    this.isCircular = true,
    this.imageWidth = 100,
    this.imageHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    Widget placeholder = SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: const LoadingPlaceholder(),
    );

    return isCircular ? ClipOval(child: placeholder) : placeholder;
  }
}
