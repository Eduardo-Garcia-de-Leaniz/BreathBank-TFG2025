class Test2Model {
  int elapsedSeconds = 0;
  int testResult = 0;

  bool validateTestResult(String testResult) {
    return testResult.isNotEmpty && RegExp(r'^\d+$').hasMatch(testResult);
  }
}
