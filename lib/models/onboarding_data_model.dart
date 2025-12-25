import 'package:flutter/material.dart';

class OnboardingData {
  final String _title;
  final String _description;
  final String _lottieAsset;
  final Color _backgroundColor;

  OnboardingData({
    required String title,
    required String description,
    required String lottieAsset,
    required Color backgroundColor,
  }) : _title = title,
       _description = description,
       _lottieAsset = lottieAsset,
       _backgroundColor = backgroundColor;

  String get title => _title;
  String get description => _description;
  String get lottieAsset => _lottieAsset;
  Color get backgroundColor => _backgroundColor;
}
