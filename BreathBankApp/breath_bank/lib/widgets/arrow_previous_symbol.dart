import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';

class ArrowPreviousSymbol extends StatelessWidget {
  const ArrowPreviousSymbol({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 1,
      top: MediaQuery.of(context).size.height * 3 / 8,
      child: const Icon(Icons.arrow_back_ios, color: kPrimaryColor),
    );
  }
}
