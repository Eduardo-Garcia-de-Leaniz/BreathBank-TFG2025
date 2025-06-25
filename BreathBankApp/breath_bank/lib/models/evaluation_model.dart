class EvaluationModel {
  int resultTest1 = 0;
  int resultTest2 = 0;
  int resultTest3 = 0;
  int inversorLevel = 0;

  // Pesos establecidos por el creador de la aplicación.
  int weightTest1 = 20;
  int weightTest2 = 30;
  int weightTest3 = 50;

  Map<String, bool> testCompleted = {
    'test1': false,
    'test2': false,
    'test3': false,
  };

  // Calificaciones estimadas por el creador de la aplicación.
  int calculateTest1Result(int resultTest1) {
    if (resultTest1 <= 1) return 10;
    if (resultTest1 == 2) return 9;
    if (resultTest1 == 3) return 8;
    if (resultTest1 == 4) return 7;
    if (resultTest1 == 5) return 6;
    if (resultTest1 == 6) return 5;
    if (resultTest1 == 7) return 4;
    if (resultTest1 == 8) return 3;
    if (resultTest1 == 9) return 2;
    if (resultTest1 == 10) return 1;
    if (resultTest1 >= 11) return 0;
    return 0;
  }

  int calculateTest2Result(int resultTest2) {
    if (resultTest2 >= 180) return 10;
    if (resultTest2 >= 160) return 9;
    if (resultTest2 >= 140) return 8;
    if (resultTest2 >= 120) return 7;
    if (resultTest2 >= 90) return 6;
    if (resultTest2 >= 60) return 5;
    if (resultTest2 >= 50) return 4;
    if (resultTest2 >= 40) return 3;
    if (resultTest2 >= 30) return 2;
    if (resultTest2 >= 20) return 1;
    return 0;
  }

  int calculateTest3Result(int resultTest3) {
    if (resultTest3 <= 2) return 0;
    if (resultTest3 <= 3) return 1;
    if (resultTest3 <= 4) return 2;
    if (resultTest3 <= 6) return 3;
    if (resultTest3 <= 10) return 4;
    if (resultTest3 <= 14) return 5;
    if (resultTest3 <= 18) return 6;
    if (resultTest3 <= 25) return 7;
    if (resultTest3 <= 30) return 8;
    if (resultTest3 <= 40) return 9;
    return 10;
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
