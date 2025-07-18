import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarAppSettings(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.settings, size: 40, color: kWhiteColor),
            ),
            const SizedBox(height: 12),
            const Text(
              'Configuración de la App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: const Text(
                'Notificaciones y Personalizar interfaz estarán disponibles pronto.',
                style: TextStyle(
                  fontSize: 13,
                  color: kPrimaryColor,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: [
                  buildOptionTile(
                    icon: Icons.notifications,
                    title: 'Notificaciones',
                    disabled: true,
                    onTap: () {},
                  ),
                  buildOptionTile(
                    icon: Icons.palette,
                    title: 'Personalizar interfaz',
                    disabled: true,
                    onTap: () {},
                  ),
                  buildOptionTile(
                    icon: Icons.info_outline,
                    title: 'Acerca de la app',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/dashboard/appsettings/info',
                      );
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacidad',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/dashboard/appsettings/privacysettings',
                      );
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.gavel,
                    title: 'Aviso legal',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/dashboard/appsettings/legaladvice',
                      );
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.help,
                    title: 'Ayuda y soporte',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/dashboard/appsettings/helpsupport',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: kBackgroundColor,
    );
  }

  Widget buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool disabled = false,
    Color backgroundColor = kPrimaryColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: disabled ? kDisabledColor : backgroundColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: kWhiteColor),
        title: Text(title, style: const TextStyle(color: kWhiteColor)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: kWhiteColor,
        ),
        onTap: onTap,
      ),
    );
  }
}

class AppBarAppSettings extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAppSettings({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: kBackgroundColor),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      backgroundColor: kPrimaryColor,
      title: const Text(
        'Configuración de la app',
        style: TextStyle(
          color: kWhiteColor,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(color: kBackgroundColor),
    );
  }
}
