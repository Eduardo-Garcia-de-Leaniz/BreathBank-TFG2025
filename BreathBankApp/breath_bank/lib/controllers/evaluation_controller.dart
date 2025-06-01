import 'package:breath_bank/database_service.dart';
import 'package:breath_bank/authentication_service.dart';
import '../models/evaluation_model.dart';

class EvaluationController {
  final EvaluationModel model;
  final DatabaseService db;
  final AuthenticationService authenticationService;

  EvaluationController(
    this.model, {
    DatabaseService? db,
    AuthenticationService? authService,
  }) : db = db ?? DatabaseService(),
       authenticationService = authService ?? AuthenticationService();

  late final String userId = authenticationService.currentUser!.uid;

  void completeTest(String testKey) {
    model.testCompleted[testKey] = true;
  }

  bool allTestsCompleted() {
    return model.testCompleted.values.every((e) => e);
  }

  bool saveNewEvaluation() {
    try {
      db.addNuevaEvaluacion(
        userId: userId,
        nivelInversorFinal: model.inversorLevel,
        resultadoPrueba1: model.resultTest1,
        resultadoPrueba2: model.resultTest2,
        resultadoPrueba3: model.resultTest3,
        fechaEvaluacion: DateTime.now(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  bool updateUserData() {
    try {
      db.updateEvaluacionesRealizadasYNivelInversor(
        userId: userId,
        fechaUltimaEvaluacion: DateTime.now(),
        nivelInversor: model.inversorLevel,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
