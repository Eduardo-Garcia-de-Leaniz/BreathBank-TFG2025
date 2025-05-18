import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onTap,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
