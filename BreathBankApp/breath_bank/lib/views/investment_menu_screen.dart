import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/models/statistics_model.dart';
import 'package:breath_bank/widgets/info_row_widget.dart';
import 'package:breath_bank/widgets/investment_info_widget.dart';
import 'package:breath_bank/widgets/message_dialog_widget.dart';
import 'package:breath_bank/widgets/stat_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/controllers/investment_menu_controller.dart';
import 'package:breath_bank/views/menu_template_screen.dart';

class InvestmentMenuScreen extends StatelessWidget {
  final InvestmentMenuController controller = InvestmentMenuController();

  InvestmentMenuScreen({super.key});

  bool isLoading(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return true;
    }
    return false;
  }

  bool isError(snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MenuTemplateScreen(
      title: Strings.pluralInvestment,
      currentIndex: 2,
      tabs: const [
        Tab(text: Strings.tabHistorial),
        Tab(text: Strings.tabEstadisticas),
        Tab(text: Strings.tabInformacion),
      ],
      tabViews: [historialInversiones(), estadisticas(), informacionGeneral()],
    );
  }

  Widget historialInversiones() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: controller.fetchDatosInversiones(),
      builder: (context, snapshot) {
        if (isLoading(context, snapshot)) {
          return const Center(child: CircularProgressIndicator());
        } else if (isError(snapshot)) {
          return const Center(child: Text(Strings.noData));
        }

        final inversiones = snapshot.data!;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: inversiones.length,
                itemBuilder: (context, index) {
                  final inversion = inversiones[index];

                  final timestamp = inversion['FechaInversión'];
                  final liston = inversion['ListónInversión'];
                  final resultado = inversion['ResultadoInversión'];
                  final superada = inversion['Superada'];
                  final tiempo = inversion['TiempoInversión'];
                  final tipoInversion = inversion['TipoInversión'];

                  return ExpansionTile(
                    leading: const Icon(Icons.more_time, color: Colors.teal),
                    title: Text('${Strings.investmentTitle} ${index + 1}'),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      InfoRowWidget(
                        label: Strings.date,
                        value: controller.formatFecha(timestamp),
                      ),
                      InfoRowWidget(
                        label: Strings.investmentType,
                        value: tipoInversion,
                      ),
                      InfoRowWidget(
                        label: Strings.investmentBar,
                        value: liston.toString(),
                      ),
                      InfoRowWidget(
                        label: Strings.numBreaths,
                        value: resultado.toString(),
                      ),
                      InfoRowWidget(
                        label: Strings.investmentPassed,
                        value: superada ? 'Sí' : 'No',
                      ),
                      InfoRowWidget(
                        label: Strings.investmentTime,
                        value: '$tiempo segundos',
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed:
                        inversiones.isEmpty
                            ? null
                            : () async {
                              await showCustomMessageDialog(
                                context: context,
                                title: Strings.deleteInvestmentsTitle,
                                message: Strings.deleteInvestmentsMessage,
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text(
                                      Strings.cancel,
                                      style: TextStyle(color: kBackgroundColor),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kRedAccentColor,
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await controller.borrarInversiones(
                                        context,
                                      );
                                      if (!context.mounted) return;
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/dashboard',
                                        (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      Strings.delete,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kRedAccentColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      Strings.deleteInvestmentsTitle,
                      style: TextStyle(fontSize: 15, color: kWhiteColor),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget estadisticas() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: controller.fetchDatosInversiones(),
      builder: (context, snapshot) {
        if (isLoading(context, snapshot)) {
          return const Center(child: CircularProgressIndicator());
        } else if (isError(snapshot)) {
          return const Center(child: Text(Strings.noData));
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
                title: Strings.totalInvestments,
                value: stats['totalInversiones'].toString(),
                icon: Icons.analytics,
                color: const Color.fromARGB(255, 0, 150, 136),
              ),
              StatCardWidget(
                title: Strings.passedInvestments,
                value: '${stats['porcentajeSuperadas']}%',
                icon: Icons.check_circle,
                color: const Color.fromARGB(255, 76, 175, 80),
              ),

              StatCardWidget(
                title: Strings.bestBar,
                value: stats['listonMasAlto'].toString(),
                icon: Icons.stacked_bar_chart,
                color: const Color.fromARGB(255, 255, 152, 0),
              ),
              StatCardWidget(
                title: Strings.mostSelectedDuration,
                value: '${stats['duracionMasElegida']}"',
                icon: Icons.timer,
                color: const Color.fromARGB(255, 63, 81, 181),
              ),

              StatCardWidget(
                title: Strings.totalBreaths,
                value: stats['totalRespiraciones'].toString(),
                icon: Icons.air,
                color: const Color.fromARGB(255, 12, 81, 15),
              ),
              StatCardWidget(
                title: Strings.lastInvestmentDate,
                value: stats['fechaUltimaInversion'],
                icon: Icons.calendar_today,
                color: const Color.fromARGB(255, 125, 53, 8),
              ),

              StatCardWidget(
                title: Strings.manualInvestments,
                value: stats['inversionesManual'].toString(),
                icon: Icons.touch_app,
                color: const Color.fromARGB(255, 181, 63, 63),
              ),

              StatCardWidget(
                title: Strings.guidedInvestments,
                value: stats['inversionesGuiadas'].toString(),
                icon: Icons.hearing,
                color: const Color.fromARGB(255, 181, 165, 63),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget informacionGeneral() {
    return const InvestmentInfoWidget();
  }
}
