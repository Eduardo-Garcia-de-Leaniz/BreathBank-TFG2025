import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/info_strings.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/views/base_screen.dart';
import 'package:breath_bank/widgets/image_logo.dart';
import 'package:flutter/material.dart';

class InfoAppSettingsScreen extends StatelessWidget {
  const InfoAppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      showAppBar: true,
      canGoBack: true,
      title: InfoStrings.screenTitle,
      isScrollable: true,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 30, color: kPrimaryColor),
                  SizedBox(width: 8),
                  Text(
                    InfoStrings.screenTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              Center(child: ImageLogo(imageWidth: 100, imageHeight: 100)),
              SizedBox(height: 16),
              Text(
                InfoStrings.appDescription,
                textAlign: TextAlign.justify,
                style: PrivacyStrings.descriptionStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
