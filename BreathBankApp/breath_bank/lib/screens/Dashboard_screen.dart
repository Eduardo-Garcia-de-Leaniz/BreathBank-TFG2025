import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/Database_service.dart';

class DashboardScreen extends StatelessWidget {
  Database_service db = Database_service();

  Future<String?> obtenerNombreUsuario() async {
    return await db.getNombreUsuario(
      userId: authenticationService.value.currentUser!.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar_Dashboard(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<String?>(
                  future: obtenerNombreUsuario(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Cargando...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error al cargar el nombre',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return Text(
                        'Bienvenido a tu Dashboard, ${snapshot.data ?? 'Usuario'}!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            backgroundColor: const Color.fromARGB(255, 7, 71, 94),
            selectedItemColor: const Color.fromARGB(255, 188, 252, 245),
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            unselectedItemColor: Colors.white,
            currentIndex: 1,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/evaluation');
                  break;
                case 1:
                  break;
                case 2:
                  Navigator.pushNamed(context, '/investments');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/information');
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment, size: 30),
                label: 'Evaluaciones',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard, size: 30),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart, size: 30),
                label: 'Progreso',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info, size: 30),
                label: 'Información',
              ),
            ],
          ),
        ),

        backgroundColor: const Color.fromARGB(255, 188, 252, 245),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/evaluation');
          },
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

class AppBar_Dashboard extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60);
  Authentication_service authenticationService = Authentication_service();

  Future<bool> logout() async {
    try {
      await authenticationService.signOut();
    } on FirebaseAuthException catch (e) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: Text(
        'Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/settings'); // Navigate to settings
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/profile'); // Navigate to profile
          },
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 7, 71, 94),
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
                          color: const Color.fromARGB(255, 7, 71, 94),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        if (await logout()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sesión cerrada correctamente'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (Route<dynamic> route) => false,
                          );
                          Navigator.pushNamed(context, '/');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al cerrar sesión'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
