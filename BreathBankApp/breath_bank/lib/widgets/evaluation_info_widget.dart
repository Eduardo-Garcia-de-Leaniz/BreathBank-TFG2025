import 'package:flutter/material.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/constants/strings.dart';

class EvaluationInfoWidget extends StatelessWidget {
  const EvaluationInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Strings.evaluationInfoTitle, style: PrivacyStrings.titleStyle),
            SizedBox(height: 16),
            Text(
              Strings.evaluationInfo,
              style: PrivacyStrings.descriptionStyle,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
