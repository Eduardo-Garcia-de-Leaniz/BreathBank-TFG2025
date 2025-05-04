import 'dart:async';
import 'package:flutter/material.dart';

class ManualInvestmentScreen extends StatefulWidget {
  const ManualInvestmentScreen({super.key});

  @override
  State<ManualInvestmentScreen> createState() => _ManualInvestmentScreenState();
}

class _ManualInvestmentScreenState extends State<ManualInvestmentScreen> {
  Timer? _timer;
  int _secondsElapsed = 0;
  int _phaseCounter = 0;
  int _breathCount = 0;
  bool _isRunning = false;
  bool _hasStarted = false;
  bool _isTimeUp = false; // Nueva variable para saber si el tiempo ha terminado
  int _timeLimit = 0;
  int _targetBreaths = 0;
  double _duracionFase = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final duracionMinutos = args['duracion'] as int;
      final listonInversion = args['liston'] as int;

      final duracionFase = 0.25 * listonInversion + 2.5;

      setState(() {
        _timeLimit = duracionMinutos * 60;
        _targetBreaths = calculateNumBreaths(listonInversion, duracionMinutos);
        _duracionFase = duracionFase;
      });
    });
  }

  int calculateNumBreaths(int listonInversion, int duracionMinutos) {
    double duracionRespiracionCompleta = 2 * (0.25 * listonInversion + 2.5);
    int totalSegundos = duracionMinutos * 60;
    return (totalSegundos / duracionRespiracionCompleta).floor();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsElapsed >= _timeLimit) {
        _stopTimer();
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 250,
                  width: 250,
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
                  height: 210,
                  width: 210,
                  child: CircularProgressIndicator(
                    value: 1 - _timeProgress,
                    strokeWidth: 14,
                    backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _timeProgress == 1 ? Colors.green : Colors.blueAccent,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$_breathCount / $_targetBreaths',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 126, 172, 186),
                      ),
                    ),
                    const Text(
                      'Respiraciones',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 126, 172, 186),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Duración inhalación/exhalación: ${_duracionFase.toStringAsFixed(1)} segundos',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 90, 122, 138),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: Colors.black26,
                elevation: 8,
              ),
              onPressed: _markPhase,
              child: const Text(
                'Marcar Inspiración / Espiración',
                style: TextStyle(fontSize: 24),
              ),
            ),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  label: _hasStarted ? 'Restablecer' : 'Iniciar',
                  icon: _hasStarted ? Icons.replay : Icons.play_arrow,
                  color: _hasStarted ? Colors.redAccent : Colors.green,
                  onPressed: _hasStarted ? _resetTimer : _startTimer,
                ),
                _buildControlButton(
                  label: _isRunning ? 'Pausar' : 'Reanudar',
                  icon: _isRunning ? Icons.pause : Icons.play_arrow,
                  color: _isRunning ? Colors.orange : Colors.blueAccent,
                  onPressed:
                      _isRunning
                          ? _stopTimer
                          : (_hasStarted ? _startTimer : null),
                ),
              ],
            ),
            const Spacer(),
            if (_isTimeUp) // Mostrar el botón para pasar a la siguiente pantalla
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/investmentResult',
                      arguments: {
                        'breath_result': _breathCount,
                        'breath_target': _targetBreaths,
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
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(140, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Colors.black26,
        elevation: 6,
      ),
      icon: Icon(icon, size: 26, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      onPressed: onPressed,
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
        'Nueva Inversión',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
