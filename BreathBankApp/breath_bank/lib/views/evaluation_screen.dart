import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:flutter/material.dart';
import '../controllers/evaluation_controller.dart';
import '../models/evaluation_model.dart';
import 'base_screen.dart';
import '../widgets/app_button.dart';

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
      title: Strings.evaluationTitle,
      child: Column(
        children: [
          const Text(
            Strings.evaluationTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: const Text(
              textAlign: TextAlign.center,
              Strings.evaluationDescription,
              style: TextStyle(fontSize: 15, color: kPrimaryColor),
            ),
          ),
          SizedBox(height: separatorHeight),
          Text(
            Strings.completedTests.replaceFirst(
              '{0}',
              model.testCompleted.values.where((e) => e).length.toString(),
            ),
            style: const TextStyle(fontSize: 15, color: kPrimaryColor),
          ),
          SizedBox(height: separatorHeight),
          ProgressionBar(model: model),
          SizedBox(height: separatorHeight * 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color:
                    model.testCompleted['test1'] == true
                        ? kGreenColor
                        : kDisabledColor,
              ),
              const SizedBox(width: 8),
              AppButton(
                width: buttonsWidth,
                borderRadius: buttonsBorderRadius,
                text: Strings.startTest1,
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/evaluation/test1',
                  );

                  if (result != null && result is int) {
                    setState(() {
                      model.resultTest1 = result;
                      model.testCompleted['test1'] = true;
                    });
                  }
                },
                isDisabled: model.testCompleted['test1'] == true,
                backgroundColor:
                    model.testCompleted['test1'] == true
                        ? kDisabledColor
                        : kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: separatorHeight),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color:
                    model.testCompleted['test2'] == true
                        ? kGreenColor
                        : kDisabledColor,
              ),
              const SizedBox(width: 8),
              AppButton(
                width: buttonsWidth,
                borderRadius: buttonsBorderRadius,
                text: Strings.startTest2,
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
                              model.resultTest2 = result;
                              model.testCompleted['test2'] = true;
                            });
                          }
                        },
                isDisabled: model.testCompleted['test2'] == true,
                backgroundColor:
                    model.testCompleted['test2'] == true
                        ? kDisabledColor
                        : kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: separatorHeight),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color:
                    model.testCompleted['test3'] == true
                        ? kGreenColor
                        : kDisabledColor,
              ),
              const SizedBox(width: 8),
              AppButton(
                width: buttonsWidth,
                borderRadius: buttonsBorderRadius,
                text: Strings.startTest3,
                onPressed:
                    model.testCompleted['test3'] == true
                        ? null
                        : () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/evaluation/test3',
                          );

                          if (result != null && result is int) {
                            setState(() {
                              model.resultTest3 = result;
                              model.testCompleted['test3'] = true;
                            });
                          }
                        },
                isDisabled: model.testCompleted['test3'] == true,
                backgroundColor:
                    model.testCompleted['test3'] == true
                        ? kDisabledColor
                        : kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: separatorHeight * 2),

          AppButton(
            text: Strings.continueButton,
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
                controller.allTestsCompleted() ? kPrimaryColor : kDisabledColor,
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
            color: kGreenColor,
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
