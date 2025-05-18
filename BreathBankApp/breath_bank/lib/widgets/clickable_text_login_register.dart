import 'package:breath_bank/constants/strings.dart';
import 'package:flutter/material.dart';

class ClickableTextLoginRegister extends StatelessWidget {
  final bool isLogin;

  const ClickableTextLoginRegister({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin
              ? LoginStrings.dontHaveAccount
              : LoginStrings.alreadyHaveAccount,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(
              context,
              isLogin ? '/register' : '/login',
            );
          },
          child: Text(
            isLogin ? LoginStrings.registerTitle : LoginStrings.loginTitle,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 7, 71, 94),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
