import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/controllers/dashboard_controller.dart';
import 'package:breath_bank/widgets/info_card_widget.dart';
import 'package:breath_bank/widgets/section_header_widget.dart';
import 'package:breath_bank/widgets/list_preview_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController _controller = DashboardController();

  String? _saldo;
  String? _nivelInversor;
  String? _nombreUsuario;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await _controller.fetchUsuarioStats();
    final nombre = await _controller.fetchNombreUsuario();

    setState(() {
      _saldo = stats?['Saldo']?.toString();
      _nivelInversor = stats?['NivelInversor']?.toString();
      _nombreUsuario = nombre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido, ${_nombreUsuario ?? 'Usuario'}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(
                  title: 'Nivel de Inversor',
                  value: _nivelInversor ?? '0',
                  numberColor: const Color.fromARGB(255, 223, 190, 0),
                  textColor: const Color.fromARGB(255, 223, 190, 0),
                ),
                InfoCard(
                  title: 'Saldo',
                  value: _saldo ?? '0',
                  numberColor: Colors.green[400] ?? Colors.green,
                  textColor: Colors.green[400] ?? Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SectionHeader(
              title: 'Últimas Inversiones',
              onTap:
                  () =>
                      Navigator.pushNamed(context, '/dashboard/investmentmenu'),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _controller.fetchUltimasInversiones(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  );
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Text('No hay evaluaciones disponibles.');
                }
                return ListPreview(
                  items: snapshot.data ?? [],
                  icon: Icons.trending_up,
                  isEvaluacion: false,
                  getTitle: (item) {
                    final index = snapshot.data?.indexOf(item) ?? 0 + 1;
                    final fecha =
                        item['FechaInversión'] != null
                            ? _controller.formatFecha(item['FechaInversión'])
                            : 'Sin fecha';
                    return 'Inversión $index ($fecha)';
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            SectionHeader(
              title: 'Últimas Evaluaciones',
              onTap:
                  () =>
                      Navigator.pushNamed(context, '/dashboard/evaluationmenu'),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _controller.fetchUltimasEvaluaciones(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  );
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Text('No hay evaluaciones disponibles.');
                }
                return ListPreview(
                  items: snapshot.data!,
                  icon: Icons.assignment, // o Icons.trending_up
                  isEvaluacion: true, // o false para inversiones
                  getTitle: (item) {
                    final index = snapshot.data!.indexOf(item) + 1;
                    final fecha =
                        item['Fecha'] != null
                            ? _controller.formatFecha(
                              item['Fecha'],
                            ) // o 'FechaInversión'
                            : 'Sin fecha';
                    return 'Evaluación $index ($fecha)'; // o 'Inversión $index ($fecha)'
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationMenu(currentIndex: 1),
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment, size: 30),
          label: 'Evaluaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, size: 30),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_time, size: 30),
          label: 'Inversiones',
        ),
      ],
    );
  }
}
