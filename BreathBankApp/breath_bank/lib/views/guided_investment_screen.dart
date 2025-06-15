import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/widgets/info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../controllers/investment_test_controller.dart';
import '../models/investment_test_model.dart';
import '../widgets/countdown_overlay_widget.dart';
import 'base_screen.dart';

class GuidedInvestmentScreen extends StatefulWidget {
  const GuidedInvestmentScreen({super.key});

  @override
  State<GuidedInvestmentScreen> createState() => _GuidedInvestmentScreenState();
}

class _GuidedInvestmentScreenState extends State<GuidedInvestmentScreen> {
  late InvestmentTestController controller;

  @override
  void initState() {
    super.initState();
    final model = InvestmentTestModel();
    controller = InvestmentTestController(model);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      controller.initialize(args, 'Guiada');
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = controller.model;

    return BaseScreen(
      canGoBack: false,
      title: Strings.guidedInvestmentTitle,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (model.hasStarted && !model.isTimeUp)
              Text(
                model.phaseCounter % 2 == 0 ? 'Inspira' : 'Expira',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color:
                      model.phaseCounter % 2 == 0
                          ? kGreenColor
                          : kRedAccentColor,
                ),
              ),
            if (model.isTimeUp)
              const Text(
                Strings.finishInvestmentText,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: kPrimaryColor,
                ),
              ),
            if (!model.isTimeUp && !model.isRunning && model.hasStarted)
              Text(
                Strings.startInvestmentText
                    .replaceAll('{0}', 'verde')
                    .replaceAll('{1}', 'reanudar'),
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: kPrimaryColor,
                ),
              ),
            if (!model.isTimeUp && !model.isRunning && !model.hasStarted)
              Text(
                Strings.startInvestmentText
                    .replaceAll('{0}', 'verde')
                    .replaceAll('{1}', 'comenzar'),
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: kPrimaryColor,
                ),
              ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoCard(
                  title: Strings.completedBreaths,
                  value: '${model.breathCount}',
                  numberColor: kGreenColor,
                  textColor: kGreenColor,
                  maxValue: model.targetBreaths,
                  width: 140,
                  height: 130,
                ),
                const SizedBox(width: 18),
                InfoCard(
                  title: Strings.remainingBreaths,
                  value: '${model.targetBreaths - model.breathCount}',
                  numberColor: kRedAccentColor,
                  textColor: kRedAccentColor,
                  maxValue: model.targetBreaths,
                  width: 140,
                  height: 130,
                ),
              ],
            ),
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 10.0,
              percent: model.secondsElapsed / model.timeLimit,
              center: Text(
                '${controller.remainingSeconds}',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color:
                      model.phaseCounter % 2 == 0
                          ? kGreenColor
                          : kRedAccentColor,
                ),
              ),
              progressColor:
                  model.phaseCounter % 2 == 0 ? kGreenColor : kRedAccentColor,
              backgroundColor: const Color.fromARGB(42, 0, 0, 0),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!model.isRunning && !model.hasStarted)
                  TextButton(
                    onPressed: () {
                      CountdownOverlayWidget.show(
                        context: context,
                        initialCountdown: 3,
                        onCountdownComplete: () {
                          controller.startTimer(
                            () {
                              setState(() {});
                            },
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(Strings.finishInvestment),
                                  backgroundColor: kGreenColor,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              setState(() {});
                            },
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(
                      model.isRunning ? Icons.pause : Icons.play_arrow,
                      size: 30,
                      color: kGreenColor,
                    ),
                  )
                else if (model.hasStarted && !model.isRunning)
                  TextButton(
                    onPressed: () {
                      controller.startTimer(
                        () {
                          setState(() {});
                        },
                        () {
                          setState(() {});
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      minimumSize: const Size(30, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(
                      model.isRunning ? Icons.pause : Icons.play_arrow,
                      size: 30,
                      color: kGreenColor,
                    ),
                  )
                else
                  TextButton(
                    onPressed: () {
                      controller.stopTimer();
                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      minimumSize: const Size(30, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(
                      Icons.pause,
                      size: 30,
                      color: kGreenColor,
                    ),
                  ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    controller.resetTimer();
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size(30, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.replay,
                    size: 30,
                    color: kRedAccentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (!model.isTimeUp)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info,
                    size: 25,
                    color: Color.fromARGB(255, 90, 122, 138),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    Strings.maxRhythmGuidedInvestment.replaceFirst(
                      '{0}',
                      model.duracionFase.toStringAsFixed(1),
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 90, 122, 138),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 15),
            if (model.isTimeUp)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/dashboard/newinvestmentmenu/results',
                      arguments: {
                        'breath_result': model.breathCount,
                        'breath_target': model.targetBreaths,
                        'investment_time': model.timeLimit,
                        'liston_inversion': model.listonInversion,
                        'tipo_inversion': 'Guiada',
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Strings.seeResult,
                        style: TextStyle(fontSize: 18, color: kWhiteColor),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.arrow_forward, color: kWhiteColor, size: 20),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
