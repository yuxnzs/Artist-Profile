import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/utility/custom_colors.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final double width;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: AppConstants.searchPageMargin,
        right: AppConstants.searchPageMargin,
      ),
      child: TextField(
        controller: controller,
        cursorColor: Colors.grey[600],
        cursorHeight: 18,
        decoration: InputDecoration(
          hintText: 'Search Artist',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          // Background color
          filled: true,
          fillColor: CustomColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(0),
          // Search icon
          prefixIcon: const Icon(Icons.search),
          // Clear text button
          suffixIcon: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            // Show the button if there is text in text field
            opacity: controller.text.isNotEmpty ? 1.0 : 0.0,
            child: IconButton(
              icon: const Icon(
                Icons.cancel,
                size: 23,
                color: Colors.grey,
              ),
              style: TextButton.styleFrom(
                // Turn off on long press effect
                overlayColor: Colors.transparent,
              ),
              onPressed: () {
                controller.clear();
              },
            ),
          ),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
