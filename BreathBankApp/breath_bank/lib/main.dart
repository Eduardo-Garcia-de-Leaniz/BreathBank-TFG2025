import 'package:breath_bank/screens/Dashboard_screen.dart';
import 'package:breath_bank/screens/Evaluation_screen.dart';
import 'package:breath_bank/screens/Register_screen.dart';
import 'package:breath_bank/screens/Test1_screen.dart';
import 'package:breath_bank/screens/Test2_screen.dart';
import 'package:breath_bank/screens/Test3_screen.dart';
import 'package:breath_bank/screens/login_screen.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Mis widgets
import 'package:breath_bank/screens/Home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  //checkFirebaseConnection(); // Llama a la función para verificar la conexión
}

/* void checkFirebaseConnection() async {
  try {
    await FirebaseFirestore.instance.collection("test").get();
    print("✅ Firebase está conectado correctamente.");
  } catch (e) {
    print("❌ Error de conexión con Firebase: $e");
  }
} */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'BreathBank',
      theme: ThemeData(
        fontFamily: 'Arial',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/evaluation': (context) => EvaluationScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/evaluation/test1': (context) => Test1Screen(),
        '/evaluation/test2': (context) => Test2Screen(),
        '/evaluation/test3': (context) => Test3Screen(),
      },
    );
  }
}
