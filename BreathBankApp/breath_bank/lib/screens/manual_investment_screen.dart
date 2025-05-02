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
  int _timeLimit = 0; // Será establecido dinámicamente
  int _targetBreaths = 0;

  @override
  void initState() {
    super.initState();
    // Obtenemos los argumentos cuando el widget ya está montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final duracionMinutos = args['duracion'] as int;
      final listonInversion = args['liston'] as int;
      setState(() {
        _timeLimit = duracionMinutos * 60;
        _targetBreaths = calculateNumBreaths(listonInversion, duracionMinutos);
      });
    });
  }

  int calculateNumBreaths(int listonInversion, int duracionMinutos) {
    // Aquí puedes implementar la lógica para calcular el número de respiraciones
    // según el valor de listonInversion y la duración en minutos.
    // Por ejemplo:
    return (listonInversion / duracionMinutos).toInt();
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
    });
  }

  void _stopTimer() {
    _timer?.cancel();
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
  double get _breathProgress => _breathCount / _targetBreaths;
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
                    SizedBox(height: 10),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
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
                    Text(
                      'Respiraciones',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 126, 172, 186),
                      ),
                    ),
                  ],
                ),
              ],
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
            const SizedBox(height: 30),
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
