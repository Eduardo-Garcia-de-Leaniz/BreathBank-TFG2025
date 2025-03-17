import 'package:flutter/material.dart';

// Mis widgets
import 'package:breath_bank/screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'BreathBank',
      home: HomeScreen(),
    );
  }
}
