import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/controllers/test2_controller.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:breath_bank/views/test_screen_template.dart';
import 'package:flutter/material.dart';

class Test2Screen extends StatefulWidget {
  const Test2Screen({super.key});

  @override
  Test2ScreenState createState() => Test2ScreenState();
}

class Test2ScreenState extends State<Test2Screen> {
  final Test2Controller controller = Test2Controller();
  final TextEditingController resultFieldController = TextEditingController();
  String resultValue = '';

  @override
  void initState() {
    super.initState();
    controller.loadDescriptionAndInstructions().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TestScreenTemplate(
      title: '2. Tiempo de 3 respiraciones',
      description: _buildDescription(),
      interactiveContent: _buildInteractiveContent(),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: kBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción de la prueba',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            controller.model.description,
            style: const TextStyle(fontSize: 16, color: kPrimaryColor),
          ),
          const SizedBox(height: 16),
          const Text(
            'Instrucciones:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 7, 71, 94),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.model.instructions,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 7, 71, 94),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(
          '${controller.elapsedSeconds}',
          style: const TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (controller.isRunning) {
                    controller.pauseClock((value) {
                      resultFieldController.text = value;
                      resultValue = value;
                    });
                  } else {
                    controller.startClock(() => setState(() {}));
                  }
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: Icon(
                controller.isRunning ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                controller.resetClock(() => setState(() {}));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Icon(Icons.stop, color: Colors.white, size: 30),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            style: const TextStyle(color: kPrimaryColor),
            controller: resultFieldController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Número de segundos',
              hintText: 'Edite el tiempo si lo desea',
            ),
            onChanged: (value) {
              resultValue = value;
            },
          ),
        ),
        const SizedBox(height: 40),
        AppButton(
          width: MediaQuery.of(context).size.width * 0.6,
          text: 'Siguiente',
          onPressed: () {
            if (controller.validateTestResult(resultValue)) {
              controller.model.testResult = int.parse(resultValue);
              Navigator.pop(context, controller.model.testResult);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, ingrese un número válido.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          backgroundColor: kPrimaryColor,
          height: 50,
          borderRadius: 12,
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
