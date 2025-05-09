import 'package:breath_bank/views/base_screen.dart';
import 'package:breath_bank/widgets/clickable_text_login_register.dart';
import 'package:flutter/material.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showAppBar: true,
      title: 'Registro',
      isScrollable: true,
      child: Column(
        children: [
          const ClickableTextLoginRegister(isLogin: false),
          const SizedBox(height: 20),
          const RegisterForm(),
        ],
      ),
    );
  }
}
