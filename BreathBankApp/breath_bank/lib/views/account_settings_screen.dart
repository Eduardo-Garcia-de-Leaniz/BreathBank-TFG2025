import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/controllers/account_settings_controller.dart';
import 'package:breath_bank/widgets/message_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/views/base_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  final AccountSettingsController? controller;
  const AccountSettingsScreen({super.key, this.controller});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late final AccountSettingsController controller;

  String nombre = Strings.loading;
  String email = Strings.loading;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? AccountSettingsController();
    loadUserData();
  }

  Future<void> loadUserData() async {
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
          content: Text(Strings.emptyPassword),
          backgroundColor: kRedAccentColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: Strings.accountSettingsTitle,
      isScrollable: false,
      canGoBack: true,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: kPrimaryColor,
            child: Icon(Icons.person, size: 40, color: kWhiteColor),
          ),
          const SizedBox(height: 12),
          Text(
            nombre,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(email, style: const TextStyle(color: kPrimaryColor)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                buildOptionTile(
                  icon: Icons.edit_note,
                  title: Strings.consultDataTitle,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/dashboard/accountsettings/consultdata',
                    );
                  },
                ),
                buildOptionTile(
                  icon: Icons.password,
                  title: Strings.changePasswordTitle,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/dashboard/accontsettings/resetpassword',
                    );
                  },
                ),
                buildOptionTile(
                  icon: Icons.history,
                  title: Strings.deleteHistoryTitle,
                  onTap: () async {
                    await showCustomMessageDialog(
                      context: context,
                      title: Strings.deleteHistoryTitle,
                      message: Strings.deleteHistoryMessage,
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            Strings.cancel,
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
                              // ignore: use_build_context_synchronously
                              context,
                              '/dashboard',
                              (route) => false,
                            );
                          },
                          child: const Text(
                            Strings.delete,
                            style: TextStyle(color: kWhiteColor),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                buildOptionTile(
                  icon: Icons.logout,
                  title: Strings.logout,
                  backgroundColor: kRedAccentColor,
                  iconColor: kWhiteColor,
                  titleColor: kWhiteColor,
                  arrowColor: kWhiteColor,
                  onTap: () async {
                    await showCustomMessageDialog(
                      context: context,
                      title: Strings.logout,
                      message: Strings.logoutMessage,
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            Strings.cancel,
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
                              // ignore: use_build_context_synchronously
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          child: const Text(
                            Strings.logout,
                            style: TextStyle(color: kWhiteColor),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                buildOptionTile(
                  icon: Icons.delete_forever,
                  title: Strings.deleteCount,
                  backgroundColor: kRedAccentColor,
                  iconColor: kWhiteColor,
                  titleColor: kWhiteColor,
                  arrowColor: kWhiteColor,
                  onTap: () async {
                    final passwordController = TextEditingController();
                    await showCustomMessageDialog(
                      context: context,
                      title: Strings.deleteCount,
                      message: Strings.deleteCountMessage,
                      actions: [
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: Strings.password,
                            labelStyle: TextStyle(color: kPrimaryColor),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: kBackgroundColor,
                            hintText: Strings.hintPassword,
                            hintStyle: TextStyle(color: kPrimaryColor),
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
                                Strings.cancel,
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
                                  // ignore: use_build_context_synchronously
                                  context,
                                  '/',
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                Strings.delete,
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

  Widget buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color backgroundColor = kPrimaryColor,
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
