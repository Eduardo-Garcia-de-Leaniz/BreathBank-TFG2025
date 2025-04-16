import 'package:flutter/material.dart';

class EvaluationresultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int inversorLevel = args['nivelInversorFinal'];
    final int resultTest1 = args['result_test1'];
    final int resultTest2 = args['result_test2'];
    final int resultTest3 = args['result_test3'];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBarEvaluationResults(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                '¡Evaluación completada!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 7, 71, 94),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Tu nivel de inversor es:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 7, 71, 94),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      inversorLevel.toString(),
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    ResultItem(
                      icon: Icons.looks_one_rounded,
                      label: 'Prueba 1',
                      value: resultTest1,
                      unit: 'respiraciones',
                    ),
                    ResultItem(
                      icon: Icons.looks_two_rounded,
                      label: 'Prueba 2',
                      value: resultTest2,
                      unit: 'segundos',
                    ),
                    ResultItem(
                      icon: Icons.looks_3_rounded,
                      label: 'Prueba 3',
                      value: resultTest3,
                      unit: 'respiraciones',
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Ir a mi Dashboard',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),

        backgroundColor: const Color.fromARGB(255, 188, 252, 245),
      ),
    );
  }
}

class ResultItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final String unit;

  const ResultItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Color.fromARGB(255, 7, 71, 94), size: 30),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 7, 71, 94),
          ),
        ),
        trailing: Text(
          '$value $unit',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }
}

class AppBarEvaluationResults extends StatelessWidget {
  const AppBarEvaluationResults({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Resultados Evaluación',
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
