import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/controllers/dashboard_controller.dart';
import 'package:breath_bank/database_service.dart';
import 'package:breath_bank/widgets/message_dialog_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBarDashboard extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  final AuthenticationService authenticationService = AuthenticationService();
  final DatabaseService db = DatabaseService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final DashboardController controller = DashboardController();

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
          icon: const Icon(Icons.logout, color: kRedAccentColor),
          onPressed: () async {
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
      ],
    );
  }
}
