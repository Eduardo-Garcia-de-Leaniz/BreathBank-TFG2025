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

    if (model.timeLimit == 0) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 188, 252, 245),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BaseScreen(
      canGoBack: false,
      title: 'Inversión Guiada',
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            model.phaseCounter % 2 == 0 ? 'Inspirar' : 'Espirar',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 15.0,
            percent: model.secondsElapsed / model.timeLimit,
            center: Text(
              '${_controller.remainingSeconds}s',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            progressColor: Colors.teal,
            backgroundColor: Colors.teal.shade100,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 20),
          Text('Respiraciones completadas: ${model.breathCount}'),
          Text(
            'Respiraciones restantes: ${model.targetBreaths - model.breathCount}',
          ),
          const SizedBox(height: 30),
          if (!model.isRunning && !model.hasStarted)
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Comenzar'),
            )
          else if (model.hasStarted && !model.isRunning)
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Reanudar'),
            )
          else
            ElevatedButton(
              onPressed: () {
                _controller.stopTimer();
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Pausar'),
            ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _controller.resetTimer();
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Restablecer'),
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
    );
  }
}
