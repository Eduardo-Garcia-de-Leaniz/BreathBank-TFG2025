import 'package:audioplayers/audioplayers.dart';
import 'package:breath_bank/models/investment_test_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/models/user_credentials.dart';
import 'package:fake_async/fake_async.dart';
import 'package:mockito/mockito.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserCredentials', () {
    test('se crea correctamente con email y password', () {
      final creds = UserCredentials(
        email: 'test@email.com',
        password: '123456',
      );
      expect(creds.email, 'test@email.com');
      expect(creds.password, '123456');
    });
  });

  group('UserCredentialsRegister', () {
    test('se crea correctamente con todos los campos', () {
      final creds = UserCredentialsRegister(
        email: 'test@email.com',
        password: '123456',
        confirmPassword: '123456',
        name: 'Test User',
      );
      expect(creds.email, 'test@email.com');
      expect(creds.password, '123456');
      expect(creds.confirmPassword, '123456');
      expect(creds.name, 'Test User');
    });
  });

  test('calculateNumBreaths calcula el número correcto de respiraciones', () {
    WidgetsFlutterBinding.ensureInitialized();
    InvestmentTestModel model = InvestmentTestModel(player: MockAudioPlayer());
    model.initialize(
      duracionMinutos: 4,
      listonInversion: 2,
      tipoInversion: 'Guiada',
    );
    final breaths = model.calculateNumBreaths(4, 2);
    expect(breaths, 75);
  });

  group('InvestmentTestModel', () {
    late InvestmentTestModel model;

    setUp(() {
      model = InvestmentTestModel(player: MockAudioPlayer());
      model.initialize(
        duracionMinutos: 1,
        listonInversion: 2,
        tipoInversion: 'Guiada',
      );
    });

    test('startTimer inicia y ejecuta onTick y onComplete', () {
      int tickCount = 0;
      bool completed = false;

      model.initialize(
        duracionMinutos: 1,
        listonInversion: 2,
        tipoInversion: 'Manual',
      );

      fakeAsync((async) {
        model.startTimer(
          () {
            tickCount++;
          },
          () {
            completed = true;
          },
        );

        async.elapse(const Duration(seconds: 61));

        expect(tickCount, greaterThan(0));
        expect(completed, isTrue);
        expect(model.isRunning, isFalse);
        expect(model.hasStarted, isTrue);
        expect(model.isTimeUp, isTrue);
      });
    });

    test('stopTimer detiene el temporizador', () {
      fakeAsync((async) {
        model.startTimer(() {}, () {});
        expect(model.isRunning, isTrue);

        model.stopTimer();
        expect(model.isRunning, isFalse);
      });
    });

    test('resetTimer reinicia los valores', () {
      model.secondsElapsed = 30;
      model.breathCount = 5;
      model.phaseCounter = 2;
      model.isRunning = true;
      model.hasStarted = true;
      model.isTimeUp = true;

      model.resetTimer();

      expect(model.secondsElapsed, 0);
      expect(model.breathCount, 0);
      expect(model.phaseCounter, 0);
      expect(model.isRunning, isFalse);
      expect(model.hasStarted, isFalse);
      expect(model.isTimeUp, isFalse);
    });

    test('markPhase solo suma en modo Manual y si está corriendo', () {
      model.tipoInversion = 'Manual';
      model.isRunning = true;
      model.phaseCounter = 1;
      model.breathCount = 0;

      model.markPhase();
      expect(model.phaseCounter, 2);
      expect(model.breathCount, 1);

      model.isRunning = false;
      model.markPhase();
      expect(model.phaseCounter, 2);
      expect(model.breathCount, 1);
    });
  });
}
