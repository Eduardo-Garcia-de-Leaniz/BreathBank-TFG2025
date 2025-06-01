import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/models/test3_model.dart';

void main() {
  late Test3Model model;

  setUp(() {
    model = Test3Model();
  });

  group('validateTestResult', () {
    test('devuelve true para un número válido', () {
      expect(model.validateTestResult('7'), isTrue);
      expect(model.validateTestResult('0'), isTrue);
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
    test('numBreaths es 0 por defecto', () {
      expect(model.numBreaths, 0);
    });
  });
}
