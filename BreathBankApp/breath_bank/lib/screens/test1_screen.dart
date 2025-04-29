import 'dart:async';
import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/Database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Test1Screen extends StatefulWidget {
  const Test1Screen({super.key});

  @override
  Test1ScreenState createState() => Test1ScreenState();
}

class Test1ScreenState extends State<Test1Screen>
    with SingleTickerProviderStateMixin {
  Database_service db = Database_service();
  String userId = authenticationService.value.currentUser!.uid;
  final TextEditingController resultFieldController = TextEditingController();
  String resultValue = '';
  String description = "Cargando...";
  String instructions = "Cargando...";
  int testResult = 0;
  late AnimationController animationController;
  int testDuration = 60;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    chargeDescriptionAndInstructions();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: testDuration),
    );

    animationController.addListener(() {
      setState(() {});
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isRunning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> chargeDescriptionAndInstructions() async {
    String desc = await rootBundle.loadString(
      'assets/texts/description_test1.txt',
    );
    String instr = await rootBundle.loadString(
      'assets/texts/instructions_test1.txt',
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
    animationController.reverse(
      from: animationController.value == 0.0 ? 1.0 : animationController.value,
    );
  }

  void pauseClock() {
    animationController.stop();
    setState(() {
      isRunning = false;
    });
  }

  void resetClock() {
    animationController.reset();
    setState(() {
      isRunning = false;
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBarTest1(),
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
                            color: const Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                        SizedBox(height: 16),
                        InstructionsTitleText(),
                        SizedBox(height: 8),
                        Text(
                          instructions,
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ArrowNextSymbol(),
              ],
            ),
            // Segunda página: Imagen de la prueba
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
                            color: const Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Una respiración consta de dos partes, inspiración y espiración. '
                            'La respiración comenzará cuando se empieza a coger aire, y no habrá terminado '
                            'hasta que se vuelva a inspirar. No se deben realizar pausas entre ambas fases ni entre respiraciones.'
                            'La respiración debe ser cómoda y relajada, no debe aparecer fatiga.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 7, 71, 94),
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
            // Tercera página: Contenido de la prueba con temporizador circular
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
                        TestTitleText(),
                        SizedBox(height: 10),
                        ClockWidget(animationController: animationController),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(
                                color: Colors.white,
                                isRunning ? Icons.pause : Icons.play_arrow,
                              ),
                              label: Text(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                isRunning
                                    ? 'Pausar'
                                    : (animationController.value == 0.0
                                        ? 'Comenzar'
                                        : 'Reanudar'),
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
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: TextField(
                            controller: resultFieldController,
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
                              resultValue = value;
                            },
                            onEditingComplete: () {
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
                            if (animationController.value == 0.0 &&
                                testResult > 0) {
                              Navigator.pop(context, testResult);
                            } else if (animationController.value != 0.0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Debe esperar a que se complete el tiempo antes de continuar.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'El número de respiraciones debe ser mayor de 0.',
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
        'Anota el número de respiraciones que has realizado: Introduce el número y cierre el teclado antes de pulsar en Siguiente',
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
  const ClockWidget({super.key, required this.animationController});

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              final seconds =
                  (animationController.duration!.inSeconds *
                          animationController.value)
                      .round();
              return Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: animationController.value,
                    strokeWidth: 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                  Text(
                    '$seconds s',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ),
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
      'Respiraciones en reposo',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}

class AppBarTest1 extends StatelessWidget {
  const AppBarTest1({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Respiraciones en reposo',
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
