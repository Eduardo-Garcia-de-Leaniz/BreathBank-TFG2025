import 'package:breath_bank/widgets/widgets_login_screen/AppBar_Register.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [AppBar_Register()]),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}
