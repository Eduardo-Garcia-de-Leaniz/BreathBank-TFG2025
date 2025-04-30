import 'dart:async';
import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Test2Screen extends StatefulWidget {
  const Test2Screen({super.key});

  @override
  Test2ScreenState createState() => Test2ScreenState();
}

class Test2ScreenState extends State<Test2Screen> {
  DatabaseService db = DatabaseService();
  String userId = authenticationService.value.currentUser!.uid;
  final TextEditingController resultFieldController = TextEditingController();
  String resultValue = '';
  String description = "Cargando...";
  String instructions = "Cargando...";
  int testResult = 0;
  int elapsedSeconds = 0;
  Timer? timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    chargeDescriptionAndInstructions();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> chargeDescriptionAndInstructions() async {
    String desc = await rootBundle.loadString(
      'assets/texts/description_test2.txt',
    );
    String instr = await rootBundle.loadString(
      'assets/texts/instructions_test2.txt',
    );

    setState(() {
      description = desc;
      instructions = instr;
    });
  }

  void startClock() {
    setState(() {
      isRunning = true;
    });

    timer ??= Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        elapsedSeconds += 1;
      });
    });
  }

  void pauseClock() {
    setState(() {
      isRunning = false;
      timer?.cancel();
      timer = null;
      resultFieldController.text = elapsedSeconds.toString();
      resultValue = resultFieldController.text;
      testResult = int.tryParse(resultValue) ?? 0;
    });
  }

  void resetClock() {
    timer?.cancel();
    timer = null;
    setState(() {
      isRunning = false;
      elapsedSeconds = 0;
      resultFieldController.clear();
      resultValue = '';
      testResult = 0;
    });
  }

  bool validateTestResult(String testResult) {
    if (testResult.isEmpty || !RegExp(r'^\d+$').hasMatch(testResult)) {
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBarTest2(),
        ),
        resizeToAvoidBottomInset: true,
        body: PageView(
          children: [
            // Página 1: descripción
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: const Color.fromARGB(255, 188, 252, 245),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TestTitleText(),
                        SizedBox(height: 25),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                        SizedBox(height: 16),
                        InstructionsTitleText(),
                        SizedBox(height: 8),
                        Text(
                          instructions,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ArrowNextSymbol(),
              ],
            ),

            // Página 2: imagen
            Container(
              color: const Color.fromARGB(255, 188, 252, 245),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '¡Recuerda!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Una respiración consta de dos partes, inspiración y espiración. '
                            'La respiración comenzará cuando se empieza a coger aire, y no habrá terminado '
                            'hasta que se vuelva a inspirar. No se deben realizar pausas entre ambas fases ni entre respiraciones. '
                            'La respiración debe ser cómoda y relajada, no debe aparecer fatiga.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 7, 71, 94),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Image.asset(
                          'assets/images/LogoPrincipal_BreathBank-sin_fondo.png',
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.contain,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          child: TestTitleText(),
                        ),
                        SizedBox(height: 30),
                        ClockWidget(
                          elapsedSeconds: elapsedSeconds,
                          isRunning: isRunning,
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(
                                color: Colors.white,
                                isRunning ? Icons.pause : Icons.play_arrow,
                              ),
                              label: Text(
                                isRunning
                                    ? 'Pausar'
                                    : (elapsedSeconds == 0
                                        ? 'Comenzar'
                                        : 'Reanudar'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: isRunning ? pauseClock : startClock,
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
                              onPressed: resetClock,
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
                        SizedBox(height: 50),
                        LabelTestResultText(),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: TextField(
                            controller: resultFieldController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Número de segundos',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 7, 71, 94),
                                fontSize: 16,
                              ),
                              hintText: 'Edite el tiempo si lo desea',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 7, 71, 94),
                                fontSize: 16,
                              ),
                            ),
                            onChanged: (value) {
                              resultValue = value;
                            },
                            onEditingComplete: () {
                              if (validateTestResult(resultValue)) {
                                testResult = int.parse(resultValue);
                              } else {
                                testResult = 0;
                              }
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (validateTestResult(resultValue)) {
                              testResult = int.parse(resultValue);
                            } else {
                              testResult = 0;
                            }
                            if (testResult > 0) {
                              Navigator.pop(context, testResult);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Debes indicar el tiempo para continuar.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              7,
                              71,
                              94,
                            ),
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

class LabelTestResultText extends StatelessWidget {
  const LabelTestResultText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Text(
        'Tiempo en realizar las 3 respiraciones: Introduce el número y cierre el teclado antes de pulsar en Siguiente',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 7, 71, 94),
        ),
      ),
    );
  }
}

class ClockWidget extends StatelessWidget {
  final int elapsedSeconds;
  final bool isRunning;

  const ClockWidget({
    super.key,
    required this.elapsedSeconds,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$elapsedSeconds s',
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        AnimatedArrowsWidget(isRunning: isRunning),
      ],
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
      'Tiempo empleado en realizar 3 respiraciones',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}

class AppBarTest2 extends StatelessWidget {
  const AppBarTest2({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Tiempo empleado en realizar 3 respiraciones',
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

class AnimatedArrowsWidget extends StatefulWidget {
  final bool isRunning;
  const AnimatedArrowsWidget({super.key, required this.isRunning});

  @override
  AnimatedArrowsWidgetState createState() => AnimatedArrowsWidgetState();
}

class AnimatedArrowsWidgetState extends State<AnimatedArrowsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late List<Animation<double>> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    fadeAnimation = List.generate(3, (index) {
      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    if (widget.isRunning) {
      controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedArrowsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning && !controller.isAnimating) {
      controller.repeat();
    } else if (!widget.isRunning && controller.isAnimating) {
      controller.stop();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildArrow(int index) {
    return FadeTransition(
      opacity: fadeAnimation[index],
      child: Icon(
        Icons.arrow_forward_ios,
        size: 50,
        color: const Color.fromARGB(255, 242, 173, 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, buildArrow),
    );
  }
}
