import 'dart:async';
import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/Database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Test1Screen extends StatefulWidget {
  @override
  _Test1ScreenState createState() => _Test1ScreenState();
}

class _Test1ScreenState extends State<Test1Screen>
    with SingleTickerProviderStateMixin {
  Database_service db = Database_service();
  String userId = authenticationService.value.currentUser!.uid;

  String descripcion = "Cargando...";
  String instrucciones = "Cargando...";

  int test_result = 0;

  late AnimationController _controller;
  int _duration = 60; // duración del temporizador en segundos
  bool _isRunning = false;

  String get _timeString {
    final seconds =
        (_controller.duration!.inSeconds * _controller.value).round();
    return '$seconds s';
  }

  @override
  void initState() {
    super.initState();
    _cargarTextos();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _duration),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _isRunning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _cargarTextos() async {
    String desc = await rootBundle.loadString(
      'assets/texts/description_test1.txt',
    );
    String instr = await rootBundle.loadString(
      'assets/texts/instructions_test1.txt',
    );

    setState(() {
      descripcion = desc;
      instrucciones = instr;
    });
  }

  void _startAnimation() {
    setState(() {
      _isRunning = true;
    });
    _controller.reverse(
      from: _controller.value == 0.0 ? 1.0 : _controller.value,
    );
  }

  void _pauseAnimation() {
    _controller.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetAnimation() {
    _controller.reset();
    setState(() {
      _isRunning = false;
    });
  }

  bool validateTestResult(String test_result) {
    if (test_result.isEmpty || !RegExp(r'^\d+$').hasMatch(test_result)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, ingrese solo números.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar_Test1(),
      ),
      resizeToAvoidBottomInset: true,
      body: PageView(
        children: [
          // Primera página: Descripción del test
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: const Color.fromARGB(255, 188, 252, 245),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registro de respiraciones en reposo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(descripcion, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    Text(
                      'Instrucciones:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(instrucciones, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                top: MediaQuery.of(context).size.height * 3 / 8,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: const Color.fromARGB(255, 7, 71, 94),
                ),
              ),
            ],
          ),
          // Segunda página: Imagen de la prueba
          Container(
            color: const Color.fromARGB(255, 188, 252, 245),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Aquí va el dibujo de la prueba',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        'assets/images/LogoPrincipal_BreathBank-sin_fondo.png',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 8,
                  top: MediaQuery.of(context).size.height * 3 / 8,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: const Color.fromARGB(255, 7, 71, 94),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: MediaQuery.of(context).size.height * 3 / 8,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: const Color.fromARGB(255, 7, 71, 94),
                  ),
                ),
              ],
            ),
          ),
          // Tercera página: Contenido de la prueba con temporizador circular
          Container(
            color: const Color.fromARGB(255, 188, 252, 245),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    top: 20,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Respiraciones en reposo',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 7, 71, 94),
                        ),
                      ),
                      SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                final seconds =
                                    (_controller.duration!.inSeconds *
                                            _controller.value)
                                        .round();
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: _controller.value,
                                      strokeWidth: 100,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.teal,
                                      ),
                                    ),
                                    Text(
                                      '$seconds s',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              color: Colors.white,
                              _isRunning ? Icons.pause : Icons.play_arrow,
                            ),
                            label: Text(
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              _isRunning
                                  ? 'Pausar'
                                  : (_controller.value == 0.0
                                      ? 'Comenzar'
                                      : 'Reanudar'),
                            ),
                            onPressed:
                                _isRunning ? _pauseAnimation : _startAnimation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton.icon(
                            icon: Icon(Icons.refresh, color: Colors.white),
                            label: Text(
                              'Reiniciar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: _resetAnimation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          'Anota el número de respiraciones que has realizado:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Número de respiraciones',
                            labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 7, 71, 94),
                              fontSize: 16,
                            ),
                            hintText: 'Ingrese el número de respiraciones',
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 7, 71, 94),
                              fontSize: 16,
                            ),
                            iconColor: const Color.fromARGB(255, 7, 71, 94),
                          ),
                          onChanged: (value) {
                            if (validateTestResult(value)) {
                              test_result = int.parse(value);
                            } else {
                              test_result = 0;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          if (_controller.value == 0.0 && test_result > 0) {
                            Navigator.pop(context, test_result);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Siguiente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  left: 8,
                  top: MediaQuery.of(context).size.height * 3 / 8,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: const Color.fromARGB(255, 7, 71, 94),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppBar_Test1 extends StatelessWidget {
  const AppBar_Test1({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Test1',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
    );
  }
}
