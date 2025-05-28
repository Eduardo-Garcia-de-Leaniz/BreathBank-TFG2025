import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/widgets/investment_option_button.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/controllers/new_investment_menu_controller.dart';
import 'package:breath_bank/widgets/info_card_widget.dart';
import 'package:breath_bank/widgets/investment_slider.dart';
import 'package:breath_bank/views/base_screen.dart';

class NewInvestmentMenuScreen extends StatefulWidget {
  const NewInvestmentMenuScreen({super.key});

  @override
  State<NewInvestmentMenuScreen> createState() =>
      _NewInvestmentMenuScreenState();
}

class _NewInvestmentMenuScreenState extends State<NewInvestmentMenuScreen> {
  final NewInvestmentMenuController controller = NewInvestmentMenuController();

  bool isLoading = true;
  double sliderValue = 1;
  String selectedOption = '';
  String? selectedDuration;
  int nivelInversor = 0;
  int saldo = 0;
  int rangoInferior = 2;
  int rangoSuperior = 8;

  @override
  void initState() {
    super.initState();
    selectedDuration = controller.durations.keys.first;
    loadData();
  }

  Future<void> loadData() async {
    final stats = await controller.loadUserStats();
    setState(() {
      nivelInversor = stats['nivelInversor'];
      saldo = stats['saldo'];
      rangoInferior = stats['rangoInferior'];
      rangoSuperior = stats['rangoSuperior'];
      sliderValue = rangoInferior.toDouble();
      isLoading = false;
    });
  }

  void navigateToInvestment() {
    final listonInversion = sliderValue.toInt();
    final duracionMinutos = controller.durations[selectedDuration]!;

    final argumentos = {'liston': listonInversion, 'duracion': duracionMinutos};

    if (selectedOption == 'manual') {
      Navigator.pushNamed(
        context,
        '/dashboard/newinvestmentmenu/manual',
        arguments: argumentos,
      );
    } else if (selectedOption == 'guiada') {
      Navigator.pushNamed(
        context,
        '/dashboard/newinvestmentmenu/guided',
        arguments: argumentos,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: Strings.newInvestment,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoCard(
                        title: Strings.investorLevel,
                        value: nivelInversor.toString(),
                        numberColor: kLevelColor,
                        textColor: kLevelColor,
                        maxValue: 11,
                        width: 140,
                        height: 130,
                      ),
                      InfoCard(
                        title: Strings.saldo,
                        value: saldo.toString(),
                        numberColor: kGreenColor,
                        textColor: kGreenColor,
                        maxValue: 100,
                        width: 140,
                        height: 130,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InvestmentSlider(
                    sliderValue: sliderValue,
                    rangoInferior: rangoInferior,
                    rangoSuperior: rangoSuperior,
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    Strings.investmentDuration,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedDuration,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kPrimaryColor,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: const TextStyle(color: kWhiteColor, fontSize: 14),
                    dropdownColor: kPrimaryColor,
                    items:
                        controller.durations.keys.map((label) {
                          return DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: label,
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: kWhiteColor,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  InvestmentOptionButton(
                    label: Strings.manualInvestment,
                    isSelected: selectedOption == 'manual',
                    onPressed: () {
                      setState(() {
                        selectedOption = 'manual';
                      });
                    },
                  ),
                  InvestmentOptionButton(
                    label: Strings.guidedInvestment,
                    isSelected: selectedOption == 'guiada',
                    onPressed: () {
                      setState(() {
                        selectedOption = 'guiada';
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedOption.isNotEmpty) {
                          navigateToInvestment();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedOption.isNotEmpty
                                ? kPrimaryColor
                                : kDisabledColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Strings.startInvestment,
                            style: TextStyle(fontSize: 16, color: kWhiteColor),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.arrow_forward,
                            color: kWhiteColor,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
