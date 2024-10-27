import 'package:flutter/material.dart';
import 'package:artist_profile/components/common/loading_error.dart';
import 'package:artist_profile/components/common/exit_button.dart';

class ErrorArtistBioPage extends StatelessWidget {
  final Function() onRetry;

  const ErrorArtistBioPage({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: LoadingError(onRetry: onRetry),
          ),
          const ExitButton(),
        ],
      ),
    );
  }
}
