import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/views/base_screen.dart';
import 'package:flutter/material.dart';

class TestScreenTemplate extends StatelessWidget {
  final Widget description;
  final Widget interactiveContent;
  final String title;
  const TestScreenTemplate({
    super.key,
    required this.title,
    required this.description,
    required this.interactiveContent,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      canGoBack: false,
      title: title,
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            children: [
              Stack(
                children: [
                  Container(child: description),
                  const ArrowNextSymbol(),
                ],
              ),
              Stack(
                children: [
                  Container(child: interactiveContent),
                  const ArrowPreviousSymbol(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArrowPreviousSymbol extends StatelessWidget {
  const ArrowPreviousSymbol({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 1,
      top: MediaQuery.of(context).size.height * 3 / 8,
      child: const Icon(Icons.arrow_back_ios, color: kPrimaryColor),
    );
  }
}

class ArrowNextSymbol extends StatelessWidget {
  const ArrowNextSymbol({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 1,
      top: MediaQuery.of(context).size.height * 3 / 8,
      child: const Icon(Icons.arrow_forward_ios, color: kPrimaryColor),
    );
  }
}
