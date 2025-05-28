import 'package:breath_bank/views/base_screen.dart';
import 'package:breath_bank/widgets/arrow_next_symbol.dart';
import 'package:breath_bank/widgets/arrow_previous_symbol.dart';
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
