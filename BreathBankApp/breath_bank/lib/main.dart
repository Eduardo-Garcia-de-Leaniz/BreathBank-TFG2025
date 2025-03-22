import 'package:breath_bank/screens/Register_screen.dart';
import 'package:breath_bank/screens/login_screen.dart';
import 'package:flutter/material.dart';

// Mis widgets
import 'package:breath_bank/screens/Home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'BreathBank',
      theme: ThemeData(
        fontFamily: 'Airmill',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
