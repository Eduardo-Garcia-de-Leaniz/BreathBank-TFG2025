import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/models/test2_model.dart';

void main() {
  late Test2Model model;

  setUp(() {
    model = Test2Model();
  });

  group('validateTestResult', () {
    test('devuelve true para un número válido', () {
      expect(model.validateTestResult('10'), isTrue);
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
    test('elapsedSeconds es 0 por defecto', () {
      expect(model.elapsedSeconds, 0);
    });
    test('testResult es 0 por defecto', () {
      expect(model.testResult, 0);
    });
  });
}
