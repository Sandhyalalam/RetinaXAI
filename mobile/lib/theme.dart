import 'package:flutter/material.dart';

class RxColors {
  static const bg = Color(0xFFF5F7FB);
  static const navy = Color(0xFF12263F);
  static const navySoft = Color(0xFF1C3554);
  static const muted = Color(0xFF7B8A9B);
  static const teal = Color(0xFF12A392);
  static const tealDark = Color(0xFF0C8F80);
  static const tealDeep = Color(0xFF0B7F72);
  static const mint = Color(0xFFE7F7F2);
  static const mintSoft = Color(0xFFF3FBFA);
  static const card = Colors.white;
  static const severe = Color(0xFFE11D5A);
  static const monitor = Color(0xFFE8A317);
  static const ok = Color(0xFF2FA36B);
  static const warnBg = Color(0xFFFFF6D8);
  static const warnText = Color(0xFF8A6A12);
  static const line = Color(0xFFE6ECF2);
  static const chatBubble = Color(0xFF12A392);
}

class RxTheme {
  static ThemeData data() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: RxColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: RxColors.teal,
        primary: RxColors.teal,
        surface: RxColors.bg,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: RxColors.navy, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: RxColors.bg,
        foregroundColor: RxColors.navy,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}

class RxGradients {
  static const teal = LinearGradient(
    colors: [Color(0xFF1EC8B4), Color(0xFF0D9B88)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
