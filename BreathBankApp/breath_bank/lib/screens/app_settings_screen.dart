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
              backgroundColor: Color.fromARGB(255, 7, 71, 94),
              child: Icon(Icons.settings, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Configuración de la App',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 7, 71, 94),
              ),
            ),
            const SizedBox(height: 24),

            // Lista de opciones de configuración
            Expanded(
              child: ListView(
                children: [
                  buildOptionTile(
                    icon: Icons.notifications,
                    title: 'Notificaciones',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/dashboard/appsettings/notifications',
                      );
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.palette,
                    title: 'Tema de la app',
                    onTap: () {
                      Navigator.pushNamed(context, '/app/settings/theme');
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.language,
                    title: 'Idioma',
                    onTap: () {
                      Navigator.pushNamed(context, '/app/settings/language');
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.info_outline,
                    title: 'Acerca de la app',
                    onTap: () {
                      Navigator.pushNamed(context, '/app/settings/about');
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacidad',
                    onTap: () {
                      Navigator.pushNamed(context, '/app/settings/privacy');
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.help_outline,
                    title: 'Ayuda y soporte',
                    onTap: () {
                      Navigator.pushNamed(context, '/app/settings/help');
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

class AppBarAppSettings extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAppSettings({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: const Text(
        'Configuración de la app',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
