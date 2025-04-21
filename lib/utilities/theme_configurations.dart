import 'package:flutter/material.dart';

// this class will hold the configuration files for this app like Theme Data

ThemeData lightTheme = ThemeData(
  dialogBackgroundColor: Colors.grey.shade300, // for timer
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey[300], // for scaffold
  // primaryColor: Colors.grey.shade600,
  iconTheme: IconThemeData(color: Colors.grey.shade600, size: 30),
  dialogTheme: DialogTheme(
      backgroundColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6),
  cardTheme: CardTheme(
    // for cards, list of storage
    color: Colors.grey.shade300,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    elevation: 6,
    // for popupMenu background

    color: Colors.grey.shade300,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Colors.grey[300],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Colors.grey),
    titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey.shade600;
      }
      return null;
    }),
  ),
  colorScheme: ColorScheme(
    secondaryContainer: Colors.black,
    onPrimaryContainer: Colors.red,
    primaryContainer: Colors.yellow,
    brightness: Brightness.light,
    primary: Colors.grey.shade600, // buttons (textButton's child)
    onPrimary: Colors.grey.shade400,
    secondary:
        Colors.black, // favorite icon, playlist control buttons when enables,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.grey.shade300,
    onSurface: Colors.grey.shade600,
    // surface: Colors.grey.shade300,
    // surface: Colors.grey.shade300.withOpacity(0.9),
    // onSurface: Colors.grey.shade600,
  ),
);

ThemeData darkTheme = ThemeData(
  dialogBackgroundColor: Colors.grey.shade900, // for timer
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey.shade900, // for scaffold
  // primaryColor: Colors.grey.shade600,
  iconTheme: IconThemeData(color: Colors.grey.shade600, size: 30),
  dialogTheme: DialogTheme(
      backgroundColor: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6),
  cardTheme: CardTheme(
    // for cards, list of storage
    color: Colors.grey.shade800,
    elevation: 6,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    elevation: 6,
    // for popupMenu background

    color: Colors.grey.shade800,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Colors.grey.shade800,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Colors.grey),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey;
      }
      return null;
    }),
  ),
  colorScheme: ColorScheme(
    secondaryContainer: Colors.black,
    onPrimaryContainer: Colors.red,
    primaryContainer: Colors.yellow,
    brightness: Brightness.dark,
    primary: Colors.grey, // buttons (textButton's child)
    onPrimary: Colors.grey.shade400,
    secondary:
        Colors.white, // favorite icon, playlist control buttons when enables,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.grey.shade900,
    onSurface: Colors.grey.shade600,
    // surface: Colors.grey.shade300,
    // surface: Colors.grey.shade900.withOpacity(0.9),
    // onSurface: Colors.grey.shade600,
  ),
);
