import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Blue Theme Palette
  static const Color primaryDarkBlue = Color(0xFF0A2342); // Deep Navy Blue (primary)
  static const Color secondaryBlue = Color(0xFF1565C0); // Medium Blue (secondary)
  static const Color accentCyan = Color(0xFF39C0FF); // Bright Cyan Accent
  static const Color backgroundMist = Color(0xFF0D1B2A); // Dark background
  static const Color textCharcoal = Color(0xFFE8F1F5); // Light text for dark backgrounds

  // Compatibility aliases for older theme names used across the codebase
  // (keeps incremental refactors small and avoids breaking many files at once)
  static Color get primaryCrimson => primaryDarkBlue;
  static Color get secondaryIndigo => secondaryBlue;
  static Color get accentAmber => accentCyan;

  static final ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
  primary: primaryDarkBlue,
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF1A2332),
  onPrimaryContainer: Color(0xFFE8F1F5),
  secondary: secondaryBlue,
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF0D3A5C),
  onSecondaryContainer: Color(0xFFE8F1F5),
  tertiary: accentCyan,
  onTertiary: Color(0xFF0D1B2A),
  tertiaryContainer: Color(0xFF1A2F3F),
  onTertiaryContainer: Color(0xFFE8F1F5),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: backgroundMist,
    onBackground: textCharcoal,
    surface: Color(0xFF1A2332),
    onSurface: textCharcoal,
    surfaceVariant: Color(0xFF1F2A38),
    onSurfaceVariant: Color(0xFFB8C9D3),
    outline: Color(0xFF4A5A6A),
    onInverseSurface: Color(0xFF0D1B2A),
    inverseSurface: Color(0xFFE8F1F5),
  inversePrimary: Color(0xFF39C0FF),
    shadow: Color(0xFF000000),
  surfaceTint: primaryDarkBlue,
    outlineVariant: Color(0xFF3A4A5A),
    scrim: Color(0xFF000000),
  );

  static final ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
  primary: Color(0xFFD6CCFF),
  onPrimary: Color(0xFF23164F),
  primaryContainer: Color(0xFF2A1F6A),
  onPrimaryContainer: Color(0xFFEDEBFF),
  secondary: Color(0xFF9FC9FF),
  onSecondary: Color(0xFF022238),
  secondaryContainer: secondaryBlue,
  onSecondaryContainer: Color(0xFFDDEEFF),
  tertiary: accentCyan,
  onTertiary: Color(0xFF002428),
  tertiaryContainer: Color(0xFF00505A),
  onTertiaryContainer: Color(0xFFBFF7FF),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF071B2C),
  onBackground: Color(0xFFEFF6FB),
  surface: Color(0xFF071427),
  onSurface: Color(0xFFEFF6FB),
    surfaceVariant: Color(0xFF49454E),
    onSurfaceVariant: Color(0xFFCAC4D0),
    outline: Color(0xFF938F99),
    onInverseSurface: Color(0xFF141218),
    inverseSurface: Color(0xFFE6E0E9),
  inversePrimary: primaryDarkBlue,
    shadow: Color(0xFF000000),
  surfaceTint: primaryDarkBlue,
    outlineVariant: Color(0xFF49454E),
    scrim: Color(0xFF000000),
  );

  // Gradients - clean dark → light blue primary background
  // Use a bold, deep navy flowing into a vivid sky/tech blue for the app's primary background.
  static LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF06283D), Color(0xFF1E88E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Button gradient uses a slightly shifted blue pair for contrast
  static LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF0B3A5A), Color(0xFF2EA1FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Surface gradient for subtle elevation (non-transparent)
  static LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFF3F6FB), Color(0xFFEAF6FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Solid card decoration (no transparency or blur) — clean, modern look
  static BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Color(0xFF1A2332), // Dark card background
    boxShadow: [
      BoxShadow(
        color: Color(0xFF000000).withValues(alpha: 0.3),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Typography - Modern and Clean
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 57,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.25,
      height: 1.12,
      color: Color(0xFFE8F1F5),
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 45,
      fontWeight: FontWeight.w300,
      letterSpacing: 0,
      height: 1.16,
      color: Color(0xFFE8F1F5),
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
      color: Color(0xFFE8F1F5),
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
      color: Color(0xFFE8F1F5),
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
      color: Color(0xFFE8F1F5),
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
      color: Color(0xFFE8F1F5),
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
      color: Color(0xFFE8F1F5),
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
      color: Color(0xFFE8F1F5),
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: Color(0xFFE8F1F5),
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: Color(0xFFE8F1F5),
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      color: Color(0xFFB8C9D3),
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      color: Color(0xFFB8C9D3),
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
      color: Color(0xFFE8F1F5),
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      color: Color(0xFFD1DCE5),
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: Color(0xFFB8C9D3),
    ),
  );

  // Border Radius
  static final BorderRadius buttonRadius = BorderRadius.circular(12);
  static final BorderRadius cardRadius = BorderRadius.circular(16);
  static final BorderRadius chipRadius = BorderRadius.circular(8);

  // Elevation
  static const double cardElevation = 2;
  static const double buttonElevation = 1;
  static const double modalElevation = 3;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: lightColorScheme.background,
    appBarTheme: AppBarTheme(
      elevation: 0,
      // use the primary color as a solid app bar (avoid transparency)
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      titleTextStyle: GoogleFonts.poppins(
        color: lightColorScheme.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      color: lightColorScheme.surface,
      shadowColor: lightColorScheme.shadow.withValues(alpha: 0.1),
    ),
      inputDecorationTheme: InputDecorationTheme(
      filled: true,
      // solid input background (no translucent/frosted look)
      fillColor: lightColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: lightColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: GoogleFonts.poppins(
        color: lightColorScheme.onSurfaceVariant,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.poppins(
        color: lightColorScheme.onSurfaceVariant,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(color: lightColorScheme.outline),
        foregroundColor: lightColorScheme.onSurface,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: lightColorScheme.primary.withOpacity(0.1),
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          );
        }
        return GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            size: 24,
            color: Colors.black87,
          );
        }
        return IconThemeData(
          size: 24,
          color: Colors.grey.shade600,
        );
      }),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: darkColorScheme.background,
    appBarTheme: AppBarTheme(
      elevation: 0,
      // use solid primary in dark theme for consistency
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      titleTextStyle: GoogleFonts.poppins(
        color: darkColorScheme.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      color: darkColorScheme.surface,
      shadowColor: darkColorScheme.shadow.withValues(alpha: 0.1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      // solid input background in dark mode
      fillColor: darkColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: darkColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: GoogleFonts.poppins(
        color: darkColorScheme.onSurfaceVariant,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.poppins(
        color: darkColorScheme.onSurfaceVariant,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(color: darkColorScheme.outline),
        foregroundColor: darkColorScheme.onSurface,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
