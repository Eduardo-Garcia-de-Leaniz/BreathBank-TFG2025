// Importaciones
import 'dart:async';
import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/Database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Pantalla principal
class Test3Screen extends StatefulWidget {
  @override
  Test3ScreenState createState() => Test3ScreenState();
}

class Test3ScreenState extends State<Test3Screen> {
  final Database_service db = Database_service();
  final String userId = authenticationService.value.currentUser!.uid;
  final TextEditingController resultFieldController = TextEditingController();

  String descripcion = "Cargando...";
  String instrucciones = "Cargando...";
  int test_result = 0;
  int numBreaths = 0;
  bool isRunning = false;

  final GlobalKey<BreathingAnimationWidgetState> _breathingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    chargeDescriptionAndInstructions();
  }

  Future<void> chargeDescriptionAndInstructions() async {
    String desc = await rootBundle.loadString(
      'assets/texts/description_test3.txt',
    );
    String instr = await rootBundle.loadString(
      'assets/texts/instructions_test3.txt',
    );

    setState(() {
      descripcion = desc;
      instrucciones = instr;
    });
  }

  void startOrPauseBreathing() {
    setState(() {
      isRunning = !isRunning;
    });

    if (isRunning) {
      _breathingKey.currentState?.resume();
    } else {
      _breathingKey.currentState?.pause();
      final last = _breathingKey.currentState?.getCurrentBreathCount() ?? 0;
      resultFieldController.text = last.toString();
      test_result = last;
    }
  }

  void resetBreathing() {
    setState(() {
      isRunning = false;
      numBreaths = 0;
      test_result = 0;
      resultFieldController.clear();
    });
    _breathingKey.currentState?.reset();
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar_Test3(),
        ),
        body: PageView(
          children: [
            // Página 1: descripción
            Stack(
              children: [
                Container(
                  color: const Color.fromARGB(255, 188, 252, 245),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TestTitleText(),
                      SizedBox(height: 25),
                      Text(
                        descripcion,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF07475E),
                        ),
                      ),
                      SizedBox(height: 16),
                      InstructionsTitleText(),
                      SizedBox(height: 8),
                      Text(
                        instrucciones,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF07475E),
                        ),
                      ),
                    ],
                  ),
                ),
                ArrowNextSymbol(),
              ],
            ),

            // Página 2: recordatorio visual
            Container(
              color: const Color.fromARGB(255, 188, 252, 245),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          '¡Recuerda!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF07475E),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Una respiración consta de dos partes, inspiración y espiración...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF07475E),
                          ),
                        ),
                        SizedBox(height: 30),
                        Image.asset(
                          'assets/images/LogoPrincipal_BreathBank-sin_fondo.png',
                          height: 250,
                        ),
                      ],
                    ),
                  ),
                  ArrowPreviousSymbol(),
                  ArrowNextSymbol(),
                ],
              ),
            ),

            // Página 3: test
            Container(
              color: const Color.fromARGB(255, 188, 252, 245),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Prueba de respiraciones guiada',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF07475E),
                          ),
                        ),
                        SizedBox(height: 10),
                        BreathingAnimationWidget(key: _breathingKey),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(
                                isRunning ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              label: Text(
                                isRunning ? 'Pausar' : 'Comenzar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: startOrPauseBreathing,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton.icon(
                              icon: Icon(Icons.refresh, color: Colors.white),
                              label: Text(
                                'Reiniciar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: resetBreathing,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        LabelTestResultText(),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: TextField(
                            controller: resultFieldController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Número última respiración',
                              hintText: 'Edite el número si lo desea',
                            ),
                            onChanged:
                                (value) =>
                                    test_result = int.tryParse(value) ?? 0,
                          ),
                        ),
                        SizedBox(height: 30),
                        BtnNext(test_result: test_result),
                      ],
                    ),
                  ),
                  ArrowPreviousSymbol(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreathingAnimationWidget extends StatefulWidget {
  const BreathingAnimationWidget({Key? key}) : super(key: key);

  @override
  BreathingAnimationWidgetState createState() =>
      BreathingAnimationWidgetState();
}

class BreathingAnimationWidgetState extends State<BreathingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isInhaling = true;
  int _breathCount = 1;
  Duration _currentDuration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    // Inicia con una duración inicial de 3 segundos (para inhalar + exhalar)
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // Inicia con 3 segundos
    )..addListener(() {
      setState(() {});
    });

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isInhaling = true;
        _breathCount++;

        double newDuration = 4.0 + ((_breathCount - 1) * 0.2);
        _currentDuration = Duration(seconds: newDuration.toInt());
        _controller.duration = _currentDuration;

        _controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        _isInhaling = false;
        _controller.reverse();
      }
    });
  }

  void pause() => _controller.stop();

  void resume() {
    if (!_controller.isAnimating) {
      if (_isInhaling) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void reset() {
    _controller.stop();
    _controller.reset();
    _breathCount = 1;
    _currentDuration = Duration(seconds: 4);
    _controller.duration = _currentDuration;
    _isInhaling = true;
    setState(() {});
  }

  int getCurrentBreathCount() => _breathCount;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _isInhaling
                          ? Colors.teal
                          : const Color.fromARGB(255, 224, 22, 22),
                  boxShadow: [
                    BoxShadow(
                      color: (_isInhaling
                              ? Colors.tealAccent
                              : const Color.fromARGB(255, 213, 82, 82))
                          .withOpacity(0.5),
                      blurRadius: 25,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          _isInhaling ? "Inhalar" : "Exhalar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text("Respiración $_breathCount", style: TextStyle(fontSize: 18)),
        Text(
          //"${_currentDuration.inSeconds} segundos",
          "${_controller.duration?.inSeconds ?? 0} segundos",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}

class ArrowNextSymbol extends StatelessWidget {
  const ArrowNextSymbol({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      top: MediaQuery.of(context).size.height * 3 / 8,
      child: Icon(
        Icons.arrow_forward_ios,
        color: const Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}

class ArrowPreviousSymbol extends StatelessWidget {
  const ArrowPreviousSymbol({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 5,
      top: MediaQuery.of(context).size.height * 3 / 8,
      child: Icon(
        Icons.arrow_back_ios,
        color: const Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}

class LabelTestResultText extends StatelessWidget {
  const LabelTestResultText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Text(
        'Última respiración completa:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 7, 71, 94),
        ),
      ),
    );
  }
}

class BtnNext extends StatelessWidget {
  const BtnNext({super.key, required this.test_result});

  final int test_result;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (test_result > 0) {
          Navigator.pop(context, test_result);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Debes indicar el tiempo para continuar.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 7, 71, 94),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        'Siguiente',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class InstructionsTitleText extends StatelessWidget {
  const InstructionsTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Instrucciones:',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}

class TestTitleText extends StatelessWidget {
  const TestTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Prueba de respiraciones guiada',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}

class AppBar_Test3 extends StatelessWidget {
  const AppBar_Test3({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Prueba de respiraciones guiada',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
    );
  }
}
