import 'package:breath_bank/Database_service.dart';
import 'package:flutter/material.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  EvaluationScreenState createState() => EvaluationScreenState();
}

class EvaluationScreenState extends State<EvaluationScreen> {
  Database_service db = Database_service();
  int result_test1 = 0;
  int result_test2 = 0;
  int result_test3 = 0;

  // Variables para almacenar el estado de las pruebas
  Map<String, bool> testCompleted = {
    'test1': false,
    'test2': false,
    'test3': false,
  };

  // Marca como completada una prueba y verifica si todas las pruebas están completas
  void completeTest(String testKey) {
    setState(() {
      testCompleted[testKey] = true;

      if (testCompleted.values.every((e) => e)) {
        Future.delayed(Duration(milliseconds: 300), () {
          allTestsDoneMessage();
        });
      }
    });
  }

  void allTestsDoneMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Felicidades! Has completado todas las pruebas 🎉'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Evita que el usuario vuelva atrás
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar_Evaluation(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTitleEvaluationScreen(),
                    const SizedBox(height: 16),
                    TextEvaluationScreen(),
                    const SizedBox(height: 30),
                    TextProgressionBar(testCompleted: testCompleted),
                    ProgressionBar(testCompleted: testCompleted),
                    const SizedBox(height: 50),
                    Center(
                      child: Column(
                        children: [
                          BtnsTest(
                            context,
                            'Prueba 1',
                            '/evaluation/test1',
                            'test1',
                          ),
                          const SizedBox(height: 40),
                          BtnsTest(
                            context,
                            'Prueba 2',
                            '/evaluation/test2',
                            'test2',
                          ),
                          const SizedBox(height: 40),
                          BtnsTest(
                            context,
                            'Prueba 3',
                            '/evaluation/test3',
                            'test3',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              BtnNext(testCompleted: testCompleted),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 188, 252, 245),
      ),
    );
  }

  Widget BtnsTest(
    BuildContext context,
    String testName,
    String route,
    String testKey,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          testCompleted[testKey]!
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: testCompleted[testKey]! ? Colors.green : Colors.grey,
          size: 30,
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed:
              testCompleted[testKey]!
                  ? null
                  : () async {
                    final resultado = await Navigator.pushNamed(context, route);
                    if (resultado is int) {
                      setState(() {
                        switch (testKey) {
                          case 'test1':
                            result_test1 = resultado;
                            break;
                          case 'test2':
                            result_test2 = resultado;
                            break;
                          case 'test3':
                            result_test3 = resultado;
                            break;
                        }
                      });
                    }
                    completeTest(testKey);
                  },

          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 45.0,
            ),
            backgroundColor: const Color.fromARGB(255, 7, 71, 94),
            foregroundColor: Colors.white,
          ),
          child: Text(
            testName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class BtnNext extends StatelessWidget {
  const BtnNext({super.key, required this.testCompleted});

  final Map<String, bool> testCompleted;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed:
              testCompleted.values.every((e) => e)
                  ? () {
                    Navigator.of(context).pushNamed('/evaluation/result');
                  }
                  : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 32.0,
            ),
            backgroundColor: const Color.fromARGB(255, 7, 71, 94),
            foregroundColor: Colors.white,
          ),
          child: const Text('Continuar'),
        ),
      ),
    );
  }
}

class ProgressionBar extends StatelessWidget {
  const ProgressionBar({super.key, required this.testCompleted});

  final Map<String, bool> testCompleted;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LinearProgressIndicator(
          value: testCompleted.values.where((e) => e).length / 3,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
          minHeight: 30,
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              '${(testCompleted.values.where((e) => e).length / 3 * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TextProgressionBar extends StatelessWidget {
  const TextProgressionBar({super.key, required this.testCompleted});

  final Map<String, bool> testCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        'Has superado ${testCompleted.values.where((e) => e).length} de 3 pruebas',
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 7, 71, 94),
        ),
      ),
    );
  }
}

class TextEvaluationScreen extends StatelessWidget {
  const TextEvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'A continuación se presentan 3 pruebas muy sencillas para valorar tus capacidades pulmonares. '
      'Se recomienda realizar las pruebas en orden',
      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 7, 71, 94)),
    );
  }
}

class TextTitleEvaluationScreen extends StatelessWidget {
  const TextTitleEvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Evaluación',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}

class AppBar_Evaluation extends StatelessWidget {
  const AppBar_Evaluation({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Evaluación',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
    );
  }
}
