import 'package:breath_bank/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breath_bank/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvestmentMenuScreen extends StatefulWidget {
  const InvestmentMenuScreen({super.key});

  @override
  State<InvestmentMenuScreen> createState() => _InvestmentMenuScreenState();
}

class _InvestmentMenuScreenState extends State<InvestmentMenuScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseService db = DatabaseService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  String formatFecha(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<List<Map<String, dynamic>>> fetchDatosInversiones() async {
    List<Map<String, dynamic>> datos = [];

    final inversiones = await db.getUltimasInversiones(userId: userId);

    for (var inversion in inversiones) {
      final inversionId = inversion['id'];
      final montoInvertido = inversion['MontoInvertido'];

      datos.add({'inversionId': inversionId, 'montoInvertido': montoInvertido});
    }

    return datos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarInvestmentMenu(),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 7, 71, 94),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color.fromARGB(255, 188, 252, 245),
              unselectedLabelColor: Colors.white,
              indicatorColor: const Color.fromARGB(255, 188, 252, 245),
              tabs: const [
                Tab(text: 'Historial'),
                Tab(text: 'Estadísticas'),
                Tab(text: 'Información'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHistorialInversiones(),
                _buildEstadisticas(),
                _buildInformacionGeneral(),
              ],
            ),
          ),
          const NavigationMenu(currentIndex: 2),
        ],
      ),
    );
  }

  Widget _buildHistorialInversiones() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: db.getUltimasInversiones(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay inversiones disponibles.'));
        }

        final inversiones = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: inversiones.length,
          itemBuilder: (context, index) {
            final inversion = inversiones[index];
            //final inversionId = inversion['inversionId'];
            final montoInvertido = inversion['montoInvertido'];

            return ExpansionTile(
              leading: const Icon(Icons.money, color: Colors.green),
              title: Text('Inversión ${index + 1}'),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.attach_money, color: Colors.teal),
                    const SizedBox(width: 8),
                    Text(
                      'Monto invertido: \$${montoInvertido.toString()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEstadisticas() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchDatosInversiones(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay datos estadísticos disponibles.'),
          );
        }

        final datos = snapshot.data!;
        final montos =
            datos.map((d) => d['montoInvertido']).whereType<num>().toList();

        final totalInversiones = montos.reduce((a, b) => a + b);

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard(
                'Total Inversiones',
                totalInversiones.toString(),
                Icons.account_balance_wallet,
                Colors.green,
              ),
              // Puedes agregar más tarjetas estadísticas aquí
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          // ignore: deprecated_member_use
          colors: [color.withOpacity(0.25), color.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformacionGeneral() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text(
        'Añadir texto informativo aquí.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class AppBarInvestmentMenu extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarInvestmentMenu({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: const Text(
        'Inversiones',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
