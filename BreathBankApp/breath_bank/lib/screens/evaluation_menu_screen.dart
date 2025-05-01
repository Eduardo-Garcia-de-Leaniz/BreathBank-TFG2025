import 'package:breath_bank/screens/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EvaluationMenuScreen extends StatefulWidget {
  const EvaluationMenuScreen({super.key});

  @override
  State<EvaluationMenuScreen> createState() => _EvaluationMenuScreenState();
}

class _EvaluationMenuScreenState extends State<EvaluationMenuScreen>
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

  Future<List<Map<String, dynamic>>> fetchDatosEstadisticos() async {
    List<Map<String, dynamic>> datos = [];

    final evaluaciones = await db.getUltimasEvaluaciones(userId: userId);

    for (var evaluacion in evaluaciones) {
      final evaluacionId = evaluacion['id'];
      final nivelInversor = evaluacion['NivelInversorFinal'];

      final resultados = await db.getResultadosPruebas(
        userId: userId,
        evaluacionId: evaluacionId,
      );

      if (resultados != null && resultados.isNotEmpty) {
        // Recolectamos los resultados exactamente igual que en historial
        final prueba1 =
            resultados.containsKey('ResultadoPrueba1')
                ? resultados['ResultadoPrueba1']
                : null;
        final prueba2 =
            resultados.containsKey('ResultadoPrueba2')
                ? resultados['ResultadoPrueba2']
                : null;
        final prueba3 =
            resultados.containsKey('ResultadoPrueba3')
                ? resultados['ResultadoPrueba3']
                : null;

        datos.add({
          'nivel': nivelInversor,
          'prueba1': prueba1,
          'prueba2': prueba2,
          'prueba3': prueba3,
        });
      }
    }

    return datos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarEvaluationMenu(),
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
                _buildHistorialEvaluaciones(),
                _buildEstadisticas(),
                _buildInformacionGeneral(),
              ],
            ),
          ),
          const NavigationMenu(currentIndex: 0),
        ],
      ),
    );
  }

  Widget _buildHistorialEvaluaciones() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: db.getUltimasEvaluaciones(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay evaluaciones disponibles.'));
        }

        final evaluaciones = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: evaluaciones.length,
          itemBuilder: (context, index) {
            final evaluacion = evaluaciones[index];
            final evaluacionId = evaluacion['id'];
            final timestamp = evaluacion['Fecha'] as Timestamp?;
            final fechaEvaluacion = timestamp?.toDate();
            final fechaTexto =
                timestamp != null ? formatFecha(timestamp) : 'Sin fecha';
            final nivelFinal = evaluacion['NivelInversorFinal'] ?? 'N/A';

            return ExpansionTile(
              leading: const Icon(Icons.assignment, color: Colors.teal),
              title: Text('Evaluación ${index + 1} ($fechaTexto)'),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Nivel de inversor: $nivelFinal',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Resultados de pruebas:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                if (fechaEvaluacion != null)
                  FutureBuilder<Map<String, dynamic>?>(
                    future: db.getResultadosPruebas(
                      userId: userId,
                      evaluacionId: evaluacionId,
                    ),
                    builder: (context, resultadoSnapshot) {
                      if (resultadoSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        );
                      }

                      final resultados = resultadoSnapshot.data;

                      if (resultados == null || resultados.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text('Sin resultados disponibles.'),
                        );
                      }

                      return Column(
                        children:
                            resultados.entries.map((entry) {
                              return ListTile(
                                leading: Text(
                                  ' Resultado Prueba ${resultados.keys.toList().indexOf(entry.key) + 1}',
                                ),
                                dense: true,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [Text(entry.value.toString())],
                                ),
                              );
                            }).toList(),
                      );
                    },
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
      future: fetchDatosEstadisticos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay datos estadísticos disponibles.'),
          );
        }

        final datos = snapshot.data!;
        final niveles = datos.map((d) => d['nivel']).whereType<int>().toList();
        final prueba1 =
            datos.map((d) => d['prueba1']).whereType<num>().toList();
        final prueba2 =
            datos.map((d) => d['prueba2']).whereType<num>().toList();
        final prueba3 =
            datos.map((d) => d['prueba3']).whereType<num>().toList();

        final mejorNivel =
            niveles.isNotEmpty
                ? niveles.reduce((a, b) => a > b ? a : b)
                : 'N/A';
        final mejorP1 =
            prueba1.isNotEmpty
                ? prueba1.reduce((a, b) => a < b ? a : b)
                : 'N/A';
        final mejorP2 =
            prueba2.isNotEmpty
                ? prueba2.reduce((a, b) => a > b ? a : b)
                : 'N/A';
        final mejorP3 =
            prueba3.isNotEmpty
                ? prueba3.reduce((a, b) => a > b ? a : b)
                : 'N/A';
        final promedioNivel =
            niveles.isNotEmpty
                ? (niveles.reduce((a, b) => a + b) / niveles.length)
                    .toStringAsFixed(1)
                : 'N/A';

        final penultimoNivel =
            niveles.length > 1 ? niveles[niveles.length - 2] : null;
        final ultimoNivel = niveles.isNotEmpty ? niveles.last : null;
        final cambioNivel =
            (penultimoNivel != null && ultimoNivel != null)
                ? (ultimoNivel - penultimoNivel)
                : null;
        final cambioNivelTexto =
            cambioNivel != null
                ? (cambioNivel >= 0 ? '+ $cambioNivel' : '$cambioNivel')
                : 'N/A';

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: db.getUltimasEvaluaciones(userId: userId),
          builder: (context, snapshotFechas) {
            String fechaUltima = 'N/A';
            if (snapshotFechas.hasData && snapshotFechas.data!.isNotEmpty) {
              final timestamp =
                  snapshotFechas.data!.last['Fecha'] as Timestamp?;
              if (timestamp != null) {
                fechaUltima = formatFecha(timestamp);
              }
            }

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
                    'Mejor nivel inversor',
                    mejorNivel.toString(),
                    Icons.emoji_events,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    'Total de evaluaciones',
                    datos.length.toString(),
                    Icons.analytics,
                    Colors.teal,
                  ),
                  _buildStatCard(
                    'Mejor Resultado Prueba 1',
                    mejorP1.toString(),
                    Icons.looks_one_sharp,
                    Colors.green,
                  ),
                  _buildStatCard(
                    'Última evaluación',
                    fechaUltima,
                    Icons.calendar_today,
                    Colors.brown,
                  ),
                  _buildStatCard(
                    'Mejor Resultado Prueba 2',
                    mejorP2.toString(),
                    Icons.looks_two_sharp,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    'Promedio de nivel',
                    promedioNivel,
                    Icons.leaderboard,
                    Colors.indigo,
                  ),
                  _buildStatCard(
                    'Mejor Resultado Prueba 3',
                    mejorP3.toString(),
                    Icons.looks_3_sharp,
                    Colors.purple,
                  ),
                  _buildStatCard(
                    'Variación último nivel',
                    cambioNivelTexto,
                    Icons.trending_up,
                    Colors.deepOrange,
                  ),
                ],
              ),
            );
          },
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

class AppBarEvaluationMenu extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarEvaluationMenu({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: const Text(
        'Evaluaciones',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
