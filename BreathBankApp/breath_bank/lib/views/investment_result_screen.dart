import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/controllers/investment_controller.dart';
import 'base_screen.dart';

class InvestmentResultScreen extends StatelessWidget {
  final InvestmentController controller = InvestmentController();

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
      title: Strings.investmentResultTitle,
      padding: const EdgeInsets.all(16.0),
      canGoBack: false,
      child: Column(
        children: [
          const Text(
            Strings.investmentCompleted,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          if (breathResult > 0 && breathResult <= breathTarget)
            resultMessageBox(
              icon: Icons.check_circle,
              message: Strings.investmentSuccess,
              backgroundColor: Colors.green.shade900,
              textColor: Colors.green.shade100,
            )
          else if (breathResult > breathTarget)
            resultMessageBox(
              icon: Icons.warning_amber_rounded,
              message: Strings.investmentFail,
              backgroundColor: Colors.red.shade900,
              textColor: Colors.red.shade100,
            ),
          const SizedBox(height: 8),
          const Text(
            Strings.investmentResults,
            style: TextStyle(fontSize: 16, color: kPrimaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Expanded(
            child: ListView(
              children: [
                resultCard(
                  icon: Icons.timelapse,
                  title: Strings.investmentResultDuration,
                  value: '$investmentTime"',
                ),
                resultCard(
                  icon: Icons.done_outline_sharp,
                  title: Strings.investmentResultBreaths,
                  value: '$breathResult',
                ),
                resultCard(
                  icon: Icons.straighten,
                  title: Strings.investmentResultTarget,
                  value: '$breathTarget',
                ),
                resultCard(
                  icon: Icons.timer_outlined,
                  title: Strings.investmentResultSeconds,
                  value: '$breathSecondsResult"',
                ),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.handleGuardarInversion(
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
                    Strings.buttonToDashboard,
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

  Widget resultCard({
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
        leading: Icon(icon, color: kWhiteColor, size: 25),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, color: kWhiteColor),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }

  Widget resultMessageBox({
    required IconData icon,
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 8),
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
