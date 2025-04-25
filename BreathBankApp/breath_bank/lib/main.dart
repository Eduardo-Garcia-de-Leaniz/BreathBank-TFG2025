import 'package:breath_bank/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/providers/push_notifications_provider.dart';
import 'package:breath_bank/screens/login_screen.dart';
import 'package:breath_bank/screens/Dashboard_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    // Asegurarse de que el contexto esté disponible después de que se haya construido el primer cuadro
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pushProvider = PushNotificationsProvider();
      if (navigatorKey.currentContext != null) {
        pushProvider.initNotifications(navigatorKey.currentContext!);
      }

      pushProvider.mensajes.listen((data) async {
        if (data != 'no-data') {
          User? user = FirebaseAuth.instance.currentUser;

          if (user == null) {
            // Si no está logueado, redirigir al login
            _navigateToLogin();
          } else {
            // Si está logueado, navegar a la ruta correspondiente
            _navigateToRoute(data);
          }
        }
      });
    });
  }

  // Método para navegar a la pantalla de login
  void _navigateToLogin() {
    if (navigatorKey.currentState?.context != null) {
      navigatorKey.currentState?.pushNamed(
        '/login',
        arguments: {'desdeNotificacion': true},
      );
    }
  }

  // Método para navegar a la ruta correspondiente
  void _navigateToRoute(String route) {
    if (navigatorKey.currentState?.context != null) {
      navigatorKey.currentState?.pushNamed(route, arguments: route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'BreathBank',
      theme: ThemeData(
        fontFamily: 'Arial',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/':
            (context) => FutureBuilder<User?>(
              future: FirebaseAuth.instance.currentUser?.reload().then(
                (_) => FirebaseAuth.instance.currentUser,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null) {
                  return HomeScreen(); // Si no está logueado, muestra LoginScreen
                } else {
                  return DashboardScreen(); // Si está logueado, muestra DashboardScreen
                }
              },
            ),
        '/login': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final desdeNotificacion = args?['desdeNotificacion'] ?? false;
          return LoginScreen(desdeNotificacion: desdeNotificacion);
        },
        // Otras rutas...
      },
    );
  }
}
