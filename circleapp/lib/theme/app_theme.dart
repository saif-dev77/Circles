import 'package:flutter/material.dart';

class AppTheme {
  // App's primary color (teal accent)
  static const Color primaryColor = Color.fromRGBO(117, 216, 216, 1);
  
  // Light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(
        fontFamily: 'Daysone',
        color: primaryColor,
        fontSize: 22,
      ),
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    dividerTheme: const DividerThemeData(color: Colors.grey),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[200],
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor),
      ),
      hintStyle: TextStyle(color: Colors.grey[600]),
    ),
    cardTheme: CardTheme(
      color: Colors.grey[100],
      elevation: 2,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.grey[700],
      indicatorColor: primaryColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[700],
    ),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: primaryColor,
      onPrimary: Colors.white,
      background: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(
        fontFamily: 'Daysone',
        color: primaryColor,
        fontSize: 22,
      ),
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    dividerTheme: DividerThemeData(color: Colors.grey[800]),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[900],
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[800]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[800]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    cardTheme: CardTheme(
      color: Colors.grey[900],
      elevation: 2,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.white,
      indicatorColor: primaryColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.white70,
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryColor,
      onPrimary: Colors.black,
      background: Colors.black,
      surface: Colors.grey[900]!,
      onSurface: Colors.white70,
    ),
  );
} 