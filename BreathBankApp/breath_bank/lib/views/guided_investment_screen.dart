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
  late InvestmentTestController _controller;

  @override
  void initState() {
    super.initState();
    final model = InvestmentTestModel();
    _controller = InvestmentTestController(model);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _controller.initialize(args, 'Guiada');
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = _controller.model;

    return BaseScreen(
      canGoBack: false,
      title: 'Inversión Guiada',
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoCard(
                  title: 'Resp. completadas',

                  value: '${model.breathCount}',
                  numberColor: Colors.green,
                  textColor: Colors.green,
                  maxValue: model.targetBreaths,
                  width: 140,
                  height: 130,
                ),
                const SizedBox(width: 18),
                InfoCard(
                  title: 'Resp. restantes',
                  value: '${model.targetBreaths - model.breathCount}',
                  numberColor: Colors.red,
                  textColor: Colors.red,
                  maxValue: model.targetBreaths,
                  width: 140,
                  height: 130,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              model.phaseCounter % 2 == 0 ? 'Inspira' : 'Espira',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: model.phaseCounter % 2 == 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 15.0,
              percent: model.secondsElapsed / model.timeLimit,
              center: Text(
                '${_controller.remainingSeconds}',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color:
                      model.phaseCounter % 2 == 0 ? Colors.green : Colors.red,
                ),
              ),
              progressColor:
                  model.phaseCounter % 2 == 0 ? Colors.green : Colors.red,
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
                          _controller.startTimer(
                            () {
                              setState(() {});
                            },
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('¡Tiempo finalizado!'),
                                  backgroundColor: Colors.green,
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
                      size: 40,
                      color: Colors.green,
                    ),
                  )
                else if (model.hasStarted && !model.isRunning)
                  TextButton(
                    onPressed: () {
                      _controller.startTimer(
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
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(
                      model.isRunning ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.green,
                    ),
                  )
                else
                  TextButton(
                    onPressed: () {
                      _controller.stopTimer();
                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(
                      Icons.pause,
                      size: 40,
                      color: Colors.green,
                    ),
                  ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    _controller.resetTimer();
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.replay, size: 40, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Ritmo de la inversión: \n${model.duracionFase.toStringAsFixed(1)} segundos por inhalación/exhalación',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 90, 122, 138),
              ),
            ),

            const Spacer(),
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
                        'Ver Resultado',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
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
