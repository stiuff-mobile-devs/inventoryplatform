import 'package:flutter/material.dart';

final ThemeData globalTheme = ThemeData(
  primarySwatch: Colors.purple,
  primaryColor: Colors.purple,
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.deepPurple,
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.purple,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
    bodySmall: TextStyle(color: Colors.grey, fontSize: 12),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.purple,
    textTheme: ButtonTextTheme.primary,
  ),
  iconTheme: const IconThemeData(
    color: Colors.purple,
  ),
);