import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/views/base_screen.dart';
import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showAppBar: true,
      canGoBack: true,
      title: PrivacyStrings.privacyPolicy,
      isScrollable: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 30,
                    color: kPrimaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    PrivacyStrings.privacyPolicy,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                PrivacyStrings.introductionTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                PrivacyStrings.introductionDescription,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                PrivacyStrings.informationWeCollectTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                PrivacyStrings.informationWeCollectDescription,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                PrivacyStrings.useOfInformationTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                PrivacyStrings.howWeUseYourInformationDescription,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                PrivacyStrings.dataProtectionTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                PrivacyStrings.dataProtectionDescription,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                PrivacyStrings.userRightsTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                PrivacyStrings.userRightsDescription,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                PrivacyStrings.changesToPolicyTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                PrivacyStrings.changesToPolicyDescription,
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
