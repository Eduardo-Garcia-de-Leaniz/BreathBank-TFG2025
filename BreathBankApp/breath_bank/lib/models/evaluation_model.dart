class EvaluationModel {
  int resultTest1 = 0;
  int resultTest2 = 0;
  int resultTest3 = 0;
  int inversorLevel = 0;

  int weightTest1 = 10;
  int weightTest2 = 30;
  int weightTest3 = 60;

  Map<String, bool> testCompleted = {
    'test1': false,
    'test2': false,
    'test3': false,
  };

  int calculateTest1Result(int resultTest1) {
    if (resultTest1 <= 3) return 11;
    if (resultTest1 == 4) return 10;
    if (resultTest1 == 5) return 9;
    if (resultTest1 == 6) return 8;
    if (resultTest1 == 7) return 7;
    if (resultTest1 == 8) return 6;
    if (resultTest1 == 9) return 5;
    if (resultTest1 == 10) return 4;
    if (resultTest1 == 11) return 3;
    if (resultTest1 == 12) return 2;
    if (resultTest1 == 13) return 1;
    return 0;
  }

  int calculateTest2Result(int resultTest2) {
    if (resultTest2 >= 301) return 11;
    if (resultTest2 >= 271) return 10;
    if (resultTest2 >= 241) return 9;
    if (resultTest2 >= 211) return 8;
    if (resultTest2 >= 181) return 7;
    if (resultTest2 >= 151) return 6;
    if (resultTest2 >= 121) return 5;
    if (resultTest2 >= 91) return 4;
    if (resultTest2 >= 61) return 3;
    if (resultTest2 >= 41) return 2;
    if (resultTest2 >= 21) return 1;
    return 0;
  }

  int calculateTest3Result(int resultTest3) {
    if (resultTest3 <= 7) return 0;
    if (resultTest3 <= 14) return 1;
    if (resultTest3 <= 21) return 2;
    if (resultTest3 <= 28) return 3;
    if (resultTest3 <= 35) return 4;
    if (resultTest3 <= 42) return 5;
    if (resultTest3 <= 49) return 6;
    if (resultTest3 <= 56) return 7;
    if (resultTest3 <= 63) return 8;
    if (resultTest3 <= 70) return 9;
    if (resultTest3 <= 77) return 10;
    return 11;
  }

  int calculateInversorLevel() {
    int test1Level = calculateTest1Result(resultTest1);
    int test2Level = calculateTest2Result(resultTest2);
    int test3Level = calculateTest3Result(resultTest3);

    double level =
        (test1Level * weightTest1 +
            test2Level * weightTest2 +
            test3Level * weightTest3) /
        100;
    return level.round();
  }
}
