import 'package:flutter/material.dart';
import 'package:artist_profile/components/heading_text.dart';
import 'package:artist_profile/components/homepage_banner.dart';
import 'package:artist_profile/components/genre_row.dart';
import 'package:artist_profile/models/artist.dart';
import 'package:artist_profile/components/artist_row.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Display POP by default
  String selectedGenre = "POP";

  // Set selected genre, and render corresponding artists
  void onGenreSelected(String genre) {
    setState(() {
      selectedGenre = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: const Column(
                  children: [
                    // Header Text
                    HeadingText(text: "Artists Profile"),
                    SizedBox(height: 15),

                    // Banner
                    HomepageBanner(),
                    SizedBox(height: 15),

                    // Genres Section
                    HeadingText(text: "Recommended Genres"),
                    SizedBox(height: 15),
                  ],
                ),
              ),

              // No margin, separate from the container above
              Column(
                children: [
                  GenreRow(
                    onGenreSelected: onGenreSelected,
                    selectedGenre: selectedGenre,
                  ),
                  const SizedBox(height: 15),

                  // Display artists based on selected genre
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ArtistRow(
                      key: ValueKey<String>(
                          selectedGenre), // Unique key for animation switcher to work
                      artists: artistsList
                          .where((artist) => artist.genres
                              // Check if the selected genre is in the artist's genres list
                              .any((genre) =>
                                  genre == selectedGenre.toLowerCase()))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
