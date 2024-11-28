import 'dart:async';
import 'package:flutter/material.dart';

class LoadingPlaceholder extends StatefulWidget {
  const LoadingPlaceholder({super.key});

  @override
  State<LoadingPlaceholder> createState() => _LoadingPlaceholder();
}

class _LoadingPlaceholder extends State<LoadingPlaceholder> {
  bool _isAnimating = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
    });
    _timer?.cancel(); // Cancel the previous timer to prevent multiple timers
    _timer = Timer(const Duration(milliseconds: 1500), _startAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      color: Colors.grey.withOpacity(
          _isAnimating ? 0.2 : 0.4), // Loading animation by changing opacity
    );
  }
}
