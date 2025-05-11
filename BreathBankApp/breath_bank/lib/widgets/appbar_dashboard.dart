import 'package:breath_bank/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBarDashboard extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  final AuthenticationService authenticationService = AuthenticationService();

  AppBarDashboard({super.key});

  Future<bool> logout() async {
    try {
      await authenticationService.signOut();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: const Text(
        'Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed:
              () => Navigator.pushNamed(context, '/dashboard/appsettings'),
        ),
        IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          onPressed:
              () => Navigator.pushNamed(context, '/dashboard/accountsettings'),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.red),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                    title: const Text(
                      'Cerrar sesión',
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
                          'Cerrar sesión',
                          style: TextStyle(
                            color: Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                      TextButton(
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ],
                  ),
            );

            if (confirmed == true && await logout()) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sesión cerrada correctamente')),
              );
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            } else if (confirmed == true) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al cerrar sesión')),
              );
            }
          },
        ),
      ],
    );
  }
}
