import 'package:breath_bank/models/statistics_model.dart';
import 'package:breath_bank/widgets/info_row_widget.dart';
import 'package:breath_bank/widgets/stat_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/controllers/investment_menu_controller.dart';
import 'package:breath_bank/views/menu_template_screen.dart';

class InvestmentMenuScreen extends StatelessWidget {
  final InvestmentMenuController controller = InvestmentMenuController();

  InvestmentMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuTemplateScreen(
      title: 'Inversiones',
      currentIndex: 2,
      tabs: const [
        Tab(text: 'Historial'),
        Tab(text: 'Estadísticas'),
        Tab(text: 'Información'),
      ],
      tabViews: [
        _buildHistorialInversiones(),
        _buildEstadisticas(),
        _buildInformacionGeneral(),
      ],
    );
  }

  Widget _buildHistorialInversiones() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: controller.fetchDatosInversiones(),
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

            final timestamp = inversion['FechaInversión'];
            final liston = inversion['ListónInversión'];
            final resultado = inversion['ResultadoInversión'];
            final superada = inversion['Superada'];
            final tiempo = inversion['TiempoInversión'];

            return ExpansionTile(
              leading: const Icon(Icons.more_time, color: Colors.teal),
              title: Text('Inversión ${index + 1}'),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: [
                InfoRowWidget(
                  label: 'Fecha',
                  value: controller.formatFecha(timestamp),
                ),
                InfoRowWidget(
                  label: 'Listón Inversión',
                  value: liston.toString(),
                ),
                InfoRowWidget(
                  label: 'Número de respiraciones',
                  value: resultado.toString(),
                ),
                InfoRowWidget(
                  label: '¿Superada?',
                  value: superada ? 'Sí' : 'No',
                ),
                InfoRowWidget(
                  label: 'Tiempo Inversión',
                  value: '${tiempo} segundos',
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
      future: controller.fetchDatosInversiones(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay datos estadísticos disponibles.'),
          );
        }

        final datos = snapshot.data!;
        final stats = StatisticsCalculator.calculateInvestmentStatistics(
          datos,
          controller.formatFecha,
        );

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
                title: 'Total de inversiones',
                value: stats['totalInversiones'].toString(),
                icon: Icons.analytics,
                color: const Color.fromARGB(255, 0, 150, 136),
              ),
              StatCardWidget(
                title: 'Inversiones superadas',
                value: '${stats['porcentajeSuperadas']}%',
                icon: Icons.check_circle,
                color: const Color.fromARGB(255, 76, 175, 80),
              ),

              StatCardWidget(
                title: 'Listón más alto',
                value: stats['listonMasAlto'].toString(),
                icon: Icons.stacked_bar_chart,
                color: const Color.fromARGB(255, 255, 152, 0),
              ),
              StatCardWidget(
                title: 'Duración más elegida',
                value: '${stats['duracionMasElegida']}"',
                icon: Icons.timer,
                color: const Color.fromARGB(255, 63, 81, 181),
              ),

              StatCardWidget(
                title: 'Total respiraciones',
                value: stats['totalRespiraciones'].toString(),
                icon: Icons.air,
                color: const Color.fromARGB(255, 12, 81, 15),
              ),
              StatCardWidget(
                title: 'Última inversión',
                value: stats['fechaUltimaInversion'],
                icon: Icons.calendar_today,
                color: const Color.fromARGB(255, 125, 53, 8),
              ),

              StatCardWidget(
                title: 'Inversiones manuales',
                value: stats['inversionesManual'].toString(),
                icon: Icons.handyman,
                color: const Color.fromARGB(255, 63, 81, 181),
              ),

              StatCardWidget(
                title: 'Inversiones guiadas',
                value: stats['inversionesAutomaticas'].toString(),
                icon: Icons.auto_awesome,
                color: const Color.fromARGB(255, 63, 81, 181),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInformacionGeneral() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Aquí puedes gestionar tus inversiones.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () async {
                  await controller.borrarInversiones(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Borrar inversiones',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
