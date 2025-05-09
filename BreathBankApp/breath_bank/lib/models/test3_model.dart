import 'package:flutter/services.dart';

class Test3Model {
  String description = "Cargando...";
  String instructions = "Cargando...";
  int testResult = 0;
  int numBreaths = 0;

  Future<void> loadDescriptionAndInstructions() async {
    description = await rootBundle.loadString(
      'assets/texts/description_test3.txt',
    );
    instructions = await rootBundle.loadString(
      'assets/texts/instructions_test3.txt',
    );
  }

  bool validateTestResult(String testResult) {
    return testResult.isNotEmpty && RegExp(r'^\d+$').hasMatch(testResult);
  }
}
