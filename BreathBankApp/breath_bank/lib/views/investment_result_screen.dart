import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/controllers/investment_controller.dart';
import 'base_screen.dart';

class InvestmentResultScreen extends StatelessWidget {
  final InvestmentController _controller = InvestmentController();

  InvestmentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final breathResult = args['breath_result'] as int;
    final breathTarget = args['breath_target'] as int;
    final investmentTime = args['investment_time'] as int;
    final listonInversion = args['liston_inversion'] as int;
    final tipoInversion = args['tipo_inversion'] as String;

    final breathSecondsResult =
        (breathResult == 0)
            ? '0'
            : (investmentTime / breathResult).toInt().toString();

    return BaseScreen(
      title: 'Resultados de Inversión',
      padding: const EdgeInsets.all(16.0),
      canGoBack: false,
      child: Column(
        children: [
          const Text(
            '¡Inversión completada!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          if (breathResult > 0 && breathResult <= breathTarget)
            _buildResultMessageBox(
              icon: Icons.check_circle,
              message: '¡Has superado con éxito la inversión!',
              backgroundColor: Colors.green.shade900,
              textColor: Colors.green.shade100,
            )
          else if (breathResult > breathTarget)
            _buildResultMessageBox(
              icon: Icons.warning_amber_rounded,
              message: 'No has superado el objetivo. ¡Sigue practicando!',
              backgroundColor: Colors.red.shade900,
              textColor: Colors.red.shade100,
            ),
          const SizedBox(height: 8),
          const Text(
            'Aquí están los resultados de tu ejercicio de inversión:',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView(
              children: [
                _buildResultCard(
                  icon: Icons.timelapse,
                  title: 'Duración',
                  value: '$investmentTime segundos',
                ),
                _buildResultCard(
                  icon: Icons.done_outline_sharp,
                  title: 'Respiraciones realizadas',
                  value: '$breathResult',
                ),
                _buildResultCard(
                  icon: Icons.straighten,
                  title: 'Límite de respiraciones',
                  value: '$breathTarget',
                ),
                _buildResultCard(
                  icon: Icons.timer_outlined,
                  title: 'Tiempo por respiración',
                  value: '$breathSecondsResult segundos',
                ),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _controller.handleGuardarInversion(
                  context: context,
                  liston: listonInversion,
                  resultado: breathResult,
                  tiempo: investmentTime,
                  exito: breathResult <= breathTarget,
                  tipoInversion: tipoInversion,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Volver',
                    style: TextStyle(fontSize: 16, color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      color: kPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: kWhiteColor, size: 30),
        title: Text(title, style: TextStyle(fontSize: 14, color: kWhiteColor)),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }

  Widget _buildResultMessageBox({
    required IconData icon,
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: textColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
