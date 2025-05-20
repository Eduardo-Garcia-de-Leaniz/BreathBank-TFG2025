import 'package:flutter/material.dart';
import 'package:breath_bank/constants/constants.dart';

class BreathingAnimationWidget extends StatefulWidget {
  final double initialDuration;
  final double incrementPerBreath;

  const BreathingAnimationWidget({
    super.key,
    required this.initialDuration,
    required this.incrementPerBreath,
  });

  @override
  BreathingAnimationWidgetState createState() =>
      BreathingAnimationWidgetState();
}

class BreathingAnimationWidgetState extends State<BreathingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isInhaling = true;
  bool _isRunning =
      false; // Nueva variable para controlar si la animación está activa
  int _breathCount = 1;
  late double _currentDuration; // Duración actual de la inhalación/exhalación

  @override
  void initState() {
    super.initState();
    _currentDuration =
        widget
            .initialDuration; // Inicializa con la duración inicial pasada por parámetro
    _initAnimation();
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _currentDuration.toInt()),
    )..addListener(() {
      setState(() {});
    });

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (!_isRunning) return;

      if (status == AnimationStatus.completed) {
        _isInhaling = false;
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _isInhaling = true;
        _breathCount++;
        _increaseDuration();
        _controller.forward();
      }
    });
  }

  void _increaseDuration() {
    _currentDuration += widget.incrementPerBreath;
    _controller.duration = Duration(seconds: _currentDuration.toInt());
  }

  void pause() {
    _isRunning = false;
    _controller.stop();
  }

  void resume() {
    if (!_isRunning) {
      _isRunning = true;
      if (_isInhaling) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void reset() {
    _isRunning = false; // Detiene la animación
    _controller.stop(); // Detiene el controlador
    _controller.reset(); // Reinicia el controlador
    _currentDuration = widget.initialDuration; // Restablece la duración inicial
    _controller.duration = Duration(
      seconds: _currentDuration.toInt(),
    ); // Actualiza la duración
    _breathCount = 1; // Reinicia el contador de respiraciones
    _isInhaling = true; // Restablece el estado inicial
    setState(() {}); // Actualiza la interfaz
  }

  int getCurrentBreathCount() => _breathCount;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isInhaling ? kPrimaryColor : Colors.red,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          _isInhaling ? "Inhalar" : "Exhalar",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text("Respiración $_breathCount", style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
