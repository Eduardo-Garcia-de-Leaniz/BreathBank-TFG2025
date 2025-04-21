import 'package:breath_bank/Database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewInvestmentMenuScreen extends StatefulWidget {
  const NewInvestmentMenuScreen({Key? key}) : super(key: key);

  @override
  _NewInvestmentMenuScreenState createState() =>
      _NewInvestmentMenuScreenState();
}

class _NewInvestmentMenuScreenState extends State<NewInvestmentMenuScreen> {
  final Database_service db = Database_service();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  double _sliderValue = 1;
  String _selectedOption = '';
  int _nivelInversor = 0;
  int _rangoInferior = 2;
  int _rangoSuperior = 8;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final stats = await db.getUsuarioStats(userId: userId);
    final nivel = stats?['NivelInversor'] ?? 0;

    setState(() {
      _nivelInversor = nivel;
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

  Future<String?> obtenerNivelInversor() async {
    final stats = await db.getUsuarioStats(userId: userId);
    return stats?['NivelInversor']?.toString();
  }

  Future<String?> obtenerSaldo() async {
    final stats = await db.getUsuarioStats(userId: userId);
    return stats?['Saldo']?.toString();
  }

  Widget buildInfoCard({
    required String title,
    required Future<String?> futureValue,
    required Color numberColor,
    required Color textColor,
  }) {
    int maxValue = title == 'Nivel de Inversor' ? 11 : 100;

    return FutureBuilder<String?>(
      future: futureValue,
      builder: (context, snapshot) {
        final valueString = snapshot.data;
        final value = int.tryParse(valueString ?? '');

        return Card(
          color: const Color.fromARGB(255, 7, 71, 94),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            height: 130,
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                if (value != null)
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
                                style: TextStyle(
                                  fontSize: 12,
                                  color: numberColor,
                                ),
                              ),
                              Text(
                                maxValue.toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: numberColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Cargando...',
                      style: TextStyle(color: textColor),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
      appBar: AppBar_NewInvestmentMenu(),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
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
                          futureValue: obtenerNivelInversor(),
                          numberColor: const Color.fromARGB(255, 223, 190, 0),
                          textColor: const Color.fromARGB(255, 243, 221, 96),
                        ),
                        buildInfoCard(
                          title: 'Saldo',
                          futureValue: obtenerSaldo(),
                          numberColor: Colors.green[400] ?? Colors.green,
                          textColor: Colors.green[200] ?? Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Listón de Inversión:',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 7, 71, 94),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _rangoInferior.toString(),
                          style: TextStyle(color: Color(0xFF004B8D)),
                        ),
                        Text(
                          _rangoSuperior.toString(),
                          style: TextStyle(color: Color(0xFF004B8D)),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF004B8D),
                        inactiveTrackColor: const Color(0xFFB3CDE0),
                        trackHeight: 10.0,
                        thumbColor: const Color(0xFF007ACC),
                        overlayColor: const Color(0x33007ACC),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 14.0,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 24.0,
                        ),
                        trackShape: const RoundedRectSliderTrackShape(),
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
                    Center(
                      child: Text(
                        'Has seleccionado ${_sliderValue.toInt()} unidad${_sliderValue.toInt() == 1 ? '' : 'es'}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 7, 71, 94),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                                      ? const Color(0xFF004B8D)
                                      : const Color(0xFF7AAFD9),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Manual',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                                      ? const Color(0xFF004B8D)
                                      : const Color(0xFF7AAFD9),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Guiada',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                            _selectedOption.isNotEmpty
                                ? () {
                                  // Acción al comenzar inversión
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004B8D),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Comenzar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class AppBar_NewInvestmentMenu extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBar_NewInvestmentMenu({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: Text(
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
