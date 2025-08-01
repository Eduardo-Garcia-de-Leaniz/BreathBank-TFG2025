import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/widgets/image_logo.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
              color: kPrimaryColor,
            ),
            const HomeContent(),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TitleHomeScreen(),
        ImageLogo(imageWidth: 200, imageHeight: 200),
        SubtitleHomeScreen(),
        SizedBox(height: 60),
        AuthButtons(),
      ],
    );
  }
}

class TitleHomeScreen extends StatelessWidget {
  const TitleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 60),
      child: Center(
        child: Text(
          Strings.appTitle,
          style: kTitleTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class SubtitleHomeScreen extends StatelessWidget {
  const SubtitleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(Strings.welcome, style: kSubtitleTextStyle);
  }
}

class AuthButtons extends StatelessWidget {
  const AuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonHeight = screenWidth / 6;

    return Column(
      children: [
        AppButton(
          text: Strings.login,
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/login',
              arguments: {'desdeNotificacion': false},
            );
          },
          width: screenWidth * 0.8,
          height: buttonHeight,
          backgroundColor: kPrimaryColor,
          textStyle: kButtonTextStyle,
        ),
        const SizedBox(height: 30),
        AppButton(
          text: Strings.register,
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          width: screenWidth * 0.8,
          height: buttonHeight,
          backgroundColor: kPrimaryColor,
          textStyle: kButtonTextStyle,
        ),
      ],
    );
  }
}
