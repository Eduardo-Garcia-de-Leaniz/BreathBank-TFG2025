import 'package:breath_bank/widgets/arrow_next_symbol.dart';
import 'package:breath_bank/widgets/arrow_previous_symbol.dart';
import 'package:breath_bank/widgets/page_content.dart';
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
                  const ArrowNextSymbol(),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          Strings.manualInvestmentInfoTitle,
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
                            'manual',
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
              const Stack(
                children: [
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                  PageContent(
                    imageWidth: 200,
                    imageHeight: 200,
                    titleText: Strings.beforeStartManualInvestmentTitle,
                    descText: Strings.beforeStartManualInvestmentDesc,
                    imagePath:
                        'assets/images/reloj_inicio_inversion_manual.png',
                  ),
                ],
              ),
              const Stack(
                children: [
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                  PageContent(
                    imageWidth: 200,
                    imageHeight: 200,
                    titleText: Strings.countdownManualInvestmentTitle,
                    descText: Strings.countdownManualInvestmentDesc,
                    imagePath: 'assets/images/countdown.png',
                  ),
                ],
              ),
              const Stack(
                children: [
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                  PageContent(
                    imageWidth: 200,
                    imageHeight: 200,
                    titleText: Strings.duringManualInvestmentTitle,
                    descText: Strings.duringManualInvestmentDesc,
                    imagePath:
                        'assets/images/reloj_corriendo_inversion_manual.png',
                  ),
                ],
              ),
              Stack(
                children: [
                  const ArrowPreviousSymbol(),
                  const ArrowNextSymbol(),
                  PageContent(
                    imageWidth: 200,
                    imageHeight: 270,
                    routeName: '/dashboard/newinvestmentmenu/manual',
                    args: args,
                    isLastPage: true,
                    titleText: Strings.endManualInvestmentTitle,
                    descText: Strings.endManualInvestmentDesc,
                    imagePath: 'assets/images/reloj_fin_inversion_manual.png',
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
