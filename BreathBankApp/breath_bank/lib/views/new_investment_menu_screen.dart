import 'package:breath_bank/constants/constants.dart';
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
  final NewInvestmentMenuController _controller = NewInvestmentMenuController();

  bool _isLoading = true;
  double _sliderValue = 1;
  String _selectedOption = '';
  String? _selectedDuration;
  int _nivelInversor = 0;
  int _saldo = 0;
  int _rangoInferior = 2;
  int _rangoSuperior = 8;

  @override
  void initState() {
    super.initState();
    _selectedDuration = _controller.durations.keys.first;
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await _controller.loadUserStats();
    setState(() {
      _nivelInversor = stats['nivelInversor'];
      _saldo = stats['saldo'];
      _rangoInferior = stats['rangoInferior'];
      _rangoSuperior = stats['rangoSuperior'];
      _sliderValue = _rangoInferior.toDouble();
      _isLoading = false;
    });
  }

  void _navigateToInvestment() {
    final listonInversion = _sliderValue.toInt();
    final duracionMinutos = _controller.durations[_selectedDuration]!;

    final argumentos = {'liston': listonInversion, 'duracion': duracionMinutos};

    if (_selectedOption == 'manual') {
      Navigator.pushNamed(
        context,
        '/dashboard/newinvestmentmenu/manual',
        arguments: argumentos,
      );
    } else if (_selectedOption == 'guiada') {
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
      title: 'Nueva Inversión',
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoCard(
                        title: 'Nivel de Inversor',
                        value: _nivelInversor.toString(),
                        numberColor: kLevelColor,
                        textColor: kLevelColor,
                        maxValue: 11,
                        width: 140,
                        height: 130,
                      ),
                      InfoCard(
                        title: 'Saldo',
                        value: _saldo.toString(),
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
                    sliderValue: _sliderValue,
                    rangoInferior: _rangoInferior,
                    rangoSuperior: _rangoSuperior,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Duración de Inversión:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedDuration,
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
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    dropdownColor: kPrimaryColor,
                    items:
                        _controller.durations.keys.map((label) {
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
                        _selectedDuration = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  InvestmentOptionButton(
                    label: 'Manual',
                    isSelected: _selectedOption == 'manual',
                    onPressed: () {
                      setState(() {
                        _selectedOption = 'manual';
                      });
                    },
                  ),
                  InvestmentOptionButton(
                    label: 'Guiada',
                    isSelected: _selectedOption == 'guiada',
                    onPressed: () {
                      setState(() {
                        _selectedOption = 'guiada';
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedOption.isNotEmpty &&
                            _selectedDuration != null) {
                          _navigateToInvestment();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _selectedOption.isNotEmpty &&
                                    _selectedDuration != null
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
                            'Comenzar Inversión',
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
