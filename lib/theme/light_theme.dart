import 'package:seohost/theme/custom_theme_colors.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF1D65E8),
  primaryColorLight: const Color(0xFFEAF6FF),
  primaryColorDark: const Color(0xFF0A2D64),
  secondaryHeaderColor: const Color(0xFF71809B),

  disabledColor: const Color(0xFF8797AB),
  scaffoldBackgroundColor: const Color(0xFFF7FBFF),
  brightness: Brightness.light,
  hintColor: const Color(0xFF71809B),
  focusColor: const Color(0xFFE9FFF8),
  hoverColor: const Color(0xFFEAF6FF),
  shadowColor: const Color(0xFFE4ECF7),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: const Color(0xFF1D65E8)),
  ),
  extensions: <ThemeExtension<CustomThemeColors>>[CustomThemeColors.light()],

  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1D65E8),
    secondary: Color(0xFF19C8CF),
    onSecondary: Color(0xFF2FC86F),
    tertiary: Color(0xFF0A2D64),
    onSecondaryContainer: Color(0xFF2FC86F),
    error: Color(0xFFf76767),
    onPrimary: Color(0xFFF8FAFC),
  ).copyWith(surface: const Color(0xffFCFCFC)),
);
