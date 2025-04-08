import 'dart:async';
import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/Database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Test3Screen extends StatefulWidget {
  @override
  Test3ScreenState createState() => Test3ScreenState();
}

class Test3ScreenState extends State<Test3Screen> {
  Database_service db = Database_service();
  String userId = authenticationService.value.currentUser!.uid;

  final TextEditingController resultFieldController = TextEditingController();
  String resultValue = '';

  String descripcion = "Cargando...";
  String instrucciones = "Cargando...";

  int test_result = 0;

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
      descripcion = desc;
      instrucciones = instr;
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
      test_result = int.tryParse(resultValue) ?? 0;
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
      test_result = 0;
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
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar_Test1(),
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
                          descripcion,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 7, 71, 94),
                          ),
                        ),
                        SizedBox(height: 16),
                        InstructionsTitleText(),
                        SizedBox(height: 8),
                        Text(
                          instrucciones,
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
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Tiempo empleado en realizar 3 respiraciones',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 71, 94),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ClockWidget(
                          elapsedSeconds: elapsedSeconds,
                          isRunning: isRunning,
                        ),
                        SizedBox(height: 10),
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
                        SizedBox(height: 70),
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
                                test_result = int.parse(resultValue);
                              } else {
                                test_result = 0;
                              }
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        SizedBox(height: 40),
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

class LabelTestResultText extends StatelessWidget {
  const LabelTestResultText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Text(
        'Tiempo en realizar las 3 respiraciones:',
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BreathingAnimationWidget(isRunning: isRunning),
        const SizedBox(width: 20),
        Text(
          '$elapsedSeconds s',
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
      'Tiempo empleado en realizar 3 respiraciones',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 7, 71, 94),
      ),
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

class BreathingAnimationWidget extends StatefulWidget {
  final bool isRunning;
  const BreathingAnimationWidget({super.key, required this.isRunning});

  @override
  _BreathingAnimationWidgetState createState() =>
      _BreathingAnimationWidgetState();
}

class _BreathingAnimationWidgetState extends State<BreathingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    if (widget.isRunning) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant BreathingAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isRunning && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0xFF64FFDA), Color(0xFF00BFA5)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.tealAccent.withOpacity(0.5),
                  blurRadius: 25,
                  spreadRadius: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
