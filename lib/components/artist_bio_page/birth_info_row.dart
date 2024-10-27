import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';
import 'package:artist_profile/components/artist_bio_page/birth_info_block.dart';

class BirthInfoRow extends StatelessWidget {
  final String? birthday;
  final String? birthPlace;
  final bool isPlaceholder;

  const BirthInfoRow({
    super.key,
    required this.birthday,
    required this.birthPlace,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.artistBioPageMargin,
        right: AppConstants.artistBioPageMargin,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BirthInfoBlock(
            icon: Icons.calendar_month,
            title: "Birthday",
            content: birthday,
            isPlaceholder: isPlaceholder,
          ),
          BirthInfoBlock(
            icon: Icons.location_pin,
            title: "Birth Place",
            content: birthPlace,
            isPlaceholder: isPlaceholder,
          ),
        ],
      ),
    );
  }
}
