import 'package:flutter/material.dart';
import 'package:artist_profile/utility/custom_colors.dart';

class GenreTag extends StatelessWidget {
  final String genre;
  final VoidCallback onTap;
  final bool isSelected; // To highlight the selected genre

  const GenreTag({
    super.key,
    required this.genre,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // onTap border radius
      borderRadius: BorderRadius.circular(10),
      // Set animation when switching between genre tags
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        padding: const EdgeInsets.all(10),
        height: 20,
        decoration: BoxDecoration(
          color: isSelected
              ? CustomColors.background.withOpacity(0.4)
              : CustomColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          genre,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
