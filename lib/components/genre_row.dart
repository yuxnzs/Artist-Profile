import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/genre_tag.dart';
import 'package:artist_profile/models/genres.dart';

class GenreRow extends StatelessWidget {
  // Pass to genre tag component to handle onTap
  final Function(String) onGenreSelected;
  final String selectedGenre;

  const GenreRow({
    super.key,
    required this.onGenreSelected,
    required this.selectedGenre,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          const SizedBox(width: AppConstants.globalMargin), // Visual spacing
          ...genres.map((genre) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GenreTag(
                genre: genre,
                onTap: () => onGenreSelected(genre),
                // If the genre matches the selected genre, highlight it
                isSelected: genre == selectedGenre,
              ),
            );
          }),
        ],
      ),
    );
  }
}
