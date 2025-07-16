import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF4A7C59),
  ), // Verde-teal da logo
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF4A7C59),
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF4A7C59),
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Color(0xFFF5F6F5), // Cinza claro para fundos
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    filled: true,
    fillColor: Color(0xFFFFFFFF), // Branco para contraste
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Color(0xFF333333), // Cinza escuro para texto
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
