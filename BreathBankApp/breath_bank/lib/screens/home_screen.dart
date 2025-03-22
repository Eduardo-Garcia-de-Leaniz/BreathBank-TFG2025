import 'package:breath_bank/widgets/widgets_botones/BtnRegister.dart';
import 'package:breath_bank/widgets/widgets_botones/BtnLogin.dart';
import 'package:breath_bank/widgets/widgets_home_screen/Image_logo.dart';
import 'package:breath_bank/widgets/widgets_home_screen/Text_title_home_page.dart';
import 'package:breath_bank/widgets/widgets_home_screen/Text_home_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextTitle_HomePage(),
          ImagenLogo(),
          Text_home_screen(),
          BtnLogin(),
          BtnRegister(),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}
