import 'package:breath_bank/widgets/arrow_next_symbol.dart';
import 'package:breath_bank/widgets/arrow_previous_symbol.dart';
import 'package:breath_bank/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'base_screen.dart';

class ManualInvestmentInfoScreen extends StatelessWidget {
  const ManualInvestmentInfoScreen({super.key});

  static const TextStyle titlesStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
  );

  static const TextStyle descStyle = TextStyle(
    fontSize: 14,
    color: kPrimaryColor,
  );

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final liston = args['liston'];
    final duracion = args['duracion'];

    return BaseScreen(
      title: Strings.manualInvestmentTitle,
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            children: [
              Stack(
                children: [
                  ArrowNextSymbol(),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Strings.manualInvestmentInfoTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Strings.investmentResume,
                          style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '- ${Strings.investmentBar}: $liston',
                          style: TextStyle(
                            fontSize: 15,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '- ${Strings.investmentDuration}: $duracion ${duracion == 1 ? "minuto" : "minutos"}',
                          style: TextStyle(
                            fontSize: 15,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 60),
                        Text(
                          Strings.investmentGuideStepsMessageTitle.replaceFirst(
                            '{0}',
                            'manual',
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Strings.investmentGuideStepsMessage,
                          style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        ),
                        const SizedBox(height: 60),
                        Text(
                          Strings.goToInvestment,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: kPrimaryColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/dashboard/newinvestmentmenu/manual',
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
                              Strings.startInvestment,
                              style: TextStyle(
                                fontSize: 16,
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                  FirstPageContent(
                    titlesStyle: titlesStyle,
                    descStyle: descStyle,
                  ),
                ],
              ),
              Stack(
                children: [
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                  SecondPageContent(
                    titlesStyle: titlesStyle,
                    descStyle: descStyle,
                  ),
                ],
              ),
              Stack(
                children: [
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                  ThirdPageContent(
                    titlesStyle: titlesStyle,
                    descStyle: descStyle,
                  ),
                ],
              ),
              Stack(
                children: [
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                  FourthPageContent(
                    titlesStyle: titlesStyle,
                    descStyle: descStyle,
                    args: args,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FourthPageContent extends StatelessWidget {
  const FourthPageContent({
    super.key,
    required this.titlesStyle,
    required this.descStyle,
    required this.args,
  });

  final TextStyle titlesStyle;
  final TextStyle descStyle;
  final Map<String, dynamic> args;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Strings.endManualInvestmentTitle,
            style: titlesStyle,
            textAlign: TextAlign.center,
          ),
          ImageWidget(
            imageWidth: 200,
            imageHeight: 250,
            photoString: 'assets/images/reloj_fin_inversion_manual.png',
          ),
          Text(
            Strings.endManualInvestmentDesc,
            style: descStyle,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/dashboard/newinvestmentmenu/manual',
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
                Strings.startInvestment,
                style: TextStyle(fontSize: 16, color: kWhiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThirdPageContent extends StatelessWidget {
  const ThirdPageContent({
    super.key,
    required this.titlesStyle,
    required this.descStyle,
  });

  final TextStyle titlesStyle;
  final TextStyle descStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Strings.duringManualInvestmentTitle,
            style: titlesStyle,
            textAlign: TextAlign.center,
          ),
          ImageWidget(
            imageWidth: 250,
            imageHeight: 250,
            photoString: 'assets/images/reloj_corriendo_inversion_manual.png',
          ),
          Text(
            Strings.duringManualInvestmentDesc,
            style: descStyle,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class SecondPageContent extends StatelessWidget {
  const SecondPageContent({
    super.key,
    required this.titlesStyle,
    required this.descStyle,
  });

  final TextStyle titlesStyle;
  final TextStyle descStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Strings.countdownManualInvestmentTitle,
            style: titlesStyle,
            textAlign: TextAlign.center,
          ),
          ImageWidget(
            imageWidth: 250,
            imageHeight: 250,
            photoString: 'assets/images/countdown.png',
          ),
          Text(
            Strings.countdownManualInvestmentDesc,
            style: descStyle,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class FirstPageContent extends StatelessWidget {
  const FirstPageContent({
    super.key,
    required this.titlesStyle,
    required this.descStyle,
  });

  final TextStyle titlesStyle;
  final TextStyle descStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Strings.beforeStartManualInvestmentTitle,
            style: titlesStyle,
            textAlign: TextAlign.center,
          ),
          ImageWidget(
            imageWidth: 250,
            imageHeight: 250,
            photoString: 'assets/images/reloj_inicio_inversion_manual.png',
          ),
          Text(
            Strings.beforeStartManualInvestmentDesc,
            style: descStyle,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
