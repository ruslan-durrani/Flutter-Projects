import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define the color palette
final Color _black = Colors.black; // Black for primary in light theme, text in dark
final Color _white = Colors.white; // White for secondary in light theme, background in dark
final Color _darkGray = Color(0xFF333333); // Dark gray for tertiary and text in dark theme
final Color _mediumGray = Color(0xFF666666); // Medium gray for placeholders, borders, etc.
final Color _lightGray = Color(0xFFFAFAFA); // Light gray for backgrounds, buttons, etc. in light theme

// Define the text theme
final TextTheme _textTheme = TextTheme(
  displayLarge: GoogleFonts.kufam(fontSize: 32.0, fontWeight: FontWeight.bold),
  displayMedium: GoogleFonts.kufam(fontSize: 24.0, fontWeight: FontWeight.bold),
  displaySmall: GoogleFonts.kufam(fontSize: 18.72, fontWeight: FontWeight.bold),
  headlineMedium: GoogleFonts.kufam(fontSize: 16.0, fontWeight: FontWeight.bold),
  bodyLarge: GoogleFonts.roboto(fontSize: 14.0, fontWeight: FontWeight.normal),
  bodyMedium: GoogleFonts.roboto(fontSize: 12.0, fontWeight: FontWeight.normal),
  bodySmall: GoogleFonts.roboto(fontSize: 10.0, fontWeight: FontWeight.normal),
  // Define other text styles like subtitle1, subtitle2, caption, etc., if needed
);

// Light theme color scheme
final ColorScheme _colorSchemeLight = ColorScheme(
  brightness: Brightness.light,
  primary: _black,
  onPrimary: _white,
  secondary: _white,
  onSecondary: _black,
  surface: _white,
  onSurface: _black,
  background: _lightGray,
  onBackground: _black,
  error: _darkGray,
  onError: _white,
);

// Dark theme color scheme
final ColorScheme _colorSchemeDark = ColorScheme(
  brightness: Brightness.dark,
  primary: _darkGray,
  onPrimary: _white,
  secondary: _black,
  onSecondary: _white,
  surface: _darkGray,
  onSurface: _white,
  background: _black,
  onBackground: _white,
  error: _mediumGray,
  onError: _black,
);

// Light theme data
final ThemeData themeData = ThemeData(
  colorScheme: _colorSchemeLight,
  textTheme: _textTheme.apply(
    bodyColor: _colorSchemeLight.onSurface,
    displayColor: _colorSchemeLight.onSurface,
  ),
);

// Dark theme data
final ThemeData darkThemeData = ThemeData(
  colorScheme: _colorSchemeDark,
  textTheme: _textTheme.apply(
    bodyColor: _colorSchemeDark.onSurface,
    displayColor: _colorSchemeDark.onSurface,
  ),
);
