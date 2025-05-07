import 'package:breath_bank/widgets/appbars/login_appbar.dart';
import 'package:breath_bank/widgets/clickable_text_login_register.dart';
import 'package:breath_bank/widgets/image_logo.dart';
import 'package:flutter/material.dart';
import '../../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  final bool desdeNotificacion;
  const LoginScreen({super.key, required this.desdeNotificacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBarLogin(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ImageLogo(imageWidth: 150, imageHeight: 150),
            const ClickableTextLoginRegister(),
            LoginForm(desdeNotificacion: desdeNotificacion),
          ],
        ),
      ),
    );
  }
}
