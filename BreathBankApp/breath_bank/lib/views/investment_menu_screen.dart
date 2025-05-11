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
      future: controller.fetchInversiones(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay inversiones disponibles.'));
        }

        final inversiones = snapshot.data!;
        return ListView.builder(
          itemCount: inversiones.length,
          itemBuilder: (context, index) {
            final inversion = inversiones[index];
            return ListTile(
              title: Text('Inversión ${index + 1}'),
              subtitle: Text('Resultado: ${inversion['ResultadoInversión']}'),
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
          return const Center(child: Text('No hay estadísticas disponibles.'));
        }

        // Renderiza las estadísticas
        return Container();
      },
    );
  }

  Widget _buildInformacionGeneral() {
    return const Center(child: Text('Añadir texto informativo aquí.'));
  }
}
