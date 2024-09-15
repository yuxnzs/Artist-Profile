import 'package:flutter/material.dart';
import 'package:artist_profile/utility/custom_colors.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/artist_image.dart';

class HomepageBanner extends StatelessWidget {
  const HomepageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.globalMargin),
      decoration: BoxDecoration(
        color: CustomColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  "Find your favorite artist",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),

                // Subtitle
                const Text(
                  "Explore the world of artists",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),

                // Explore button
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(80, 35),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Explore"),
                ),
              ],
            ),
            const SizedBox(width: 10),

            // Artist Image
            const ArtistImage(
                imageUrl:
                    "https://i.scdn.co/image/ab67616100005174859e4c14fa59296c8649e0e4"),
          ],
        ),
      ),
    );
  }
}
