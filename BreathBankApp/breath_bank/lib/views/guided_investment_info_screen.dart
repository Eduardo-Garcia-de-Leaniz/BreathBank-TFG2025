import 'package:breath_bank/widgets/arrow_next_symbol.dart';
import 'package:breath_bank/widgets/arrow_previous_symbol.dart';
import 'package:breath_bank/widgets/page_content.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'base_screen.dart';

class GuidedInvestmentInfoScreen extends StatelessWidget {
  const GuidedInvestmentInfoScreen({super.key});

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
      title: Strings.guidedInvestmentTitle,
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            children: [
              Stack(
                children: [
                  const ArrowNextSymbol(),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          Strings.guidedInvestmentInfoTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          Strings.investmentResume,
                          style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '- ${Strings.investmentBar}: $liston',
                          style: const TextStyle(
                            fontSize: 15,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '- ${Strings.investmentDuration}: $duracion ${duracion == 1 ? "minuto" : "minutos"}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 60),
                        Text(
                          Strings.investmentGuideStepsMessageTitle.replaceFirst(
                            '{0}',
                            'guiada',
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          Strings.investmentGuideStepsMessage,
                          style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        ),
                        const SizedBox(height: 60),
                        const Text(
                          Strings.goToInvestment,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: kPrimaryColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 20),
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
              const Stack(
                children: [
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                  PageContent(
                    imageHeight: 250,
                    imageWidth: 170,
                    titleText: Strings.beforeStartManualInvestmentTitle,
                    descText: Strings.beforeStartGuidedInvestmentDesc,
                    imagePath: 'assets/images/inicio_inversion_guiada.png',
                  ),
                ],
              ),
              const Stack(
                children: [
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                  PageContent(
                    imageHeight: 250,
                    imageWidth: 170,
                    titleText: Strings.countdownManualInvestmentTitle,
                    descText: Strings.countdownManualInvestmentDesc,
                    imagePath: 'assets/images/countdown_inversion_guiada.png',
                  ),
                ],
              ),
              const Stack(
                children: [
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                  PageContent(
                    imageHeight: 250,
                    imageWidth: 170,
                    titleText: Strings.duringManualInvestmentTitle,
                    descText: Strings.duringGuidedInvestmentDesc,
                    imagePath: 'assets/images/corriendo_inversion_guiada.png',
                  ),
                ],
              ),
              Stack(
                children: [
                  const ArrowPreviousSymbol(),
                  const ArrowNextSymbol(),
                  PageContent(
                    imageHeight: 250,
                    imageWidth: 190,
                    routeName: '/dashboard/newinvestmentmenu/guided',
                    isLastPage: true,
                    args: args,
                    titleText: Strings.endManualInvestmentTitle,
                    descText: Strings.endGuidedInvestmentDesc,
                    imagePath: 'assets/images/fin_inversion_guiada.png',
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
