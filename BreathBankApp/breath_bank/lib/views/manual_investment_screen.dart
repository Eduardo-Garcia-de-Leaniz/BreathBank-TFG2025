import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/widgets/countdown_overlay_widget.dart';
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
  late InvestmentTestController controller;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  OverlayEntry? countdownOverlayEntry;

  @override
  void initState() {
    super.initState();
    final model = InvestmentTestModel();
    controller = InvestmentTestController(model);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      controller.initialize(args, 'Manual');
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.model.dispose();
    animationController.dispose();
    countdownOverlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = controller.model;

    if (model.timeLimit == 0) {
      return const Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BaseScreen(
      canGoBack: false,
      title: Strings.manualInvestmentTitle,
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          controller.markPhase();
          animationController.forward(from: 0);
          setState(() {});
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            if (!model.isTimeUp && model.isRunning)
              Text(
                textAlign: TextAlign.center,
                Strings.instructionManualInvestment.replaceFirst(
                  '{0}',
                  model.phaseCounter % 2 == 0 ? 'inspirar' : 'expirar',
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: kPrimaryColor,
                  fontStyle: FontStyle.italic,
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
                    .replaceFirst('{0}', 'verde')
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
                    .replaceFirst('{0}', 'verde')
                    .replaceAll('{1}', 'comenzar'),
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: kPrimaryColor,
                ),
              ),
            const SizedBox(height: 15),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 320,
                  width: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 4,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 280,
                  width: 280,
                  child: CircularProgressIndicator(
                    value: 1 - controller.timeProgress,
                    strokeWidth: 14,
                    backgroundColor: kRedAccentColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      controller.timeProgress == 1
                          ? Colors.green
                          : Colors.blueAccent,
                    ),
                  ),
                ),
                ScaleTransition(
                  scale: scaleAnimation,
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
                        Strings.breaths,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 126, 172, 186),
                        ),
                      ),
                      Text(
                        controller.formatTime(controller.remainingSeconds),
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: kWhiteColor,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          controlButton(
                            icon:
                                model.isRunning
                                    ? Icons.pause
                                    : Icons.play_arrow,
                            color: kGreenColor,
                            onPressed: () {
                              if (model.isRunning) {
                                controller.stopTimer();
                              } else if (model.hasStarted) {
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
                              } else {
                                CountdownOverlayWidget.show(
                                  context: context,
                                  initialCountdown: 3,
                                  onCountdownComplete: () {
                                    controller.startTimer(
                                      () {
                                        setState(() {});
                                      },
                                      () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              Strings.finishInvestment,
                                            ),
                                            backgroundColor: kGreenColor,
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
                          controlButton(
                            icon: Icons.replay,
                            color: kRedAccentColor,
                            onPressed:
                                model.hasStarted
                                    ? () {
                                      controller.resetTimer();
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
            const SizedBox(height: 15),
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
                  Strings.maxRhythmManualInvestment.replaceFirst(
                    '{0}',
                    model.duracionFase.toStringAsFixed(1),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 90, 122, 138),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                    backgroundColor: kPrimaryColor,
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
                        style: TextStyle(fontSize: 16, color: kWhiteColor),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.arrow_forward, color: kWhiteColor, size: 18),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget controlButton({
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
