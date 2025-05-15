import 'package:breath_bank/widgets/countdown_overlay_widget.dart';
import 'package:breath_bank/widgets/countdown_widget.dart';
import 'package:flutter/material.dart';
import '../controllers/investment_test_controller.dart';
import '../models/investment_test_model.dart';
import 'base_screen.dart';

class ManualInvestmentScreen extends StatefulWidget {
  const ManualInvestmentScreen({super.key});

  @override
  State<ManualInvestmentScreen> createState() => _ManualInvestmentScreenState();
}

class _ManualInvestmentScreenState extends State<ManualInvestmentScreen>
    with SingleTickerProviderStateMixin {
  late InvestmentTestController _controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  OverlayEntry? _countdownOverlayEntry;

  @override
  void initState() {
    super.initState();
    final model = InvestmentTestModel();
    _controller = InvestmentTestController(model);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _controller.initialize(args, 'Manual');
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.model.dispose();
    _animationController.dispose();
    _countdownOverlayEntry?.remove();
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
      title: 'Inversión Manual',
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          _controller.markPhase();
          _animationController.forward(from: 0);
          setState(() {});
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                // Circle and Progress Indicator
                Container(
                  height: 350,
                  width: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 7, 71, 94),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 4,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: CircularProgressIndicator(
                    value: 1 - _controller.timeProgress,
                    strokeWidth: 14,
                    backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _controller.timeProgress == 1
                          ? Colors.green
                          : Colors.blueAccent,
                    ),
                  ),
                ),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${model.breathCount} / ${model.targetBreaths}',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 126, 172, 186),
                        ),
                      ),
                      const Text(
                        'Respiraciones',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 126, 172, 186),
                        ),
                      ),
                      Text(
                        _controller.formatTime(_controller.remainingSeconds),
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildControlButton(
                            icon:
                                model.isRunning
                                    ? Icons.pause
                                    : Icons.play_arrow,
                            color: Colors.green,
                            onPressed: () {
                              if (model.isRunning) {
                                _controller.stopTimer();
                              } else if (model.hasStarted) {
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
                              } else {
                                CountdownOverlayWidget.show(
                                  context: context,
                                  initialCountdown: 3,
                                  onCountdownComplete: () {
                                    _controller.startTimer(
                                      () {
                                        setState(() {});
                                      },
                                      () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              '¡Tiempo finalizado!',
                                            ),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              }
                              setState(() {});
                            },
                          ),
                          const SizedBox(width: 30),
                          _buildControlButton(
                            icon: Icons.replay,
                            color: Colors.red,
                            onPressed:
                                model.hasStarted
                                    ? () {
                                      _controller.resetTimer();
                                      setState(() {});
                                    }
                                    : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                  'Ritmo máximo para superar la inversión: \n${model.duracionFase.toStringAsFixed(1)} segundos por inhalación/exhalación',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 90, 122, 138),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              textAlign: TextAlign.center,
              'Una vez haya comenzado el tiempo, toca cualquier parte de la pantalla para marcar inspiración / espiración',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
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
                        'tipo_inversion': model.tipoInversion,
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

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(50, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: Icon(icon, size: 40, color: color),
    );
  }
}
