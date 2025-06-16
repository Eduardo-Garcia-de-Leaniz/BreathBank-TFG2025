import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';

class CountdownOverlay extends StatefulWidget {
  final int initialCountdown;
  final VoidCallback onCountdownComplete;

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
        // ignore: deprecated_member_use
        color: kPrimaryColor.withOpacity(0.8),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Comienza a inspirar en',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<int>(
              valueListenable: textNotifier,
              builder:
                  (_, value, __) => Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
