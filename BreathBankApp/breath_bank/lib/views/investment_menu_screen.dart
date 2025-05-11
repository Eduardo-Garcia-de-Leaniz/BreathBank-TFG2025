import 'package:breath_bank/widgets/info_row_widget.dart';
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
        final listones =
            datos.map((d) => d['ListónInversión']).whereType<num>().toList();

        final totalListon =
            listones.isNotEmpty ? listones.reduce((a, b) => a + b) : 0;

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              // Agrega más estadísticas si lo deseas
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
