import 'package:flutter/material.dart';
import 'package:artist_profile/components/heading_text.dart';
import 'package:artist_profile/components/homepage_banner.dart';
import 'package:artist_profile/components/genre_section.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
                    HeadingText(text: "Artists Profile", fontSize: 25),
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

              // Recommended Genres Section
              // No margin, separate from the container above
              const GenreSection(),
            ],
          ),
        ),
      ),
    );
  }
}
