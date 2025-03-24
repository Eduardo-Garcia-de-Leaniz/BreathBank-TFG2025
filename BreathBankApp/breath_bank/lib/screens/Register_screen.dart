import 'package:breath_bank/widgets/widgets_botones/BtnBack.dart';
import 'package:breath_bank/widgets/widgets_botones/BtnNext.dart';
import 'package:breath_bank/widgets/widgets_home_screen/Image_logo.dart';
import 'package:breath_bank/widgets/widgets_login_screen/AppBar_Register.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar_Register(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImagenLogo(),
            ClickableTextLoginRegister(),
            RegisterForm(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [BtnBack(), BtnNext(route: '/evaluation')],
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Correo Electrónico',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  color: Color.fromARGB(255, 7, 71, 94),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.email, color: Color.fromARGB(255, 7, 71, 94)),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Introduce tu correo electrónico',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 7, 71, 94),
                          fontSize: 16,
                          fontFamily: 'Arial',
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Arial',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contraseña',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  color: Color.fromARGB(255, 7, 71, 94),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.lock, color: Color.fromARGB(255, 7, 71, 94)),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Introduce tu contraseña',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 7, 71, 94),
                          fontSize: 16,
                          fontFamily: 'Arial',
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Arial',
                        color: Color.fromARGB(255, 7, 71, 94),
                      ),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ClickableTextLoginRegister extends StatelessWidget {
  const ClickableTextLoginRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
                color: Color.fromARGB(255, 7, 71, 94),
              ),
            ),
          ),
        ),

        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Registrarse',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arial',
              color: Color.fromARGB(255, 150, 150, 150),
            ),
          ),
        ),
      ],
    );
  }
}
