// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';

class ManualInvestmentScreen extends StatefulWidget {
  const ManualInvestmentScreen({super.key});

  @override
  State<ManualInvestmentScreen> createState() => _ManualInvestmentScreenState();
}

class _ManualInvestmentScreenState extends State<ManualInvestmentScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _secondsElapsed = 0;
  int _phaseCounter = 0;
  int _breathCount = 0;
  bool _isRunning = false;
  bool _hasStarted = false;
  bool _isTimeUp = false;
  int _timeLimit = 0;
  int _investmentTime = 0;
  int _targetBreaths = 0;
  double _duracionFase = 0;
  int _listonInversion = 0;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

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
      final duracionMinutos = args['duracion'] as int;
      final listonInversion = args['liston'] as int;

      final duracionFase = 0.25 * listonInversion + 2.5;

      setState(() {
        _timeLimit = duracionMinutos * 60;
        _investmentTime = _timeLimit;
        _targetBreaths = calculateNumBreaths(listonInversion, duracionMinutos);
        _duracionFase = duracionFase;
        _listonInversion = listonInversion;
      });
    });
  }

  int calculateNumBreaths(int listonInversion, int duracionMinutos) {
    double duracionRespiracionCompleta = 2 * (0.25 * listonInversion + 2.5);
    int totalSegundos = duracionMinutos * 60;
    return (totalSegundos / duracionRespiracionCompleta).floor();
  }

  Future<void> _showCountdownOverlay() async {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    int countdown = 3;
    final textNotifier = ValueNotifier<int>(countdown);

    entry = OverlayEntry(
      builder:
          (_) => Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              alignment: Alignment.center,
              child: ValueListenableBuilder<int>(
                valueListenable: textNotifier,
                builder:
                    (_, value, __) => Text(
                      '$value',
                      style: const TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              ),
            ),
          ),
    );

    overlay.insert(entry);

    while (countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      countdown--;
      textNotifier.value = countdown;
    }

    entry.remove();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsElapsed >= _timeLimit) {
        _stopTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Tiempo finalizado!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        setState(() {
          _secondsElapsed++;
        });
      }
    });

    setState(() {
      _isRunning = true;
      _hasStarted = true;
      _isTimeUp = false;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    if (_secondsElapsed >= _timeLimit) {
      setState(() {
        _isTimeUp = true;
      });
    }
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsElapsed = 0;
      _breathCount = 0;
      _phaseCounter = 0;
      _isRunning = false;
      _hasStarted = false;
      _isTimeUp = false;
    });
  }

  void _markPhase() {
    if (_isRunning) {
      setState(() {
        _phaseCounter++;
        if (_phaseCounter % 2 == 0) {
          _breathCount++;
        }
      });
      _animationController.forward(from: 0);
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double get _timeProgress =>
      _timeLimit == 0 ? 0 : _secondsElapsed / _timeLimit;
  int get _remainingSeconds => _timeLimit - _secondsElapsed;

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLimit == 0) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 188, 252, 245),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
      appBar: const AppBarManualInvestment(),
      body: GestureDetector(
        onTap: _markPhase,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
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
                      value: 1 - _timeProgress,
                      strokeWidth: 14,
                      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _timeProgress == 1 ? Colors.green : Colors.blueAccent,
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_breathCount / $_targetBreaths',
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
                          _formatTime(_remainingSeconds),
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
                              icon: _isRunning ? Icons.pause : Icons.play_arrow,
                              color: Colors.green,
                              onPressed: () {
                                if (_isRunning) {
                                  _stopTimer();
                                } else if (_hasStarted) {
                                  _startTimer();
                                } else {
                                  _showCountdownOverlay();
                                }
                              },
                            ),
                            const SizedBox(width: 30),
                            _buildControlButton(
                              icon: Icons.replay,
                              color: Colors.red,
                              onPressed: _hasStarted ? _resetTimer : null,
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
                  Icon(
                    Icons.info,
                    size: 25,
                    color: Color.fromARGB(255, 90, 122, 138),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Ritmo máximo para suberar la inversión: \n${_duracionFase.toStringAsFixed(1)} segundos por inhalación/exhalación',
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
              if (_isTimeUp)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/dashboard/newinvestmentmenu/results',
                        arguments: {
                          'breath_result': _breathCount,
                          'breath_target': _targetBreaths,
                          'investment_time': _investmentTime,
                          'liston_inversion': _listonInversion,
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
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
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

class AppBarManualInvestment extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarManualInvestment({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF073C5E),
      title: const Text(
        'Inversión Manual',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
