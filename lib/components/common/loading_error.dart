import 'package:flutter/material.dart';

class LoadingError extends StatelessWidget {
  final Function() onRetry;

  const LoadingError({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Failed to load data. Please try again.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            onPressed: onRetry,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
