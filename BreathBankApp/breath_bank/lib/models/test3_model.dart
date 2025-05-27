class Test3Model {
  int testResult = 0;
  int numBreaths = 0;

  bool validateTestResult(String testResult) {
    return testResult.isNotEmpty && RegExp(r'^\d+$').hasMatch(testResult);
  }
}
