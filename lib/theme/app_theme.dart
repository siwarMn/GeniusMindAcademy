import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ============================================
  // PRIMARY COLORS
  // ============================================
  static const Color primaryColor = Color(0xFF6C63FF); // Modern Purple/Indigo
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42D4);

  static const Color secondaryColor = Color(0xFF03DAC6); // Teal Accent
  static const Color secondaryLight = Color(0xFF66FFF8);
  static const Color secondaryDark = Color(0xFF00A896);

  // ============================================
  // BACKGROUND & SURFACE COLORS
  // ============================================
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;

  // ============================================
  // TEXT COLORS
  // ============================================
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.white;

  // ============================================
  // SEMANTIC COLORS (Status/Feedback)
  // ============================================
  static const Color successColor = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);

  static const Color warningColor = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);

  static const Color errorColor = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);

  static const Color infoColor = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ============================================
  // STATUS COLORS (for tickets, quizzes, etc.)
  // ============================================
  static const Color statusOpen = Color(0xFFFF9800);
  static const Color statusInProgress = Color(0xFF2196F3);
  static const Color statusResolved = Color(0xFF4CAF50);
  static const Color statusClosed = Color(0xFF9E9E9E);

  // ============================================
  // PRIORITY COLORS
  // ============================================
  static const Color priorityLow = Color(0xFF4CAF50);
  static const Color priorityMedium = Color(0xFFFF9800);
  static const Color priorityHigh = Color(0xFFFF5722);
  static const Color priorityCritical = Color(0xFFE53935);

  // ============================================
  // LEVEL/DIFFICULTY COLORS
  // ============================================
  static const Color levelEasy = Color(0xFF4CAF50);
  static const Color levelMedium = Color(0xFFFF9800);
  static const Color levelHard = Color(0xFFE53935);

  // ============================================
  // GRADIENTS
  // ============================================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryLight, secondaryColor],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEEECFF), Colors.white],
  );

  static LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor.withOpacity(0.05), Colors.white],
  );

  // ============================================
  // SHADOWS
  // ============================================
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // ============================================
  // BORDER RADIUS
  // ============================================
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusRound = 30.0;

  // ============================================
  // SPACING
  // ============================================
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // ============================================
  // MAIN THEME DATA
  // ============================================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    ),

    fontFamily: 'Roboto',

    // ==================== APP BAR ====================
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ==================== TEXT THEME ====================
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),

    // ==================== INPUT DECORATION ====================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(color: textSecondary),
      hintStyle: const TextStyle(color: textHint),
      prefixIconColor: textSecondary,
      suffixIconColor: textSecondary,
    ),

    // ==================== ELEVATED BUTTON ====================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // ==================== OUTLINED BUTTON ====================
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // ==================== TEXT BUTTON ====================
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ==================== FLOATING ACTION BUTTON ====================
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // ==================== CARD ====================
    cardTheme: const CardThemeData(
      color: cardColor,
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
    ),

    // ==================== CHIP ====================
    chipTheme: const ChipThemeData(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),

    // ==================== BOTTOM SHEET ====================
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),

    // ==================== DIALOG ====================
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
    ),

    // ==================== SNACKBAR ====================
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),

    // ==================== DIVIDER ====================
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
    ),

    // ==================== ICON ====================
    iconTheme: const IconThemeData(
      color: textSecondary,
      size: 24,
    ),

    // ==================== LIST TILE ====================
    listTileTheme: const ListTileThemeData(
      iconColor: primaryColor,
      textColor: textPrimary,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    // ==================== PROGRESS INDICATOR ====================
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
    ),

    // ==================== TAB BAR ====================
    tabBarTheme: const TabBarThemeData(
      labelColor: primaryColor,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryColor,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  // ============================================
  // HELPER METHODS
  // ============================================

  // Get status color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return statusOpen;
      case 'in progress':
        return statusInProgress;
      case 'resolved':
        return statusResolved;
      case 'closed':
        return statusClosed;
      default:
        return textSecondary;
    }
  }

  // Get priority color
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return priorityLow;
      case 'medium':
        return priorityMedium;
      case 'high':
        return priorityHigh;
      case 'critical':
        return priorityCritical;
      default:
        return textSecondary;
    }
  }

  // Get level/difficulty color
  static Color getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'facile':
      case 'easy':
      case 'debutant':
        return levelEasy;
      case 'moyen':
      case 'medium':
      case 'intermediaire':
        return levelMedium;
      case 'difficile':
      case 'hard':
      case 'avance':
        return levelHard;
      default:
        return textSecondary;
    }
  }

  // Standard decorated container (for headers, etc.)
  static BoxDecoration get headerDecoration => BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(radiusRound),
          bottomRight: Radius.circular(radiusRound),
        ),
      );

  // Standard card decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(radiusLarge),
        boxShadow: cardShadow,
      );

  // Badge decoration
  static BoxDecoration badgeDecoration(Color color) => BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      );
}
