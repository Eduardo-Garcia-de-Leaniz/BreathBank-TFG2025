class Test1Model {
  int testResult = 0;
  int testDuration = 60;
  int remainingTime = 60;

  bool validateTestResult(String testResult) {
    return testResult.isNotEmpty && RegExp(r'^\d+$').hasMatch(testResult);
  }
}
