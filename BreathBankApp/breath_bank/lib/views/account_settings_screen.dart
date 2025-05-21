import 'package:breath_bank/controllers/account_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/views/base_screen.dart';

const String cerrarSesion = 'Cerrar sesión';
const String cargando = 'Cargando...';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final AccountSettingsController controller = AccountSettingsController();

  String nombre = cargando;
  String email = cargando;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await controller.cargarDatosUsuario();
    if (!mounted) return;
    setState(() {
      nombre = data['nombre']!;
      email = data['email']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Configuración de cuenta',
      isScrollable: false,
      canGoBack: true,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color.fromARGB(255, 7, 71, 94),
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            nombre,
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
                            title: const Text(
                              'Borrar historial',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
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
                                child: const Text(
                                  'Borrar',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 7, 71, 94),
                                  ),
                                ),
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                              ),
                              TextButton(
                                child: const Text(
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
                      try {
                        await controller.borrarHistorial();
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/dashboard',
                          (route) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Historial borrado correctamente'),
                          ),
                        );
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al borrar el historial'),
                          ),
                        );
                      }
                    }
                  },
                ),
                buildOptionTile(
                  icon: Icons.logout,
                  title: cerrarSesion,
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
                            title: const Text(
                              cerrarSesion,
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
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
                                child: const Text(
                                  cerrarSesion,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 7, 71, 94),
                                  ),
                                ),
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                              ),
                              TextButton(
                                child: const Text(
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
                      try {
                        await controller.cerrarSesion();
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sesión cerrada correctamente'),
                          ),
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al cerrar sesión'),
                          ),
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
                                        () => Navigator.of(context).pop(),
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
                                      await controller.eliminarCuenta(
                                        password: password,
                                        onError: (msg) {
                                          if (msg == 'requires-recent-login') {
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
                                            setState(() {
                                              errorMessage = msg;
                                            });
                                          }
                                        },
                                        onSuccess: () {
                                          Navigator.of(context).pop();
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
                                        },
                                      );
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
