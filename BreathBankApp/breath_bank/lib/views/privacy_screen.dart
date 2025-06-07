import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/views/base_screen.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _acceptedPrivacy = false;
  bool _consentFutureUse = false;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showAppBar: true,
      canGoBack: false,
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
              const SizedBox(height: 16),
              const Text(
                PrivacyStrings.acceptance,
                style: PrivacyStrings.descriptionStyle,
              ),

              const SizedBox(height: 32),
              CheckboxListTile(
                checkboxScaleFactor: 1.3,
                value: _acceptedPrivacy,
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                checkColor: kWhiteColor,
                activeColor: kGreenColor,
                onChanged: (value) {
                  setState(() {
                    _acceptedPrivacy = value ?? false;
                  });
                },
                title: const Text(
                  PrivacyStrings.acceptanceStatement,
                  style: PrivacyStrings.titleStyle,
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                checkboxScaleFactor: 1.3,
                value: _consentFutureUse,
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                checkColor: kWhiteColor,
                activeColor: kGreenColor,

                onChanged: (value) {
                  setState(() {
                    _consentFutureUse = value ?? false;
                  });
                },
                title: const Text(
                  PrivacyStrings.futureUseConsentStatement,
                  style: PrivacyStrings.titleStyle,
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: Strings.continueButton,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/evaluation");
                },
                isDisabled: !(_acceptedPrivacy && _consentFutureUse),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
