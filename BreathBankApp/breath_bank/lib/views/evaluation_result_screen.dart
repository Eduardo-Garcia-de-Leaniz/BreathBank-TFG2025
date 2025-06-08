import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
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
      title: Strings.evaluationResultTitle,
      canGoBack: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            Strings.evaluationCompleted,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          investorLevelCard(inversorLevel),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                resultItem(
                  icon: Icons.looks_one_rounded,
                  label: Strings.test1,
                  value: resultTest1,
                  unit: Strings.breathUnits,
                ),
                resultItem(
                  icon: Icons.looks_two_rounded,
                  label: Strings.test2,
                  value: resultTest2,
                  unit: Strings.secondsUnits,
                ),
                resultItem(
                  icon: Icons.looks_3_rounded,
                  label: Strings.test3,
                  value: resultTest3,
                  unit: Strings.breathUnits,
                ),
              ],
            ),
          ),
          AppButton(
            text: Strings.buttonToDashboard,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Strings.updateEvaluationData),
                  backgroundColor: kGreenColor,
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.of(context).pushNamed('/dashboard');
            },
            width: MediaQuery.of(context).size.width * 0.8,
            backgroundColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }

  Widget investorLevelCard(int inversorLevel) {
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
            Strings.newLevel,
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

  Widget resultItem({
    required IconData icon,
    required String label,
    required int value,
    required String unit,
  }) {
    return Card(
      color: kPrimaryColor,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: kWhiteColor, size: 36),
            const SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontSize: 18, color: kWhiteColor),
                    ),
                  ],
                ),
                Text(
                  '$value $unit',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kLevelColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
