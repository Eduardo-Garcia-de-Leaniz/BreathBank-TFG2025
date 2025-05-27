import 'package:breath_bank/constants/constants.dart';
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
          isLogin ? Strings.dontHaveAccount : Strings.alreadyHaveAccount,
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
            isLogin ? Strings.register : Strings.login,
            style: const TextStyle(
              fontSize: 16,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
