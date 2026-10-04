// THEME LOCK: light — source: domain signal (CRM field tool, trust, clarity)
// Scaffold.backgroundColor = AppTheme.backgroundLight — ALL screens
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryContainer = Color(0xFFE0E7FF);
  static const Color primaryMuted = Color(0xFF818CF8);

  // Secondary
  static const Color secondary = Color(0xFF0EA5E9);
  static const Color secondaryContainer = Color(0xFFE0F2FE);

  // Surfaces
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF8FAFC);
  static const Color backgroundLight = Color(0xFFF1F5F9);
  static const Color surface100 = Color(0xFFF1F5F9);
  static const Color surface200 = Color(0xFFE2E8F0);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Dark surfaces
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceVariantDark = Color(0xFF0F172A);
  static const Color backgroundDark = Color(0xFF0A0F1E);

  // Semantic
  static const Color success = Color(0xFF059669);
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0EA5E9);
  static const Color infoContainer = Color(0xFFE0F2FE);

  // Lead Status Colors
  static const Color statusNew = Color(0xFF6366F1);
  static const Color statusContacted = Color(0xFF0EA5E9);
  static const Color statusEngaged = Color(0xFF8B5CF6);
  static const Color statusQualified = Color(0xFF10B981);
  static const Color statusProposal = Color(0xFFF59E0B);
  static const Color statusFollowUp = Color(0xFFF97316);
  static const Color statusSessions = Color(0xFF7C3AED);
  static const Color statusNegotiation = Color(0xFFEC4899);
  static const Color statusResult = Color(0xFF059669);
  static const Color statusWon = Color(0xFF059669);
  static const Color statusLost = Color(0xFFDC2626);
  static const Color statusJunk = Color(0xFF94A3B8);

  // Priority Colors
  static const Color priorityHigh = Color(0xFFDC2626);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityLow = Color(0xFF10B981);

  static Color leadStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return statusNew;
      case 'contacted':
        return statusContacted;
      case 'engaged':
        return statusEngaged;
      case 'qualified':
        return statusQualified;
      case 'proposed':
      case 'proposal':
        return statusProposal;
      case 'follow up':
      case 'follow-up':
        return statusFollowUp;
      case 'sessions':
        return statusSessions;
      case 'negotiations':
      case 'negotiation':
        return statusNegotiation;
      case 'result':
        return statusResult;
      case 'won':
        return statusWon;
      case 'lost':
        return statusLost;
      case 'junk':
        return statusJunk;
      default:
        return statusNew;
    }
  }

  static Color priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return priorityHigh;
      case 'medium':
        return priorityMedium;
      case 'low':
        return priorityLow;
      default:
        return priorityMedium;
    }
  }

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFF1E1B4B),
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Color(0xFF0C4A6E),
      surface: surfaceLight,
      onSurface: textPrimary,
      surfaceContainerHighest: surfaceVariantLight,
      onSurfaceVariant: textSecondary,
      error: error,
      onError: Colors.white,
      errorContainer: errorContainer,
      outline: surface200,
      outlineVariant: Color(0xFFCBD5E1),
    ),
    scaffoldBackgroundColor: backgroundLight,
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textMuted,
      ),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: surfaceLight,
      foregroundColor: textPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: surface200,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: surfaceVariantLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: surface200, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: surface200, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: error, width: 2),
      ),
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        color: textSecondary,
      ),
      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: textMuted),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceVariantLight,
      selectedColor: primaryContainer,
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: BorderSide(color: primary, width: 1.5),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceLight,
      indicatorColor: primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: primary,
          );
        }
        return GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: primary, size: 22);
        }
        return IconThemeData(color: textSecondary, size: 22);
      }),
    ),
    dividerTheme: DividerThemeData(color: surface200, thickness: 1, space: 1),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF818CF8),
      onPrimary: Color(0xFF1E1B4B),
      primaryContainer: Color(0xFF312E81),
      onPrimaryContainer: Color(0xFFE0E7FF),
      secondary: Color(0xFF38BDF8),
      onSecondary: Color(0xFF0C4A6E),
      secondaryContainer: Color(0xFF0369A1),
      onSecondaryContainer: Color(0xFFE0F2FE),
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFE2E8F0),
      surfaceContainerHighest: Color(0xFF334155),
      onSurfaceVariant: Color(0xFF94A3B8),
      error: Color(0xFFF87171),
      onError: Color(0xFF7F1D1D),
      outline: Color(0xFF334155),
      outlineVariant: Color(0xFF1E293B),
    ),
    scaffoldBackgroundColor: Color(0xFF0F172A),
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: Color(0xFFE2E8F0),
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Color(0xFFE2E8F0),
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE2E8F0),
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFFCBD5E1),
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Color(0xFFCBD5E1),
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF94A3B8),
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Color(0xFF94A3B8),
      ),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: Color(0xFF1E293B),
      foregroundColor: Color(0xFFE2E8F0),
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF1E293B),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Color(0xFF1E293B),
      indicatorColor: Color(0xFF312E81),
    ),
  );
}
