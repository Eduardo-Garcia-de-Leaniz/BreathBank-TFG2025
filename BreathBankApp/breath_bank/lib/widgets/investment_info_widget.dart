import 'package:flutter/material.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/constants/strings.dart';

class InvestmentInfoWidget extends StatelessWidget {
  const InvestmentInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Strings.investmentInfoTitle, style: PrivacyStrings.titleStyle),
            SizedBox(height: 16),
            Text(
              Strings.investmentInfo,
              style: PrivacyStrings.descriptionStyle,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
