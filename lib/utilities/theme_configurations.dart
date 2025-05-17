
import 'package:flutter/material.dart';

/// Theme Configuration Utility
class AppThemes {
  static const double borderRadius = 12.0;
  // Shared constants
  static const double _borderRadius = 12.0;
  static const double _elevation = 6.0;
  static const double _iconSize = 30.0;

  // Light theme colors
  static final Color _primaryColorLight = Colors.grey.shade600;
  static final Color _surfaceColorLight = Colors.grey.shade300;
  static final Color _onSurfaceColorLight = Colors.grey.shade600;
  static const Color _greyTextLight = Colors.grey;

  // Dark theme colors
  static const Color _primaryColorDark = Colors.grey;
  static final Color _surfaceColorDark = Colors.grey.shade900;
  static final Color _onSurfaceColorDark = Colors.grey.shade600;
  // static const Color _greyTextDark = Colors.grey;

  // Reusable rounded shape
  static final ShapeBorder _roundedShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(_borderRadius),
  );

  // Base text theme (type-safe text styles)
  static TextTheme _textTheme(Brightness brightness) {
    final textColor =
        brightness == Brightness.light ? Colors.black : Colors.white;
    return TextTheme(
      bodySmall:
          const TextStyle(color: _greyTextLight, fontWeight: FontWeight.bold),
      bodyLarge:
          const TextStyle(color: _greyTextLight, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      titleMedium: const TextStyle(color: Colors.grey),
      titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    );
  }

  // Reusable color scheme
  static ColorScheme _colorScheme({
    required Brightness brightness,
    required Color primary,
    required Color surface,
    required Color onSurface,
  }) {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: Colors.grey.shade400,
      secondary: brightness == Brightness.light ? Colors.black : Colors.white,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      secondaryContainer: Colors.black,
      onPrimaryContainer: Colors.red,
      primaryContainer: Colors.yellow,
    );
  }

  // Individual ThemeData components

  // Dialog theme
  static DialogTheme _dialogTheme(Color bgColor) {
    return DialogTheme(
        backgroundColor: bgColor, elevation: _elevation, shape: _roundedShape);
  }

  // Card theme
  static CardTheme _cardTheme(Color color) {
    return CardTheme(
      color: color,
      elevation: _elevation,
      shape: _roundedShape,
    );
  }

  // Popup menu theme
  static PopupMenuThemeData _popupMenuTheme(Color color) {
    return PopupMenuThemeData(
      color: color,
      elevation: _elevation,
      shape: _roundedShape,
    );
  }

  // ListTile theme
  static ListTileThemeData _listTileTheme(Color tileColor) {
    return ListTileThemeData(tileColor: tileColor, shape: _roundedShape);
  }

  // Checkbox theme
  static CheckboxThemeData _checkboxTheme(Color selectedColor) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return selectedColor;
        }
        return null;
      }),
    );
  }

  /// Base ThemeData builder
  static ThemeData _baseTheme({
    required Color primaryColor,
    required Color surfaceColor,
    required Color onSurfaceColor,
    required Brightness brightness,
  }) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: surfaceColor,
      iconTheme: IconThemeData(color: onSurfaceColor, size: _iconSize),
      dialogTheme: _dialogTheme(surfaceColor),
      cardTheme: _cardTheme(surfaceColor),
      popupMenuTheme: _popupMenuTheme(surfaceColor),
      listTileTheme: _listTileTheme(surfaceColor),
      textTheme: _textTheme(brightness),
      checkboxTheme: _checkboxTheme(onSurfaceColor),
      colorScheme: _colorScheme(
        primary: primaryColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        brightness: brightness,
      ),
    );
  }

  /// Light theme getter
  static ThemeData get lightTheme => _baseTheme(
        primaryColor: _primaryColorLight,
        surfaceColor: _surfaceColorLight,
        onSurfaceColor: _onSurfaceColorLight,
        brightness: Brightness.light,
      );

  /// Dark theme getter
  static ThemeData get darkTheme => _baseTheme(
        primaryColor: _primaryColorDark,
        surfaceColor: _surfaceColorDark,
        onSurfaceColor: _onSurfaceColorDark,
        brightness: Brightness.dark,
      );

  /// Helper to get contrasting text color based on background
  static Color getContrastingColor(Brightness brightness) =>
      brightness == Brightness.light ? Colors.black : Colors.white;
}
