import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/managers/display_manager.dart';
import 'package:artist_profile/components/genre_row.dart';
import 'package:artist_profile/components/artist_content.dart';

class GenreSection extends StatefulWidget {
  const GenreSection({super.key});

  @override
  State<GenreSection> createState() => _GenreSectionState();
}

class _GenreSectionState extends State<GenreSection> {
  String selectedGenre = "POP"; // Display POP by default

  // Set selected genre, and render corresponding artists
  void onGenreSelected(String genre) {
    setState(() {
      selectedGenre = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenreRow(
          onGenreSelected: onGenreSelected,
          selectedGenre: selectedGenre,
        ),
        const SizedBox(height: 15),
        ArtistContent(
          selectedGenre: selectedGenre,
          apiFunction: () => context.read<APIService>().getRecommendations(),
          isLoading: context.watch<DisplayManager>().isRecommendationsLoading,
          toggleLoading: () => context
              .read<DisplayManager>()
              .toggleLoading(category: 'recommendations'),
          isError: context.watch<DisplayManager>().isRecommendationsError,
          toggleError: () => context
              .read<DisplayManager>()
              .toggleError(category: 'recommendations'),
        ),
      ],
    );
  }
}
