import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/legal_strings.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/views/base_screen.dart';
import 'package:flutter/material.dart';

class LegalAdviceSettingsScreen extends StatefulWidget {
  const LegalAdviceSettingsScreen({super.key});

  @override
  State<LegalAdviceSettingsScreen> createState() =>
      _LegalAdviceSettingsScreenState();
}

class _LegalAdviceSettingsScreenState extends State<LegalAdviceSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showAppBar: true,
      canGoBack: true,
      title: LegalStrings.screenTitle,
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
                  Icon(Icons.gavel, size: 30, color: kPrimaryColor),
                  SizedBox(width: 8),
                  Text(
                    LegalStrings.screenTitle,
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
                LegalStrings.generalInfoTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                LegalStrings.descInfo,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                LegalStrings.noMedicalAdviceTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                LegalStrings.descNoMedicalAdvice,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                LegalStrings.limitedResponsibilityTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                LegalStrings.descLimitedResponsibility,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                LegalStrings.academicUseAndInvestigationTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                LegalStrings.descAcademicUseAndInvestigation,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                LegalStrings.propertyRightsTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                LegalStrings.descPropertyRights,
                style: PrivacyStrings.descriptionStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                LegalStrings.changesToPolicyTitle,
                style: PrivacyStrings.titleStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                LegalStrings.descChangesToPolicy,
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
