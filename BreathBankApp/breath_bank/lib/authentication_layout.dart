import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/screens/dashboard_screen.dart';
import 'package:breath_bank/screens/loading_screen.dart';
import 'package:breath_bank/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AuthenticationLayout extends StatelessWidget {
  const AuthenticationLayout({super.key, this.pageIfNotConnected});
  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authenticationService,
      builder: (context, authenticationService, child) {
        return StreamBuilder(
          stream: authenticationService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = const LoadingScreen();
            } else if (snapshot.hasData) {
              widget = DashboardScreen();
            } else {
              widget = pageIfNotConnected ?? const HomeScreen();
            }
            return widget;
          },
        );
      },
    );
  }
}
