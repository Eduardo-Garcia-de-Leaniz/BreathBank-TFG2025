import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color numberColor;
  final Color textColor;
  final int maxValue;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.numberColor,
    required this.textColor,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;

    return Card(
      color: const Color.fromARGB(255, 7, 71, 94),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 130,
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 13, color: textColor)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  valueDouble.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: numberColor,
                  ),
                ),
                LinearProgressIndicator(
                  value: (valueDouble / maxValue).clamp(0.0, 1.0),
                  backgroundColor: Colors.white24,
                  color: numberColor,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0',
                      style: TextStyle(
                        fontSize: 12,
                        color: numberColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      maxValue.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: numberColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
