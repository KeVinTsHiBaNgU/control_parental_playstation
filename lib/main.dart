import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(ControlParentalApp());
}

class ControlParentalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contrôle Parental PlayStation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}