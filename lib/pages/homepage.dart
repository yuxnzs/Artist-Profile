import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/components/heading_text.dart';
import 'package:artist_profile/components/homepage_banner.dart';
import 'package:artist_profile/components/genre_section.dart';
import 'package:artist_profile/components/artist_content.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Header Text
              const SizedBox(height: 20),
              const HeadingText(text: "Artists Profile", fontSize: 25),
              const SizedBox(height: 15),

              // Banner
              const HomepageBanner(),
              const SizedBox(height: 30),

              // Global Top Artists Section
              const HeadingText(text: "Global Top Artists Today"),
              const SizedBox(height: 15),
              ArtistContent(
                artists: apiService.globalTopArtists,
                apiFunction: apiService.getGlobalTopArtists,
              ),
              const SizedBox(height: 30),

              // USA Top Artists Section
              const HeadingText(text: "USA Top Artists Today"),
              const SizedBox(height: 15),
              ArtistContent(
                artists: apiService.usTopArtists,
                apiFunction: apiService.getUSTopArtists,
              ),
              const SizedBox(height: 30),

              // Recommended Genres Section
              const HeadingText(text: "Recommended Genres"),
              const SizedBox(height: 15),
              const GenreSection(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
