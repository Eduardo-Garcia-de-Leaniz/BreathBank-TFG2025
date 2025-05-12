import 'package:breath_bank/models/statistics_model.dart';
import 'package:breath_bank/widgets/stat_card_widget.dart';
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
        final stats = StatisticsCalculator.calculateEvaluationStatistics(datos);

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              StatCardWidget(
                title: 'Mejor nivel inversor',
                value: stats['mejorNivel'].toString(),
                icon: Icons.emoji_events,
                color: const Color.fromARGB(255, 255, 152, 0),
              ),
              StatCardWidget(
                title: 'Total de evaluaciones',
                value: stats['totalEvaluaciones'].toString(),
                icon: Icons.analytics,
                color: const Color.fromARGB(255, 0, 150, 136),
              ),
              StatCardWidget(
                title: 'Promedio de nivel',
                value: stats['promedioNivel'].toString(),
                icon: Icons.leaderboard,
                color: const Color.fromARGB(255, 63, 81, 181),
              ),
              StatCardWidget(
                title: 'Mejor Resultado Prueba 1',
                value: stats['mejorP1'].toString(),
                icon: Icons.looks_one_sharp,
                color: const Color.fromARGB(255, 76, 175, 80),
              ),

              StatCardWidget(
                title: 'Última evaluación',
                value: stats['fechaUltimaEvaluacion'].toString(),
                icon: Icons.calendar_today,
                color: const Color.fromARGB(255, 125, 53, 8),
              ),

              StatCardWidget(
                title: 'Mejor Resultado Prueba 2',
                value: stats['mejorP2'].toString(),
                icon: Icons.looks_two_sharp,
                color: const Color.fromARGB(255, 33, 150, 243),
              ),
              StatCardWidget(
                title: 'Variación del nivel',
                value: stats['variacionNivel'].toString(),
                icon: Icons.trending_up,
                color: const Color.fromARGB(255, 255, 152, 0),
              ),
              StatCardWidget(
                title: 'Mejor Resultado Prueba 3',
                value: stats['mejorP3'].toString(),
                icon: Icons.looks_3_sharp,
                color: const Color.fromARGB(255, 156, 39, 176),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInformacionGeneral() {
    return const Center(child: Text('Añadir texto informativo aquí.'));
  }
}
