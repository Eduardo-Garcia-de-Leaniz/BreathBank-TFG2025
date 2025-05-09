import 'package:flutter/services.dart';

class Test1Model {
  String description = "Cargando...";
  String instructions = "Cargando...";
  int testResult = 0;
  int testDuration = 60;
  int remainingTime = 60;

  Future<void> loadDescriptionAndInstructions() async {
    description = await rootBundle.loadString(
      'assets/texts/description_test1.txt',
    );
    instructions = await rootBundle.loadString(
      'assets/texts/instructions_test1.txt',
    );
  }

  bool validateTestResult(String testResult) {
    return testResult.isNotEmpty && RegExp(r'^\d+$').hasMatch(testResult);
  }
}
