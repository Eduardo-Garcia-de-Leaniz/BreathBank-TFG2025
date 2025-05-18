import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/widgets/clickable_text_login_register.dart';
import 'package:breath_bank/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  final bool desdeNotificacion;
  const LoginScreen({super.key, required this.desdeNotificacion});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: LoginStrings.loginTitle,
      isScrollable: true,
      withAnimation: true,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
      child: Column(
        children: [
          const ClickableTextLoginRegister(isLogin: true),
          LoginForm(desdeNotificacion: desdeNotificacion),
        ],
      ),
    );
  }
}
