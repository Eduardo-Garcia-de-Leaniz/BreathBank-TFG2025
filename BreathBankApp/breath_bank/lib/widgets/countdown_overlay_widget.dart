import 'package:flutter/material.dart';
import 'countdown_widget.dart';

class CountdownOverlayWidget {
  static void show({
    required BuildContext context,
    required int initialCountdown,
    required VoidCallback onCountdownComplete,
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder:
          (_) => CountdownOverlay(
            initialCountdown: initialCountdown,
            onCountdownComplete: () {
              overlayEntry.remove();
              onCountdownComplete();
            },
          ),
    );
    overlay.insert(overlayEntry);
  }
}
