import 'package:flutter/material.dart';
import '../controllers/guided_investment_controller.dart';
import '../models/guided_investment_model.dart';
import 'base_screen.dart';

class GuidedInvestmentScreen extends StatefulWidget {
  const GuidedInvestmentScreen({super.key});

  @override
  State<GuidedInvestmentScreen> createState() => _GuidedInvestmentScreenState();
}

class _GuidedInvestmentScreenState extends State<GuidedInvestmentScreen> {
  late GuidedInvestmentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GuidedInvestmentController(GuidedInvestmentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _controller.initialize(context, args);
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
    return BaseScreen(
      canGoBack: false,
      title: 'Inversión Guiada',
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*
          Text(
            _controller.isInhaling ? 'Inspirar' : 'Espirar',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          */
          const SizedBox(height: 20),
          Text('Respiraciones completadas: ${_controller.model.breathCount}'),
          Text(
            'Respiraciones restantes: ${_controller.model.targetBreaths - _controller.model.breathCount}',
          ),
          const SizedBox(height: 20),
          Text('Tiempo transcurrido: ${_controller.model.secondsElapsed}s'),
          Text(
            'Tiempo restante: ${_controller.remainingSeconds > 0 ? _controller.remainingSeconds : 0}s',
          ),
          const SizedBox(height: 40),
          if (!_controller.model.isRunning)
            ElevatedButton(
              onPressed: () {
                _controller.model.startTimer(
                  () {
                    setState(() {});
                  },
                  () {
                    setState(() {});
                  },
                );
              },
              child: const Text('Comenzar'),
            )
          else if (_controller.model.hasStarted && !_controller.model.isRunning)
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
              child: const Text('Reanudar'),
            )
          else
            ElevatedButton(
              onPressed: () {
                _controller.stopTimer();
                setState(() {});
              },
              child: const Text('Pausar'),
            ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _controller.resetTimer();
              setState(() {});
            },
            child: const Text('Restablecer'),
          ),
          const Spacer(),
          if (_controller.remainingSeconds == 0)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/dashboard/newinvestmentmenu/results',
                    arguments: {
                      'breath_result': _controller.model.breathCount,
                      'breath_target': _controller.model.targetBreaths,
                      'investment_time': _controller.model.timeLimit,
                      'liston_inversion': _controller.model.listonInversion,
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
