import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/utility/custom_colors.dart';

class LoadingError extends StatelessWidget {
  final Function() onRetry;
  final bool isNoData;
  final String artistName;
  final bool displayBackground;

  const LoadingError({
    super.key,
    required this.onRetry,
    this.isNoData = false,
    this.artistName = "",
    this.displayBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225, // Approximate height of SectionPlaceholder
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.globalMargin),
      decoration: BoxDecoration(
        color: displayBackground ? CustomColors.background : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                height: 1.8,
                color: Colors.black, // Color of the whole text
              ),
              children: [
                TextSpan(
                  text: isNoData
                      ? "No data found for "
                      : "Failed to load data. Please try again.",
                ),
                if (isNoData)
                  TextSpan(
                    text: artistName,
                    style: const TextStyle(
                      color: Colors.red, // Color of $artistName
                    ),
                  ),
                if (isNoData)
                  const TextSpan(
                    text: "\nPlease try searching for another artist",
                  ),
              ],
            ),
          ),
          SizedBox(height: !isNoData ? 10 : 3),
          if (!isNoData)
            // Retry button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              onPressed: onRetry,
              child: const Text("Retry"),
            )
          else
            // Back button
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                // Turn off on long press effect
                overlayColor: Colors.transparent,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Back"),
            )
        ],
      ),
    );
  }
}
