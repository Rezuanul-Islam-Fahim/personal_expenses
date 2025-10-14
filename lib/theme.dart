import 'package:flutter/material.dart';

ThemeData get appTheme => ThemeData(
      scaffoldBackgroundColor: Colors.grey[200],
      primarySwatch: Colors.indigo,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.indigo,
        accentColor: Colors.blueGrey,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Quicksand',
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
            titleTextStyle: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 19,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
      textTheme: ThemeData.light().textTheme.copyWith(
            displaySmall: TextStyle(
              color: Colors.grey[800],
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
            displayMedium: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
            headlineSmall: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            titleLarge: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
    );
