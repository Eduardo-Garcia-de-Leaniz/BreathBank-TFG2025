import 'package:flutter/material.dart';
import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'base_screen.dart';

class GuidedInvestmentInfoScreen extends StatelessWidget {
  const GuidedInvestmentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return BaseScreen(
      title: Strings.guidedInvestmentTitle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 80, color: kPrimaryColor),
          const SizedBox(height: 24),
          Text(
            'Antes de empezar la inversión guiada, lee atentamente las instrucciones.',
            style: const TextStyle(fontSize: 18, color: kPrimaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/dashboard/newinvestmentmenu/guided',
                  arguments: args,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Comenzar inversión guiada',
                style: TextStyle(fontSize: 16, color: kWhiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
