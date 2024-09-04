import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/services/api_service.dart';
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
        ),
      ],
    );
  }
}
