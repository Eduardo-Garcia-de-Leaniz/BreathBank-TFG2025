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
                        numberColor: const Color.fromARGB(255, 223, 190, 0),
                        textColor: const Color.fromARGB(255, 243, 221, 96),
                        maxValue: 11,
                        width: 140,
                        height: 130,
                      ),
                      InfoCard(
                        title: 'Saldo',
                        value: _saldo.toString(),
                        numberColor: Colors.green[400] ?? Colors.green,
                        textColor: Colors.green[200] ?? Colors.green,
                        maxValue: 100,
                        width: 140,
                        height: 130,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 20),
                  const Text(
                    'Duración de Inversión:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 7, 71, 94),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedDuration,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 7, 71, 94),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    dropdownColor: const Color.fromARGB(255, 7, 71, 94),
                    items:
                        _controller.durations.keys.map((label) {
                          return DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: label,
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                  const SizedBox(height: 30),
                  InvestmentOptionButton(
                    label: 'Manual',
                    isSelected: _selectedOption == 'manual',
                    onPressed: () {
                      setState(() {
                        _selectedOption = 'manual';
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  InvestmentOptionButton(
                    label: 'Guiada',
                    isSelected: _selectedOption == 'guiada',
                    onPressed: () {
                      setState(() {
                        _selectedOption = 'guiada';
                      });
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _selectedOption.isNotEmpty &&
                                  _selectedDuration != null
                              ? _navigateToInvestment
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 7, 71, 94),
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
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
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
