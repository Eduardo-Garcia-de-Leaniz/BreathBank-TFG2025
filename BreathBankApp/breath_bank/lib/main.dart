import 'package:breath_bank/views/accont_settings_consult_data_screen.dart';
import 'package:breath_bank/views/account_settings_reset_password_screen.dart';
import 'package:breath_bank/views/account_settings_screen.dart';
import 'package:breath_bank/views/dashboard_screen.dart';
import 'package:breath_bank/views/evaluation_menu_screen.dart';
import 'package:breath_bank/views/guided_investment_info_screen.dart';
import 'package:breath_bank/views/guided_investment_screen.dart';
import 'package:breath_bank/views/home_screen.dart';
import 'package:breath_bank/views/evaluation_screen.dart';
import 'package:breath_bank/views/info_app_settings_screen.dart';
import 'package:breath_bank/views/investment_menu_screen.dart';
import 'package:breath_bank/views/investment_result_screen.dart';
import 'package:breath_bank/views/login_screen.dart';
import 'package:breath_bank/views/manual_investment_info_screen.dart';
import 'package:breath_bank/views/manual_investment_screen.dart';
import 'package:breath_bank/views/new_investment_menu_screen.dart';
import 'package:breath_bank/views/privacy_screen.dart';
import 'package:breath_bank/views/privacy_settings_screen.dart';
import 'package:breath_bank/views/register_screen.dart';
import 'package:breath_bank/views/test1_screen.dart';
import 'package:breath_bank/views/test2_screen.dart';
import 'package:breath_bank/views/test3_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/views/app_settings_screen.dart';
import 'package:breath_bank/views/evaluation_result_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

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
  }

  Future<User?> _checkUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        return FirebaseAuth.instance.currentUser;
      }
      return null;
    } catch (e) {
      await FirebaseAuth.instance.signOut();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        '/privacy': (context) => const PrivacyScreen(),
        '/evaluation': (context) => const EvaluationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/evaluation/test1': (context) => const Test1Screen(),
        '/evaluation/test2': (context) => const Test2Screen(),
        '/evaluation/test3': (context) => const Test3Screen(),
        '/evaluation/result': (context) => const EvaluationResultScreen(),
        '/dashboard/accountsettings':
            (context) => const AccountSettingsScreen(),
        '/dashboard/accontsettings/resetpassword':
            (context) => const AccountSettingsResetPasswordScreen(),
        '/dashboard/accountsettings/consultdata':
            (context) => const AccountSettingsConsultDataScreen(),
        '/dashboard/appsettings': (context) => const AppSettingsScreen(),
        '/dashboard/appsettings/privacysettings':
            (context) => const PrivacySettingsScreen(),
        '/dashboard/appsettings/info':
            (context) => const InfoAppSettingsScreen(),
        '/dashboard/evaluationmenu': (context) => EvaluationMenuScreen(),
        '/dashboard/investmentmenu': (context) => InvestmentMenuScreen(),
        '/dashboard/newinvestmentmenu':
            (context) => const NewInvestmentMenuScreen(),
        '/dashboard/newinvestmentmenu/manualinfo':
            (context) => const ManualInvestmentInfoScreen(),
        '/dashboard/newinvestmentmenu/guidedinfo':
            (context) => const GuidedInvestmentInfoScreen(),
        '/dashboard/newinvestmentmenu/manual':
            (context) => const ManualInvestmentScreen(),
        '/dashboard/newinvestmentmenu/guided':
            (context) => const GuidedInvestmentScreen(),
        '/dashboard/newinvestmentmenu/results':
            (context) => InvestmentResultScreen(),
        '/':
            (context) => FutureBuilder<User?>(
              future: _checkUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const HomeScreen();
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
                  return const DashboardScreen();
                }
              },
            ),
      },
    );
  }
}
