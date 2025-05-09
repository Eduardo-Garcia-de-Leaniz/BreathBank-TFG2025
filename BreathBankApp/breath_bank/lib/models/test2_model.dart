import 'package:flutter/services.dart';

class Test2Model {
  String description = "Cargando...";
  String instructions = "Cargando...";
  int elapsedSeconds = 0;
  int testResult = 0;

  Future<void> loadDescriptionAndInstructions() async {
    description = await rootBundle.loadString(
      'assets/texts/description_test2.txt',
    );
    instructions = await rootBundle.loadString(
      'assets/texts/instructions_test2.txt',
    );
  }

  bool validateTestResult(String testResult) {
    return testResult.isNotEmpty && RegExp(r'^\d+$').hasMatch(testResult);
  }
}
