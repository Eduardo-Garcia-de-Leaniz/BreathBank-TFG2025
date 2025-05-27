import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/views/base_screen.dart';
import 'package:breath_bank/widgets/clickable_text_login_register.dart';
import 'package:flutter/material.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      showAppBar: true,
      title: Strings.register,
      isScrollable: true,
      child: Column(
        children: [
          ClickableTextLoginRegister(isLogin: false),
          SizedBox(height: 20),
          RegisterForm(),
        ],
      ),
    );
  }
}
