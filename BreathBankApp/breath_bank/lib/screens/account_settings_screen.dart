import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final DatabaseService db = DatabaseService();
  String userId = FirebaseAuth.instance.currentUser!.uid;

  String nombre = 'Cargando...';
  String apellidos = 'Cargando...';
  String email = 'Cargando...';

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  void cargarDatosUsuario() async {
    final userDoc = await db.read(collectionPath: 'Usuarios', docId: userId);
    if (userDoc != null) {
      setState(() {
        nombre = userDoc['Nombre'] ?? 'Sin nombre';
        apellidos = userDoc['Apellidos'] ?? 'Sin apellidos';
      });
    } else {
      setState(() {
        nombre = 'Error al cargar';
        apellidos = 'Error al cargar';
      });
    }

    setState(() {
      email = FirebaseAuth.instance.currentUser?.email ?? 'Sin email';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAccountSettings(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color.fromARGB(255, 7, 71, 94),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              '$nombre $apellidos',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 7, 71, 94),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(color: Color.fromARGB(255, 7, 71, 94)),
            ),
            const SizedBox(height: 24),

            // Lista de opciones
            Expanded(
              child: ListView(
                children: [
                  buildOptionTile(
                    icon: Icons.edit_note,
                    title: 'Consultar mis datos',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/dashboard/accountsettings/consultdata',
                      );
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.password,
                    title: 'Cambiar contraseña',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/dashboard/accontsettings/resetpassword',
                      );
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.history,
                    title: 'Borrar historial',
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: const Color.fromARGB(
                                255,
                                7,
                                71,
                                94,
                              ),
                              title: Text(
                                'Borrar historial',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Text(
                                '¿Estás seguro de que deseas borrar tu historial de inversiones y evaluaciones? Esta acción no se puede deshacer. Tu nivel de inversor se restablecerá a 0.',
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      188,
                                      252,
                                      245,
                                    ),
                                  ),
                                  child: Text(
                                    'Borrar',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 7, 71, 94),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                ),
                              ],
                            ),
                      );

                      if (confirmed == true) {
                        DatabaseService bd = DatabaseService();
                        userId = FirebaseAuth.instance.currentUser!.uid;
                        try {
                          await bd.deleteUserData(userId: userId);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/dashboard',
                            (route) => false,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al borrar el historial'),
                            ),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Historial borrado correctamente'),
                          ),
                        );
                      }
                    },
                  ),

                  buildOptionTile(
                    icon: Icons.logout,
                    title: 'Cerrar sesión',
                    backgroundColor: Colors.red,
                    iconColor: Colors.white,
                    titleColor: Colors.white,
                    arrowColor: Colors.white,
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: const Color.fromARGB(
                                255,
                                7,
                                71,
                                94,
                              ),
                              title: Text(
                                'Cerrar sesión',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Text(
                                '¿Estás seguro de que deseas cerrar sesión?',
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      188,
                                      252,
                                      245,
                                    ),
                                  ),
                                  child: Text(
                                    'Cerrar sesión',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 7, 71, 94),
                                    ),
                                  ),
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                ),
                                TextButton(
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                ),
                              ],
                            ),
                      );

                      if (confirmed == true) {
                        final authenticationService = AuthenticationService();
                        try {
                          await authenticationService.signOut();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sesión cerrada correctamente'),
                            ),
                          );
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
                        } on FirebaseAuthException {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al cerrar sesión')),
                          );
                        }
                      }
                    },
                  ),

                  buildOptionTile(
                    icon: Icons.delete_forever,
                    title: 'Eliminar cuenta',
                    backgroundColor: Colors.red,
                    iconColor: Colors.white,
                    titleColor: Colors.white,
                    arrowColor: Colors.white,
                    onTap: () async {
                      final auth = FirebaseAuth.instance;
                      final db = DatabaseService();
                      final user = auth.currentUser;
                      final authenticationService = AuthenticationService();

                      final passwordController = TextEditingController();
                      String? errorMessage;

                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return StatefulBuilder(
                            builder:
                                (context, setState) => AlertDialog(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    7,
                                    71,
                                    94,
                                  ),
                                  title: const Text(
                                    'Eliminar cuenta',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción eliminará todos tus datos y no se puede deshacer.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: passwordController,
                                        obscureText: true,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: 'Contraseña',
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                      if (errorMessage != null) ...[
                                        const SizedBox(height: 12),
                                        Text(
                                          errorMessage!,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(
                                                context,
                                              ).pop(), // Cerrar
                                      child: const Text(
                                        'Cancelar',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          188,
                                          252,
                                          245,
                                        ),
                                      ),
                                      child: const Text(
                                        'Eliminar',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 7, 71, 94),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final password =
                                            passwordController.text.trim();
                                        if (password.isEmpty) {
                                          setState(() {
                                            errorMessage =
                                                'Por favor, introduce tu contraseña';
                                          });
                                          return;
                                        }

                                        try {
                                          // Eliminar datos
                                          await db.deleteUserAccount(
                                            userId: user!.uid,
                                          );

                                          // Eliminar cuenta
                                          await authenticationService
                                              .deleteAccount(
                                                email: user.email!,
                                                password: password,
                                              );

                                          Navigator.of(
                                            context,
                                          ).pop(); // Cierra el diálogo

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Cuenta eliminada correctamente',
                                              ),
                                            ),
                                          );

                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/',
                                            (route) => false,
                                          );
                                        } catch (e) {
                                          final error = e.toString();

                                          if (error.contains(
                                            'The supplied auth credential is incorrect',
                                          )) {
                                            setState(() {
                                              errorMessage =
                                                  'Contraseña incorrecta';
                                            });
                                          } else if (error.contains(
                                            'requires-recent-login',
                                          )) {
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Por seguridad, vuelve a iniciar sesión antes de eliminar tu cuenta.',
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Error al eliminar la cuenta',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }

  static const Color defaultBackgroundColor = Color.fromARGB(255, 7, 71, 94);

  Widget buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color backgroundColor = defaultBackgroundColor,
    Color iconColor = Colors.white,
    Color titleColor = Colors.white,
    Color arrowColor = Colors.white,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: backgroundColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(color: titleColor)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: arrowColor),
        onTap: onTap,
      ),
    );
  }
}

class AppBarAccountSettings extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarAccountSettings({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: Text(
        'Configuración de cuenta',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
