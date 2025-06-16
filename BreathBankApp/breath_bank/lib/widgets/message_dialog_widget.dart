import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;

  const MessageDialog({
    super.key,
    required this.title,
    required this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: Text(message, style: const TextStyle(color: Colors.white)),
      actions: actions,
    );
  }
}

Future<void> showCustomMessageDialog({
  required BuildContext context,
  required String title,
  required String message,
  required List<Widget> actions,
}) {
  return showDialog(
    context: context,
    builder:
        (context) =>
            MessageDialog(title: title, message: message, actions: actions),
  );
}
