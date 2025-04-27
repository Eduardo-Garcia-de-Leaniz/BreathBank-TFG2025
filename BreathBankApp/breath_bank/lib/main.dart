import 'package:breath_bank/screens/GuidedInvestment_screen.dart';
import 'package:breath_bank/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/providers/push_notifications_provider.dart';
import 'package:breath_bank/screens/login_screen.dart';
import 'package:breath_bank/screens/Dashboard_screen.dart';
import 'package:breath_bank/providers/push_notifications_provider.dart';
import 'package:breath_bank/screens/AppSettings_screen.dart';
import 'package:breath_bank/screens/Dashboard_screen.dart';
import 'package:breath_bank/screens/EvaluationMenu_screen.dart';
import 'package:breath_bank/screens/Evaluation_screen.dart';
import 'package:breath_bank/screens/InvestmentMenu_screen.dart';
import 'package:breath_bank/screens/ManualInvestment_screen.dart';
import 'package:breath_bank/screens/NewInvestmentMenu_screen.dart';
import 'package:breath_bank/screens/Notifications_screen.dart';
import 'package:breath_bank/screens/Register_screen.dart';
import 'package:breath_bank/screens/Test1_screen.dart';
import 'package:breath_bank/screens/Test2_screen.dart';
import 'package:breath_bank/screens/Test3_screen.dart';
import 'package:breath_bank/screens/login_screen.dart';
import 'package:breath_bank/screens/EvaluationResult_screen.dart';
import 'package:breath_bank/screens/AccountSettings_screen.dart';
import 'package:breath_bank/screens/AccountSettingsResetPassword_screen.dart';
import 'package:breath_bank/screens/AccountSettingsConsultData_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // ¡Necesario!
  print(
    "Mensaje en segundo plano (background): ${message.notification?.title}",
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
            // Aquí puedes mostrar un diálogo o una notificación local
            // para informar al usuario que debe iniciar sesión
            // Por ejemplo, puedes usar un SnackBar o un diálogo de alerta
            ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
              SnackBar(
                content: Text(
                  'Por favor, inicia sesión para acceder al contenido de la notifiación.',
                ),
                duration: Duration(seconds: 3),
              ),
            );
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
        '/login': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final desdeNotificacion = args?['desdeNotificacion'] ?? false;
          return LoginScreen(desdeNotificacion: desdeNotificacion);
        },
        '/register': (context) => RegisterScreen(),
        '/evaluation': (context) => EvaluationScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/evaluation/test1': (context) => Test1Screen(),
        '/evaluation/test2': (context) => Test2Screen(),
        '/evaluation/test3': (context) => Test3Screen(),
        '/evaluation/result': (context) => EvaluationresultScreen(),
        '/dashboard/accountsettings': (context) => AccountSettingsScreen(),
        '/dashboard/accontsettings/resetpassword':
            (context) => AccountSettingsResetPasswordScreen(),
        '/dashboard/accountsettings/consultdata':
            (context) => AccountSettingsModifyDataScreen(),
        '/dashboard/appsettings': (context) => AppSettingsScreen(),
        '/dashboard/evaluationmenu': (context) => EvaluationMenuScreen(),
        '/dashboard/investmentmenu': (context) => InvestmentMenuScreen(),
        '/dashboard/newinvestmentmenu': (context) => NewInvestmentMenuScreen(),
        '/dashboard/newinvestmentmenu/manual':
            (context) => ManualInvestmentScreen(),
        '/dashboard/newinvestmentmenu/guided':
            (context) => GuidedInvestmentScreen(),
        '/dashboard/appsettings/notifications':
            (context) => NotificationsScreen(),
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
                  // Verificar si viene desde una notificación
                  final args =
                      ModalRoute.of(context)?.settings.arguments
                          as Map<String, dynamic>?;
                  final desdeNotificacion = args?['desdeNotificacion'] ?? false;

                  if (desdeNotificacion) {
                    print(
                      'No hay usuario logueado. Redirigiendo a LoginScreen desde notificación...',
                    );
                    return LoginScreen(desdeNotificacion: true);
                  } else {
                    print(
                      'No hay usuario logueado. Redirigiendo a HomeScreen...',
                    );
                    return HomeScreen();
                  }
                } else {
                  return DashboardScreen(); // Si está logueado, muestra DashboardScreen
                }
              },
            ),
        // Otras rutas...
      },
    );
  }
}
