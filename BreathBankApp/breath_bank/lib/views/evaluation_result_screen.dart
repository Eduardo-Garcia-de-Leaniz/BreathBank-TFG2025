import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';
import 'base_screen.dart';
import '../widgets/app_button.dart';

class EvaluationResultScreen extends StatelessWidget {
  const EvaluationResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int inversorLevel = args['nivelInversorFinal'];
    final int resultTest1 = args['result_test1'];
    final int resultTest2 = args['result_test2'];
    final int resultTest3 = args['result_test3'];

    return BaseScreen(
      title: 'Resultados Evaluación',
      canGoBack: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '¡Evaluación completada!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildInvestorLevelCard(inversorLevel),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildResultItem(
                  icon: Icons.looks_one_rounded,
                  label: 'Prueba 1',
                  value: resultTest1,
                  unit: 'respiraciones',
                ),
                _buildResultItem(
                  icon: Icons.looks_two_rounded,
                  label: 'Prueba 2',
                  value: resultTest2,
                  unit: 'segundos',
                ),
                _buildResultItem(
                  icon: Icons.looks_3_rounded,
                  label: 'Prueba 3',
                  value: resultTest3,
                  unit: 'respiraciones',
                ),
              ],
            ),
          ),
          AppButton(
            text: 'Ir a mi Dashboard',
            onPressed: () {
              Navigator.of(context).pushNamed('/dashboard');
            },
            width: MediaQuery.of(context).size.width * 0.8,
            backgroundColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInvestorLevelCard(int inversorLevel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Nuevo nivel de inversor',
            style: TextStyle(fontSize: 16, color: kLevelColor),
          ),
          Text(
            inversorLevel.toString(),
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: kLevelColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem({
    required IconData icon,
    required String label,
    required int value,
    required String unit,
  }) {
    return Card(
      color: kPrimaryColor,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: kWhiteColor, size: 30),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, color: kWhiteColor),
        ),
        trailing: Text(
          '$value $unit',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kLevelColor,
          ),
        ),
      ),
    );
  }
}
