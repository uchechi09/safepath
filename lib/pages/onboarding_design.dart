import 'package:flutter/material.dart';

class OnboardingDesign {
  static const Color primaryBlue = Color(0xFF3F37C9); 
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);
  static const Color indicatorActive = Color(0xFF64748B);
  static const Color indicatorInactive = Color(0xFFCBD5E1);

  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textLight,
    height: 1.5,
  );
}
