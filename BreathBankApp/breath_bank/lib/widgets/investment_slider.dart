import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';

class InvestmentSlider extends StatelessWidget {
  final double sliderValue;
  final int rangoInferior;
  final int rangoSuperior;
  final ValueChanged<double> onChanged;

  const InvestmentSlider({
    super.key,
    required this.sliderValue,
    required this.rangoInferior,
    required this.rangoSuperior,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Listón de Inversión: ${sliderValue.toInt()}',
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$rangoInferior',
              style: const TextStyle(color: kPrimaryColor, fontSize: 12),
            ),
            Text(
              '$rangoSuperior',
              style: const TextStyle(color: kPrimaryColor, fontSize: 12),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: kPrimaryColor,
            inactiveTrackColor: const Color.fromARGB(255, 205, 213, 220),
            trackHeight: 10.0,
            thumbColor: kPrimaryColor,
            overlayColor: const Color.fromARGB(255, 90, 118, 142),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            trackShape: const RoundedRectSliderTrackShape(),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: kPrimaryColor,
          ),
          child: Slider(
            value: sliderValue,
            min: rangoInferior.toDouble(),
            max: rangoSuperior.toDouble(),
            divisions: rangoSuperior - rangoInferior,
            label: sliderValue.toInt().toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
