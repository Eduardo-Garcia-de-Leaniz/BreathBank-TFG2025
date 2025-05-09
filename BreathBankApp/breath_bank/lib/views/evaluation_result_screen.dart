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
          const SizedBox(height: 10),
          const Text(
            '¡Evaluación completada!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 7, 71, 94),
            ),
          ),
          const SizedBox(height: 30),
          _buildInvestorLevelCard(inversorLevel),
          const SizedBox(height: 30),
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
            backgroundColor: const Color.fromARGB(255, 7, 71, 94),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestorLevelCard(int inversorLevel) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
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
            'Tu nivel de inversor es:',
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 7, 71, 94),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            inversorLevel.toString(),
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
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
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color.fromARGB(255, 7, 71, 94),
          size: 30,
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 7, 71, 94),
          ),
        ),
        trailing: Text(
          '$value $unit',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }
}
