import 'package:flutter/material.dart';
import 'package:artist_profile/components/loading_placeholder.dart';

class PlaceholderBlock extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double topMargin;
  final double bottomMargin;
  final double leftMargin;
  final double rightMargin;

  const PlaceholderBlock({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
    this.topMargin = 0,
    this.bottomMargin = 0,
    this.leftMargin = 0,
    this.rightMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: topMargin,
        bottom: bottomMargin,
        left: leftMargin,
        right: rightMargin,
      ),
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: const LoadingPlaceholder(),
      ),
    );
  }
}
