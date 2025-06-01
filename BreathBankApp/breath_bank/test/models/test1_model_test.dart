import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/models/test1_model.dart';

void main() {
  late Test1Model model;

  setUp(() {
    model = Test1Model();
  });

  group('validateTestResult', () {
    test('devuelve true para un número válido', () {
      expect(model.validateTestResult('5'), isTrue);
      expect(model.validateTestResult('123'), isTrue);
    });

    test('devuelve false para una cadena vacía', () {
      expect(model.validateTestResult(''), isFalse);
    });

    test('devuelve false para un valor no numérico', () {
      expect(model.validateTestResult('abc'), isFalse);
      expect(model.validateTestResult('12a'), isFalse);
      expect(model.validateTestResult('!@#'), isFalse);
    });

    test('devuelve false para un número negativo', () {
      expect(model.validateTestResult('-5'), isFalse);
    });
  });

  group('valores iniciales', () {
    test('testResult es 0 por defecto', () {
      expect(model.testResult, 0);
    });
    test('testDuration es 60 por defecto', () {
      expect(model.testDuration, 60);
    });
    test('remainingTime es 60 por defecto', () {
      expect(model.remainingTime, 60);
    });
  });
}
