import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/database_service.dart';

String formatFecha(Timestamp timestamp) {
  final date = timestamp.toDate();
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  return '$day/$month/$year';
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseService db = DatabaseService();

  final AuthenticationService authenticationService = AuthenticationService();

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  String? saldo;
  String? nivelInversor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recargarDatos();
  }

  Future<void> _recargarDatos() async {
    final stats = await db.getUsuarioStats(userId: userId);
    setState(() {
      saldo = stats?['Saldo']?.toString();
      nivelInversor = stats?['NivelInversor']?.toString();
    });
  }

  Future<String?> obtenerNombreUsuario() async {
    return await db.getNombreUsuario(userId: userId);
  }

  Future<String?> obtenerNivelInversor() async {
    final stats = await db.getUsuarioStats(userId: userId);
    final nivel = stats?['NivelInversor'];
    return nivel?.toString();
  }

  Future<String?> obtenerSaldo() async {
    final stats = await db.getUsuarioStats(userId: userId);
    final saldo = stats?['Saldo'];
    return saldo?.toString();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBarDashboard(),
        backgroundColor: const Color.fromARGB(255, 188, 252, 245),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future: obtenerNombreUsuario(),
                builder: (context, snapshot) {
                  return Text(
                    'Bienvenido, ${snapshot.data ?? 'Usuario'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildInfoCard(
                    title: 'Nivel de Inversor',
                    value: nivelInversor ?? '0',
                    numberColor: const Color.fromARGB(255, 223, 190, 0),
                    textColor: const Color.fromARGB(255, 243, 221, 96),
                  ),
                  buildInfoCard(
                    title: 'Saldo',
                    value: saldo ?? '0',
                    numberColor: Colors.green[400] ?? Colors.green,
                    textColor: Colors.green[200] ?? Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              buildSectionHeader(
                title: 'Últimas Inversiones',
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      '/dashboard/investmentmenu',
                    ),
              ),
              buildListPreviewInversiones(
                itemsFuture: db.getUltimasInversiones(userId: userId),
                icon: Icons.trending_up,
              ),
              const SizedBox(height: 20),
              buildSectionHeader(
                title: 'Últimas Evaluaciones',
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      '/dashboard/evaluationmenu',
                    ),
              ),
              buildListPreviewEvaluaciones(
                itemsFuture: db.getUltimasEvaluaciones(userId: userId),
                icon: Icons.assignment,
              ),
            ],
          ),
        ),
        bottomNavigationBar: const SizedBox(
          height: 70,
          child: NavigationMenu(currentIndex: 1),
        ),

        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 5,
              right: 1,
              child: FloatingActionButton(
                heroTag: 'fabEvaluacion',
                onPressed: () {
                  Navigator.pushNamed(context, '/evaluation');
                },
                tooltip: 'Nueva evaluación',
                child: const Icon(Icons.assignment),
              ),
            ),
            Positioned(
              bottom: 75, // Altura ajustada para no solaparse con el otro botón
              right: 1,
              child: FloatingActionButton(
                heroTag: 'fabInversion',
                onPressed: () async {
                  Navigator.pushNamed(context, '/dashboard/newinvestmentmenu');
                },
                tooltip: 'Nueva inversión',
                child: const Icon(Icons.more_time),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required String title,
    required String value,
    required Color numberColor,
    required Color textColor,
  }) {
    int maxValue = title == 'Nivel de Inversor' ? 11 : 100;
    double valueDouble = double.tryParse(value) ?? 0.0;

    return Card(
      color: const Color.fromARGB(255, 7, 71, 94),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 130,
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  valueDouble.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: numberColor,
                  ),
                ),
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: valueDouble / maxValue,
                      backgroundColor: Colors.white24,
                      color: numberColor,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 12,
                            color: numberColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          maxValue.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: numberColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildSectionHeader({
  required String title,
  required VoidCallback onTap,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      TextButton(
        onPressed: onTap,
        child: Text(
          title == 'Últimas Evaluaciones'
              ? 'Ver evaluaciones'
              : 'Ver inversiones',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.teal[800],
          ),
        ),
      ),
    ],
  );
}

Widget buildListPreviewEvaluaciones({
  required Future<List<Map<String, dynamic>>> itemsFuture,
  required IconData icon,
}) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: itemsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError ||
          !snapshot.hasData ||
          snapshot.data!.isEmpty) {
        return const Text('No hay evaluaciones disponibles.');
      }

      return ExpandableListPreview(
        items: snapshot.data!,
        icon: icon,
        isEvaluacion: true,
        getTitle: (item) {
          final index = snapshot.data!.indexOf(item) + 1;
          final fecha =
              item['Fecha'] != null
                  ? formatFecha(item['Fecha'] as Timestamp)
                  : 'Sin fecha';
          return 'Evaluación $index ($fecha)';
        },
      );
    },
  );
}

Widget buildListPreviewInversiones({
  required Future<List<Map<String, dynamic>>> itemsFuture,
  required IconData icon,
}) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: itemsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError ||
          !snapshot.hasData ||
          snapshot.data!.isEmpty) {
        return const Text('No hay inversiones disponibles.');
      }

      return ExpandableListPreview(
        items: snapshot.data!,
        icon: icon,
        isEvaluacion: false,
        getTitle: (item) {
          final index = snapshot.data!.indexOf(item) + 1;
          final fecha =
              item['FechaInversión'] != null
                  ? formatFecha(item['FechaInversión'] as Timestamp)
                  : 'Sin fecha';
          return 'Inversión $index ($fecha)';
        },
      );
    },
  );
}

class ExpandableListPreview extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final IconData icon;
  final bool isEvaluacion;
  final String Function(Map<String, dynamic>) getTitle;
  final String? Function(Map<String, dynamic>)? getSubtitle;

  const ExpandableListPreview({
    super.key,
    required this.items,
    required this.icon,
    required this.isEvaluacion,
    required this.getTitle,
    this.getSubtitle,
  });

  @override
  State<ExpandableListPreview> createState() => _ExpandableListPreviewState();
}

class _ExpandableListPreviewState extends State<ExpandableListPreview> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsToShow = expanded ? widget.items : widget.items.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...itemsToShow.map(
          (item) => ListTile(
            leading: Icon(widget.icon, color: Colors.teal),
            title: Text(widget.getTitle(item)),
            subtitle:
                widget.getSubtitle != null
                    ? Text(widget.getSubtitle!(item) ?? '')
                    : null,
          ),
        ),
        if (widget.items.length > 3)
          TextButton.icon(
            onPressed: () => setState(() => expanded = !expanded),
            icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
            label: Text(
              expanded ? 'Ver menos' : 'Ver más',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.teal[800],
              ),
            ),
          ),
      ],
    );
  }
}

class NavigationMenu extends StatelessWidget {
  final int currentIndex;

  const NavigationMenu({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      selectedItemColor: const Color.fromARGB(255, 188, 252, 245),
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/dashboard/evaluationmenu');
            break;
          case 1:
            Navigator.pushNamed(context, '/dashboard');
            break;
          case 2:
            Navigator.pushNamed(context, '/dashboard/investmentmenu');
            break;
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.assignment, size: 30),
          label: 'Evaluaciones',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, size: 30),
          label: 'Dashboard',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.more_time, size: 30),
          label: 'Inversiones',
        ),
      ],
    );
  }
}

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
