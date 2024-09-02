import 'package:flutter/material.dart';
import 'package:artist_profile/utility/custom_colors.dart';

class HomepageBanner extends StatelessWidget {
  const HomepageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: CustomColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
            ClipOval(
              child: Image.network(
                "https://i.scdn.co/image/ab67616100005174859e4c14fa59296c8649e0e4",
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
