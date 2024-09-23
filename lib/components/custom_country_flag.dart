import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:artist_profile/components/apple_dialog.dart';
import 'package:country_flags/country_flags.dart';

class CustomCountryFlag extends StatelessWidget {
  final String? countryCode;
  final String? activeCountry;

  const CustomCountryFlag({
    super.key,
    required this.countryCode,
    required this.activeCountry,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Diaolog to show active country name
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return AppleDialog(
              title: 'Active Country',
              content: activeCountry ?? '',
            );
          },
        );
      },
      child:
          countryCode != null && countryCode!.isNotEmpty && countryCode != 'XW'
              ? Container(
                  decoration: BoxDecoration(
                    // Very slight shadow
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        // offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  height: 20,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: CountryFlag.fromCountryCode(
                      countryCode!,
                      shape: const RoundedRectangle(5),
                      // Size with correct aspect ratio
                      height: 50,
                      width: 67,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
    );
  }
}
