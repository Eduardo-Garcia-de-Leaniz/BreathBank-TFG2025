import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/Database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final Database_service db = Database_service();
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
      appBar: AppBar_AccountSettings(),
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
                    icon: Icons.edit,
                    title: 'Modificar mis datos',
                    onTap: () {
                      // TODO: Navegar a detalles del usuario
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
                        Database_service bd = Database_service();
                        userId = FirebaseAuth.instance.currentUser!.uid;
                        try {
                          await bd.deleteUserData(userId: userId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Historial borrado correctamente'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al borrar el historial'),
                            ),
                          );
                        }
                      }
                    },
                  ),

                  buildOptionTile(
                    icon: Icons.logout,
                    title: 'Cerrar sesión',
                    backgroundColor: Colors.red,
                    iconColor: Colors.white,
                    titleColor: Colors.white,
                    arrow_color: Colors.white,
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
                        final authenticationService = Authentication_service();
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
                    arrow_color: Colors.white,
                    onTap: () {
                      // TODO: Confirmar y eliminar cuenta
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
    Color arrow_color = Colors.white,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: backgroundColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(color: titleColor)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: arrow_color),
        onTap: onTap,
      ),
    );
  }
}

class AppBar_AccountSettings extends StatelessWidget
    implements PreferredSizeWidget {
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
