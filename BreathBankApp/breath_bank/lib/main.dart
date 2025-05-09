import 'package:breath_bank/screens/guided_investment_screen.dart';
import 'package:breath_bank/screens/investment_result_screen.dart';
import 'package:breath_bank/screens/home_screen.dart';
import 'package:breath_bank/views/evaluation_screen.dart';
import 'package:breath_bank/views/login_screen.dart';
import 'package:breath_bank/views/register_screen.dart';
import 'package:breath_bank/views/test1_screen.dart';
import 'package:breath_bank/views/test2_screen.dart';
import 'package:breath_bank/views/test3_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/providers/push_notifications_provider.dart';
import 'package:breath_bank/screens/dashboard_screen.dart';
import 'package:breath_bank/screens/app_settings_screen.dart';
import 'package:breath_bank/screens/evaluation_menu_screen.dart';
import 'package:breath_bank/screens/investment_menu_screen.dart';
import 'package:breath_bank/screens/manual_investment_screen.dart';
import 'package:breath_bank/screens/new_investment_menu_screen.dart';
import 'package:breath_bank/screens/notifications_screen.dart';
import 'package:breath_bank/views/evaluation_result_screen.dart';
import 'package:breath_bank/screens/account_settings_screen.dart';
import 'package:breath_bank/screens/account_settings_reset_password_screen.dart';
import 'package:breath_bank/screens/account_settings_consult_data_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // ¡Necesario!
  //print("Mensaje en segundo plano (background): ${message.notification?.title}",);
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
              const SnackBar(
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

  Future<User?> _checkUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user
            .reload(); // esto lanza una excepción si el usuario fue borrado
        return FirebaseAuth.instance.currentUser;
      }
      return null;
    } catch (e) {
      // Si hay un error al hacer reload, probablemente el usuario fue eliminado
      await FirebaseAuth.instance.signOut(); // limpia el estado local
      return null;
    }
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
        '/register': (context) => const RegisterScreen(),
        '/evaluation': (context) => const EvaluationScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/evaluation/test1': (context) => const Test1Screen(),
        '/evaluation/test2': (context) => const Test2Screen(),
        '/evaluation/test3': (context) => const Test3Screen(),
        '/evaluation/result': (context) => const EvaluationResultScreen(),
        '/dashboard/accountsettings':
            (context) => const AccountSettingsScreen(),
        '/dashboard/accontsettings/resetpassword':
            (context) => const AccountSettingsResetPasswordScreen(),
        '/dashboard/accountsettings/consultdata':
            (context) => const AccountSettingsModifyDataScreen(),
        '/dashboard/appsettings': (context) => const AppSettingsScreen(),
        '/dashboard/evaluationmenu': (context) => const EvaluationMenuScreen(),
        '/dashboard/investmentmenu': (context) => const InvestmentMenuScreen(),
        '/dashboard/newinvestmentmenu':
            (context) => const NewInvestmentMenuScreen(),
        '/dashboard/newinvestmentmenu/manual':
            (context) => const ManualInvestmentScreen(),
        '/dashboard/newinvestmentmenu/guided':
            (context) => const GuidedInvestmentScreen(),
        '/dashboard/appsettings/notifications':
            (context) => const NotificationsScreen(),
        '/dashboard/newinvestmentmenu/results':
            (context) => InvestmentResultScreen(),
        '/':
            (context) => FutureBuilder<User?>(
              future: _checkUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const HomeScreen(); // o LoginScreen si prefieres
                } else if (snapshot.data == null) {
                  final args =
                      ModalRoute.of(context)?.settings.arguments
                          as Map<String, dynamic>?;
                  final desdeNotificacion = args?['desdeNotificacion'] ?? false;

                  if (desdeNotificacion) {
                    return const LoginScreen(desdeNotificacion: true);
                  } else {
                    return const HomeScreen();
                  }
                } else {
                  return DashboardScreen();
                }
              },
            ),

        // Otras rutas...
      },
    );
  }
}
