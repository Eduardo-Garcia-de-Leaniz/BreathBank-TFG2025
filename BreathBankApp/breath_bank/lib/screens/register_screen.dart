import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/widgets/widgets_botones/btnBack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breath_bank/database_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBarRegister(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageLogo(imageWidth: 100, imageHeight: 100),
            ClickableTextLoginRegister(),
            RegisterForm(),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  DatabaseService db = DatabaseService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> register() async {
    try {
      await authenticationService.value.createAccount(
        email: emailController.text,
        password: passwordController.text,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          errorMessage = 'El correo electrónico ya está registrado';
        });
        return false;
      } else {
        setState(() {
          errorMessage = e.message ?? 'Error desconocido';
        });
        return false;
      }
    }
  }

  // Principio SOLID: Open/Closed Principle
  // Se crea un método para añadir futuras validaciones solo en este punto, y no en todo el código
  bool validateInputs() {
    if (emailController.text.isEmpty) {
      setState(() {
        errorMessage = 'Introduce un correo electrónico';
      });
      return false;
    } else if (passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Introduce una contraseña';
      });
      return false;
    } else if (confirmPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Repite la contraseña';
      });
      return false;
    } else if (!emailController.text.contains('@')) {
      setState(() {
        errorMessage = 'Correo electrónico inválido';
      });
      return false;
    } else if (passwordController.text.length < 6) {
      setState(() {
        errorMessage = 'La contraseña debe tener al menos 6 caracteres';
      });
      return false;
    } else if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Las contraseñas no coinciden';
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          TextFieldEmail(emailController: emailController),
          const SizedBox(height: 20),
          TextFieldPassword(passwordController: passwordController),
          const SizedBox(height: 20),
          TextFieldPasswordRepeat(
            confirmPasswordController: confirmPasswordController,
          ),
          const SizedBox(height: 10),
          ErrorMessageWidget(errorMessage: errorMessage),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BtnBack(fontSize: 16, route: '/'),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    errorMessage = '';
                  });
                  if (!validateInputs()) {
                    return;
                  }
                  await register();
                  if (errorMessage.isEmpty) {
                    setState(() {
                      errorMessage = '';
                    });
                    if (!context.mounted) return;
                    await windowUserRegister(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> windowUserRegister(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController surnameController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 7, 71, 94), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          backgroundColor: const Color.fromARGB(255, 188, 252, 245),
          title: const Text(
            'Bienvenid@',
            style: TextStyle(
              color: Color.fromARGB(255, 7, 71, 94),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Por favor, introduce tu nombre y apellidos:',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Arial',
                  color: Color.fromARGB(255, 7, 71, 94),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Introduce tu nombre',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 7, 71, 94),
                    fontSize: 16,
                    fontFamily: 'Arial',
                  ),
                ),
              ),
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  hintText: 'Introduce tus apellidos',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 7, 71, 94),
                    fontSize: 16,
                    fontFamily: 'Arial',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final String name = nameController.text.trim();
                final String surname = surnameController.text.trim();

                if (name.isEmpty || surname.isEmpty) {
                  setState(() {
                    errorMessage = 'Por favor, completa todos los campos';
                  });
                  return;
                }

                try {
                  await db.addNewUser(
                    userId: authenticationService.value.currentUser!.uid,
                    nombre: name,
                    apellidos: surname,
                    fechaCreacion: DateTime.now(),
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "/evaluation");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Usuario registrado correctamente. Bienvenid@ $name',
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  setState(() {
                    errorMessage = 'Error al guardar los datos: $e';
                  });
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Arial',
        color: Colors.redAccent,
      ),
    );
  }
}

class TextFieldPasswordRepeat extends StatelessWidget {
  const TextFieldPasswordRepeat({
    super.key,
    required this.confirmPasswordController,
  });

  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repetir Contraseña',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
            color: Color.fromARGB(255, 7, 71, 94),
          ),
        ),
        Row(
          children: [
            Icon(Icons.lock_outline, color: Color.fromARGB(255, 7, 71, 94)),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Repite tu contraseña',
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
    );
  }
}

class TextFieldPassword extends StatelessWidget {
  const TextFieldPassword({super.key, required this.passwordController});

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: passwordController,
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
    );
  }
}

class TextFieldEmail extends StatelessWidget {
  const TextFieldEmail({super.key, required this.emailController});

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: emailController,
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

class ImageLogo extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;

  const ImageLogo({
    super.key,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Image.asset(
        'assets/images/LogoPrincipal_BreathBank-sin_fondo.png',
        fit: BoxFit.cover,
        width: imageWidth,
        height: imageHeight,
      ),
    );
  }
}

class AppBarRegister extends StatelessWidget {
  const AppBarRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Registro',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
    );
  }
}
