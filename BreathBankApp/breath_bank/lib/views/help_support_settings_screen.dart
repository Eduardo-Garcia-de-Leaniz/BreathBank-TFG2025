import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/help_strings.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/views/base_screen.dart';
import 'package:flutter/material.dart';

class HelpSupportSettingsScreen extends StatefulWidget {
  const HelpSupportSettingsScreen({super.key});

  @override
  State<HelpSupportSettingsScreen> createState() =>
      _HelpSupportSettingsScreenState();
}

class _HelpSupportSettingsScreenState extends State<HelpSupportSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showAppBar: true,
      canGoBack: true,
      title: HelpStrings.screenTitle,
      isScrollable: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.help, size: 30, color: kPrimaryColor),
                  const SizedBox(width: 8),
                  const Text(
                    HelpStrings.screenTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                HelpStrings.generalInfoTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                HelpStrings.descInfo,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              Text(
                HelpStrings.frequentQuestionsTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                HelpStrings.descFrequentQuestions,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              Text(
                HelpStrings.contactAndSupportTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                HelpStrings.descContactAndSupport,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              Text(
                HelpStrings.futureImplementationTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                HelpStrings.descFutureImplementation,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              Text(
                HelpStrings.greetingsTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                HelpStrings.descGreetings,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 16),
              Text(
                PrivacyStrings.date.replaceAll(
                  '{0}',
                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                ),
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
