import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/Database_service.dart';

class DashboardScreen extends StatelessWidget {
  final Database_service db = Database_service();
  final Authentication_service authenticationService = Authentication_service();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<String?> obtenerNombreUsuario() async {
    return await db.getNombreUsuario(userId: userId);
  }

  Future<String?> obtenerNivelInversor() async {
    final stats = await db.getUsuarioStats(userId: userId);
    return stats?['nivelInversor'] as String?;
  }

  Future<String?> obtenerSaldo() async {
    final stats = await db.getUsuarioStats(userId: userId);
    return stats?['saldo'] as String?;
  }

  String formatFecha(Timestamp timestamp) {
    final date = timestamp.toDate();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar_Dashboard(),
        backgroundColor: const Color.fromARGB(255, 188, 252, 245),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future: obtenerNombreUsuario(),
                builder: (context, snapshot) {
                  return Text(
                    'Bienvenido, ${snapshot.data ?? 'Usuario'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoCard(
                    title: 'Nivel de Inversor',
                    futureValue: obtenerNivelInversor(),
                    highlight: true,
                  ),
                  _buildInfoCard(
                    title: 'Saldo',
                    futureValue: obtenerSaldo(),
                    highlight: true,
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildSectionHeader(
                title: 'Últimas Evaluaciones',
                onTap: () => Navigator.pushNamed(context, '/progress'),
              ),
              _buildListPreviewEvaluaciones(
                itemsFuture: db.getUltimasEvaluaciones(userId: userId),
                icon: Icons.assignment,
              ),
              SizedBox(height: 20),
              _buildSectionHeader(
                title: 'Últimas Inversiones',
                onTap: () => Navigator.pushNamed(context, '/investments'),
              ),
              _buildListPreview(
                itemsFuture: db.getUltimasInversiones(userId: userId),
                icon: Icons.trending_up,
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
                  Navigator.pushNamed(context, '/progress');
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
                icon: Icon(Icons.add_box, size: 30),
                label: 'Inversiones',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart, size: 30),
                label: 'Progreso',
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/evaluation');
          },
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required Future<String?> futureValue,
    bool highlight = false,
  }) {
    return FutureBuilder<String?>(
      future: futureValue,
      builder: (context, snapshot) {
        return Card(
          color: highlight ? Colors.teal[100] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            width: 160,
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.teal[800],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  snapshot.data ?? 'Cargando...',
                  style: TextStyle(
                    fontSize: 30, // Aumentar tamaño para resaltar el número
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900], // Cambiar color para resaltar más
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(icon: Icon(Icons.arrow_forward), onPressed: onTap),
      ],
    );
  }

  Widget _buildListPreviewEvaluaciones({
    required Future<List<Map<String, dynamic>>> itemsFuture,
    required IconData icon,
  }) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return Text('No hay evaluaciones disponibles.');
        }

        return Column(
          children:
              snapshot.data!.map((item) {
                //final nivelUsuario = item['NivelInversorFinal'] ?? 'Sin nivel';
                final fechaEvaluacion =
                    item['Fecha'] != null
                        ? formatFecha(item['Fecha'] as Timestamp)
                        : 'Sin fecha';

                return ListTile(
                  leading: Icon(icon, color: Colors.teal),
                  title: Text(
                    'Evaluación ${snapshot.data!.indexOf(item) + 1} ($fechaEvaluacion)',
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildListPreview({
    required Future<List<Map<String, dynamic>>> itemsFuture,
    required IconData icon,
  }) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return Text('No hay datos disponibles.');
        }

        return Column(
          children:
              snapshot.data!.map((item) {
                return ListTile(
                  leading: Icon(icon, color: Colors.teal),
                  title: Text(item['titulo'] ?? 'Sin título'),
                  subtitle: Text('Resultado: ${item['resultado']}'),
                );
              }).toList(),
        );
      },
    );
  }
}

class AppBar_Dashboard extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60);
  final Authentication_service authenticationService = Authentication_service();

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
      title: Text(
        'Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
        ),
        IconButton(
          icon: Icon(Icons.account_circle, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
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
                            color: Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                      TextButton(
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ],
                  ),
            );

            if (confirmed == true && await logout()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sesión cerrada correctamente')),
              );
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            } else if (confirmed == true) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error al cerrar sesión')));
            }
          },
        ),
      ],
    );
  }
}
