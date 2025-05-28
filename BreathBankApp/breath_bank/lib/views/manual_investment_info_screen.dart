import 'package:breath_bank/widgets/arrow_next_symbol.dart';
import 'package:breath_bank/widgets/arrow_previous_symbol.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'base_screen.dart';

class ManualInvestmentInfoScreen extends StatelessWidget {
  const ManualInvestmentInfoScreen({super.key});

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
                    padding: const EdgeInsets.only(left: 15.0, right: 30.0),
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
                        const SizedBox(height: 30),
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
                      ],
                    ),
                  ),
                ],
              ),
              // Añadir las páginas aquí
            ],
          ),
        ),
      ), // Puedes añadir aquí más instrucciones si lo deseas
    );
  }
}
