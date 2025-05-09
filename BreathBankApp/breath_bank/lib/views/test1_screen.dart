import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/controllers/test1_controller.dart';
import 'package:breath_bank/views/test_screen_template.dart';

class Test1Screen extends StatefulWidget {
  const Test1Screen({super.key});

  @override
  Test1ScreenState createState() => Test1ScreenState();
}

class Test1ScreenState extends State<Test1Screen>
    with SingleTickerProviderStateMixin {
  final Test1Controller controller = Test1Controller();
  final TextEditingController resultFieldController = TextEditingController();
  String resultValue = '';

  @override
  void initState() {
    super.initState();
    controller.init(this);
    controller.loadDescriptionAndInstructions().then((_) {
      setState(() {});
    });

    controller.animationController.addListener(() {
      setState(
        () {},
      ); // Actualiza la UI cuando cambie el valor del temporizador
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
      title: 'Prueba 1',
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
            'Respiraciones en reposo',
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
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: controller.animationController.value,
                strokeWidth: 10,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            ),
            Text(
              '${controller.remainingTime}',
              style: const TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (controller.isRunning) {
                    controller.pauseClock();
                  } else {
                    controller.startClock();
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
              onPressed: controller.resetClock,
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
              labelText: 'Ingrese el número de respiraciones',
              hintText: 'Número de respiraciones',
            ),
            onChanged: (value) {
              resultValue = value;
            },
            enabled:
                controller.remainingTime ==
                0, // Habilita solo si el tiempo es 0
          ),
        ),
        const SizedBox(height: 40),
        AppButton(
          width: MediaQuery.of(context).size.width * 0.6,
          text: 'Siguiente',
          onPressed:
              controller.remainingTime == 0
                  ? () {
                    if (controller.model.validateTestResult(resultValue)) {
                      controller.model.testResult = int.parse(resultValue);
                      Navigator.pop(
                        context,
                        controller.model.testResult,
                      ); // Devuelve el resultado
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, ingrese un número válido.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                  : null, // Deshabilita el botón si el tiempo no es 0
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
