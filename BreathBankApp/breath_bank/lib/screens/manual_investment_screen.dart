import 'dart:async';
import 'package:flutter/material.dart';

class ManualInvestmentScreen extends StatefulWidget {
  const ManualInvestmentScreen({Key? key}) : super(key: key);

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

  final int _timeLimit = 300; // 5 minutos
  final int _targetBreaths = 20;

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

  double get _timeProgress => _secondsElapsed / _timeLimit;
  double get _breathProgress => _breathCount / _targetBreaths;

  int get _remainingSeconds => _timeLimit - _secondsElapsed;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int listonInversion =
        ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const AppBar_ManualInvestment(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Tiempo restante',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 220,
                  width: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
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
                  height: 200,
                  width: 200,
                  child: CircularProgressIndicator(
                    value: 1 - _timeProgress,
                    strokeWidth: 14,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _timeProgress == 1 ? Colors.green : Colors.blueAccent,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF073C5E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tiempo',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$_breathCount / $_targetBreaths',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Respiraciones',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Respiraciones completas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: _breathProgress,
                  minHeight: 20,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$_breathCount / $_targetBreaths',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
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
            const SizedBox(height: 30),
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
      icon: Icon(icon, size: 26),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      onPressed: onPressed,
    );
  }
}

class AppBar_ManualInvestment extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBar_ManualInvestment({super.key});

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
