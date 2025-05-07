import 'package:breath_bank/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewInvestmentMenuScreen extends StatefulWidget {
  const NewInvestmentMenuScreen({super.key});

  @override
  _NewInvestmentMenuScreenState createState() =>
      _NewInvestmentMenuScreenState();
}

class _NewInvestmentMenuScreenState extends State<NewInvestmentMenuScreen> {
  final DatabaseService db = DatabaseService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  double _sliderValue = 1;
  String _selectedOption = '';
  int _nivelInversor = 0;
  int _saldo = 0;
  int _rangoInferior = 2;
  int _rangoSuperior = 8;
  bool _isLoading = true;

  final Map<String, int> _duraciones = {
    'Express (1 minuto)': 1,
    'Breve (2 minutos)': 2,
    'Normal (5 minutos)': 5,
    'Extensa (10 minutos)': 10,
  };
  String? _duracionSeleccionada;

  @override
  void initState() {
    super.initState();
    _duracionSeleccionada = 'Breve (2 minutos)';
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final stats = await db.getUsuarioStats(userId: userId);
    final nivel = stats?['NivelInversor'] ?? 0;
    final saldo = stats?['Saldo'] ?? 0;

    setState(() {
      _nivelInversor = nivel;
      _saldo = saldo.toInt();
      final rangos = calcularRangos(_nivelInversor);
      _rangoInferior = rangos['rangoInferior']!;
      _rangoSuperior = rangos['rangoSuperior']!;
      _sliderValue = _rangoInferior.toDouble();
      _isLoading = false;
    });
  }

  Map<String, int> calcularRangos(int nivelInversor) {
    int rangoInferior = 2;
    int rangoSuperior = 8;

    if (nivelInversor > 1) {
      rangoInferior = (nivelInversor - 1) * 10;
      rangoSuperior = rangoInferior + 8;
    }

    return {'rangoInferior': rangoInferior, 'rangoSuperior': rangoSuperior};
  }

  Widget buildInfoCard({
    required String title,
    required int value,
    required Color numberColor,
    required Color textColor,
  }) {
    int maxValue = title == 'Nivel de Inversor' ? 11 : 100;

    return Card(
      color: const Color.fromARGB(255, 7, 71, 94),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 130,
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: numberColor,
                  ),
                ),
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: value / maxValue,
                      backgroundColor: Colors.white24,
                      color: numberColor,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0',
                          style: TextStyle(fontSize: 12, color: numberColor),
                        ),
                        Text(
                          maxValue.toString(),
                          style: TextStyle(fontSize: 10, color: numberColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
      appBar: const AppBarNewInvestmentMenu(),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildInfoCard(
                          title: 'Nivel de Inversor',
                          value: _nivelInversor,
                          numberColor: const Color.fromARGB(255, 223, 190, 0),
                          textColor: const Color.fromARGB(255, 243, 221, 96),
                        ),
                        buildInfoCard(
                          title: 'Saldo',
                          value: _saldo,
                          numberColor: Colors.green[400] ?? Colors.green,
                          textColor: Colors.green[200] ?? Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Text(
                      'Listón de Inversión: ${_sliderValue.toInt()}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 7, 71, 94),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_rangoInferior',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 7, 71, 94),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '$_rangoSuperior',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 7, 71, 94),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color.fromARGB(255, 7, 71, 94),
                        inactiveTrackColor: const Color.fromARGB(
                          255,
                          205,
                          213,
                          220,
                        ),
                        trackHeight: 10.0,
                        thumbColor: const Color.fromARGB(255, 7, 71, 94),
                        overlayColor: const Color.fromARGB(255, 90, 118, 142),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 14.0,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 20.0,
                        ),
                        trackShape: const RoundedRectSliderTrackShape(),
                        valueIndicatorShape:
                            const PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor: const Color.fromARGB(
                          255,
                          7,
                          71,
                          94,
                        ),
                      ),
                      child: Slider(
                        value: _sliderValue,
                        min: _rangoInferior.toDouble(),
                        max: _rangoSuperior.toDouble(),
                        divisions: _rangoSuperior - _rangoInferior,
                        label: _sliderValue.toInt().toString(),
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                        },
                      ),
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
                      value: _duracionSeleccionada,
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
                          _duraciones.keys.map((label) {
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
                          _duracionSeleccionada = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),

                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedOption = 'manual';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _selectedOption == 'manual'
                                      ? const Color.fromARGB(255, 7, 71, 94)
                                      : const Color.fromARGB(
                                        255,
                                        145,
                                        205,
                                        227,
                                      ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Manual',
                              style: TextStyle(
                                color:
                                    _selectedOption == 'manual'
                                        ? Colors.white
                                        : const Color.fromARGB(255, 7, 71, 94),
                                fontSize: _selectedOption == 'manual' ? 18 : 14,
                                fontWeight:
                                    _selectedOption == 'manual'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedOption = 'guiada';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _selectedOption == 'guiada'
                                      ? const Color.fromARGB(255, 7, 71, 94)
                                      : const Color.fromARGB(
                                        255,
                                        145,
                                        205,
                                        227,
                                      ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Guiada',
                              style: TextStyle(
                                color:
                                    _selectedOption == 'guiada'
                                        ? Colors.white
                                        : const Color.fromARGB(255, 7, 71, 94),
                                fontSize: _selectedOption == 'guiada' ? 18 : 14,
                                fontWeight:
                                    _selectedOption == 'guiada'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _selectedOption.isNotEmpty &&
                                    _duracionSeleccionada != null
                                ? () {
                                  final listonInversion = _sliderValue.toInt();
                                  final duracionMinutos =
                                      _duraciones[_duracionSeleccionada]!;

                                  final argumentos = {
                                    'liston': listonInversion,
                                    'duracion': duracionMinutos,
                                  };

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
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
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
              ),
    );
  }
}

class AppBarNewInvestmentMenu extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarNewInvestmentMenu({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: const Text(
        'Nueva Inversión',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
