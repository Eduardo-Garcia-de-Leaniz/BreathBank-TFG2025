import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/controllers/account_settings_controller.dart';
import 'package:breath_bank/widgets/message_dialog_widget.dart';
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

  void passwordIsEmpty(String password) {
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña no puede estar vacía.'),
          backgroundColor: kRedAccentColor,
        ),
      );
    }
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
                    await showCustomMessageDialog(
                      context: context,
                      title: 'Borrar historial',
                      message:
                          '¿Estás seguro de que deseas borrar tu historial de inversiones y evaluaciones? Esta acción no se puede deshacer. Tu nivel de inversor y tu saldo se restablecerán a 0.',
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: kBackgroundColor),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kRedAccentColor,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await controller.borrarHistorial(context);
                            if (!mounted) return;
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/dashboard',
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Borrar',
                            style: TextStyle(color: kWhiteColor),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                buildOptionTile(
                  icon: Icons.logout,
                  title: cerrarSesion,
                  backgroundColor: kRedAccentColor,
                  iconColor: kWhiteColor,
                  titleColor: kWhiteColor,
                  arrowColor: kWhiteColor,
                  onTap: () async {
                    await showCustomMessageDialog(
                      context: context,
                      title: 'Cerrar sesión',
                      message: '¿Estás seguro de que deseas cerrar sesión?',
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: kBackgroundColor),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kRedAccentColor,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await controller.cerrarSesion(context);
                            if (!mounted) return;
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Cerrar sesión',
                            style: TextStyle(color: kWhiteColor),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                buildOptionTile(
                  icon: Icons.delete_forever,
                  title: 'Eliminar cuenta',
                  backgroundColor: kRedAccentColor,
                  iconColor: kWhiteColor,
                  titleColor: kWhiteColor,
                  arrowColor: kWhiteColor,
                  onTap: () async {
                    final passwordController = TextEditingController();
                    await showCustomMessageDialog(
                      context: context,
                      title: 'Borrar cuenta',
                      message:
                          '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer. Tu historial de inversiones y evaluaciones se borrará permanentemente.',
                      actions: [
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: const TextStyle(color: kPrimaryColor),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: kBackgroundColor,
                            hintText: 'Ingresa tu contraseña',
                            hintStyle: const TextStyle(color: kPrimaryColor),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: kBackgroundColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kRedAccentColor,
                              ),
                              onPressed: () async {
                                passwordIsEmpty(passwordController.text);

                                Navigator.of(context).pop();
                                await controller.eliminarCuenta(
                                  password: passwordController.text,
                                  context: context,
                                );
                                if (!mounted) return;
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/',
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Borrar',
                                style: TextStyle(color: kWhiteColor),
                              ),
                            ),
                          ],
                        ),
                      ],
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
