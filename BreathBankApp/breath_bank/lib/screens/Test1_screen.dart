import 'dart:async';
import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/Database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Test1Screen extends StatefulWidget {
  @override
  Test1ScreenState createState() => Test1ScreenState();
}

class Test1ScreenState extends State<Test1Screen>
    with SingleTickerProviderStateMixin {
  Database_service db = Database_service();
  String userId = authenticationService.value.currentUser!.uid;

  String descripcion = "Cargando...";
  String instrucciones = "Cargando...";

  int test_result = 0;

  late AnimationController animation_controller;
  int test_time = 60;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    chargeDescriptionAndInstructions();

    animation_controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: test_time),
    );

    animation_controller.addListener(() {
      setState(() {});
    });

    animation_controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isRunning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    animation_controller.dispose();
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
      descripcion = desc;
      instrucciones = instr;
    });
  }

  void startClock() {
    setState(() {
      isRunning = true;
    });
    animation_controller.reverse(
      from:
          animation_controller.value == 0.0 ? 1.0 : animation_controller.value,
    );
  }

  void pauseClock() {
    animation_controller.stop();
    setState(() {
      isRunning = false;
    });
  }

  void resetClock() {
    animation_controller.reset();
    setState(() {
      isRunning = false;
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
    return WillPopScope(
      onWillPop: () async => false, // Evita que el usuario vuelva atrás
      child: Scaffold(
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
                      TestTitleText(),
                      SizedBox(height: 25),
                      Text(descripcion, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      InstructionsTitleText(),
                      SizedBox(height: 8),
                      Text(instrucciones, style: TextStyle(fontSize: 16)),
                    ],
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
                        Text(
                          'Respiraciones en reposo',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                        SizedBox(height: 20),
                        ClockWidget(animation_controller: animation_controller),
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
                                    : (animation_controller.value == 0.0
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
                        SizedBox(height: 40),
                        LabelTestResultText(),
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
                            // Cambiar para que no salga el mensaje cada vez que se escriba
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
                        BtnNext(
                          animation_controller: animation_controller,
                          test_result: test_result,
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

class BtnNext extends StatelessWidget {
  const BtnNext({
    super.key,
    required this.animation_controller,
    required this.test_result,
  });

  final AnimationController animation_controller;
  final int test_result;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (animation_controller.value == 0.0 && test_result > 0) {
          Navigator.pop(context, test_result);
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

class LabelTestResultText extends StatelessWidget {
  const LabelTestResultText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Text(
        'Anota el número de respiraciones que has realizado:',
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
  const ClockWidget({super.key, required this.animation_controller});

  final AnimationController animation_controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: AnimatedBuilder(
            animation: animation_controller,
            builder: (context, child) {
              final seconds =
                  (animation_controller.duration!.inSeconds *
                          animation_controller.value)
                      .round();
              return Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: animation_controller.value,
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
      left: 8,
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
      right: 8,
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
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class TestTitleText extends StatelessWidget {
  const TestTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Registro de respiraciones en reposo',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class AppBar_Test1 extends StatelessWidget {
  const AppBar_Test1({super.key});

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
