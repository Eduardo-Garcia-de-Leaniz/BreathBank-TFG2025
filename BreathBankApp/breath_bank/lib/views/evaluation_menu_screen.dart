import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/controllers/evaluation_menu_controller.dart';
import 'package:breath_bank/views/menu_template_screen.dart';

class EvaluationMenuScreen extends StatelessWidget {
  final EvaluationMenuController controller = EvaluationMenuController();

  EvaluationMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuTemplateScreen(
      title: 'Evaluaciones',
      currentIndex: 0,
      tabs: const [
        Tab(text: 'Historial'),
        Tab(text: 'Estadísticas'),
        Tab(text: 'Información'),
      ],
      tabViews: [
        _buildHistorialEvaluaciones(),
        _buildEstadisticas(),
        _buildInformacionGeneral(),
      ],
    );
  }

  Widget _buildHistorialEvaluaciones() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: controller.fetchEvaluaciones(),
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
            final nivelFinal = evaluacion['NivelInversorFinal'] ?? 'N/A';

            return ExpansionTile(
              leading: const Icon(Icons.assignment, color: Colors.teal),
              title: Text('Evaluación ${index + 1}'),
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
                FutureBuilder<Map<String, dynamic>?>(
                  future: controller.fetchResultadosPruebas(evaluacionId),
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
                                'Prueba ${resultados.keys.toList().indexOf(entry.key) + 1}',
                              ),
                              dense: true,
                              trailing: Text(entry.value.toString()),
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
      future: controller.fetchDatosEstadisticos(),
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
          future: controller.fetchEvaluaciones(),
          builder: (context, snapshotFechas) {
            String fechaUltima = 'N/A';
            if (snapshotFechas.hasData && snapshotFechas.data!.isNotEmpty) {
              final timestamp =
                  snapshotFechas.data!.last['Fecha'] as Timestamp?;
              if (timestamp != null) {
                fechaUltima = controller.formatFecha(timestamp);
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
    return const Center(child: Text('Añadir texto informativo aquí.'));
  }
}
