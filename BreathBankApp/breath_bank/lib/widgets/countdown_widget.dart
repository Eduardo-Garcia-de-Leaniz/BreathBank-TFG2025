import 'package:flutter/material.dart';

class CountdownOverlay extends StatefulWidget {
  final int initialCountdown; // Tiempo inicial del countdown
  final VoidCallback onCountdownComplete; // Acción al finalizar el countdown

  const CountdownOverlay({
    super.key,
    required this.initialCountdown,
    required this.onCountdownComplete,
  });

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay> {
  late int countdown;
  late ValueNotifier<int> textNotifier;

  @override
  void initState() {
    super.initState();
    countdown = widget.initialCountdown;
    textNotifier = ValueNotifier<int>(countdown);
    _startCountdown();
  }

  Future<void> _startCountdown() async {
    while (countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      countdown--;
      textNotifier.value = countdown;
    }
    widget.onCountdownComplete();
  }

  @override
  void dispose() {
    textNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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
    );
  }
}
