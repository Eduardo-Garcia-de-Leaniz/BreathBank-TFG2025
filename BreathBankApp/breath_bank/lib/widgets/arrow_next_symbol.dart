import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';

class ArrowNextSymbol extends StatelessWidget {
  const ArrowNextSymbol({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 1,
      top: MediaQuery.of(context).size.height * 3 / 8,
      child: const Icon(Icons.arrow_forward_ios, color: kPrimaryColor),
    );
  }
}
