import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';
import '../controllers/evaluation_controller.dart';
import '../models/evaluation_model.dart';
import 'base_screen.dart'; // Importamos BaseScreen
import '../widgets/app_button.dart'; // Importamos AppButton

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  EvaluationScreenState createState() => EvaluationScreenState();
}

class EvaluationScreenState extends State<EvaluationScreen> {
  final EvaluationModel model = EvaluationModel();
  late final EvaluationController controller;

  @override
  void initState() {
    super.initState();
    controller = EvaluationController(model);
  }

  @override
  Widget build(BuildContext context) {
    double buttonsWidth = MediaQuery.of(context).size.width * 0.6;
    double buttonsBorderRadius = 50.0;
    double separatorHeight = 20.0;

    return BaseScreen(
      canGoBack: false,
      title: 'Evaluación', // Título del AppBar
      child: Column(
        children: [
          const Text(
            'Evaluación',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: separatorHeight * 3),
          Text(
            'Has completado ${model.testCompleted.values.where((e) => e).length} de 3 pruebas',
          ),
          SizedBox(height: separatorHeight),
          ProgressionBar(model: model),
          SizedBox(height: separatorHeight * 2),

          // Botón para la prueba 1
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color:
                    model.testCompleted['test1'] == true
                        ? Colors.green
                        : Colors.grey,
              ),
              const SizedBox(width: 8),
              AppButton(
                width: buttonsWidth,
                borderRadius: buttonsBorderRadius,
                text: 'Iniciar Prueba 1',
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/evaluation/test1', // Ruta de la pantalla de prueba
                  );

                  if (result != null && result is int) {
                    setState(() {
                      model.resultTest1 =
                          result; // Guarda el resultado en el modelo
                      model.testCompleted['test1'] =
                          true; // Marca la prueba como completada
                    });
                  }
                },
                isDisabled: model.testCompleted['test1'] == true,
                backgroundColor:
                    model.testCompleted['test1'] == true
                        ? Colors.grey
                        : kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: separatorHeight),

          // Botón para la prueba 2
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color:
                    model.testCompleted['test2'] == true
                        ? Colors.green
                        : Colors.grey,
              ),
              const SizedBox(width: 8),
              AppButton(
                width: buttonsWidth,
                borderRadius: buttonsBorderRadius,
                text: 'Iniciar Prueba 2',
                onPressed:
                    model.testCompleted['test2'] == true
                        ? null
                        : () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/evaluation/test2',
                          );

                          if (result != null && result is int) {
                            setState(() {
                              model.resultTest2 =
                                  result; // Guarda el resultado en el modelo
                              model.testCompleted['test2'] =
                                  true; // Marca la prueba como completada
                            });
                          }
                        },
                isDisabled: model.testCompleted['test2'] == true,
                backgroundColor:
                    model.testCompleted['test2'] == true
                        ? Colors.grey
                        : kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: separatorHeight),

          // Botón para la prueba 3
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color:
                    model.testCompleted['test3'] == true
                        ? Colors.green
                        : Colors.grey,
              ),
              const SizedBox(width: 8),
              AppButton(
                width: buttonsWidth,
                borderRadius: buttonsBorderRadius,
                text: 'Iniciar Prueba 3',
                onPressed:
                    model.testCompleted['test3'] == true
                        ? null
                        : () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/evaluation/test3', // Ruta de la pantalla de prueba 3
                          );

                          if (result != null && result is int) {
                            setState(() {
                              model.resultTest3 =
                                  result; // Guarda el resultado en el modelo
                              model.testCompleted['test3'] =
                                  true; // Marca la prueba como completada
                            });
                          }
                        },
                isDisabled: model.testCompleted['test3'] == true,
                backgroundColor:
                    model.testCompleted['test3'] == true
                        ? Colors.grey
                        : kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: separatorHeight * 6),

          // Botón para continuar
          AppButton(
            text: 'Continuar',
            width: MediaQuery.of(context).size.width * 0.8,
            onPressed:
                controller.allTestsCompleted()
                    ? () {
                      model.inversorLevel = model.calculateInversorLevel();
                      if (controller.saveNewEvaluation()) {
                        controller.updateUserData();
                        Navigator.pushNamed(
                          context,
                          '/evaluation/result',
                          arguments: {
                            'nivelInversorFinal': model.inversorLevel,
                            'result_test1': model.resultTest1,
                            'result_test2': model.resultTest2,
                            'result_test3': model.resultTest3,
                          },
                        );
                      }
                    }
                    : null,
            isDisabled: !controller.allTestsCompleted(),
            backgroundColor:
                controller.allTestsCompleted() ? kPrimaryColor : Colors.grey,
          ),
        ],
      ),
    );
  }
}

class ProgressionBar extends StatelessWidget {
  const ProgressionBar({super.key, required this.model});

  final EvaluationModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: LinearProgressIndicator(
            value: model.testCompleted.values.where((e) => e).length / 3,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
            minHeight: 30,
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              '${(model.testCompleted.values.where((e) => e).length / 3 * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
