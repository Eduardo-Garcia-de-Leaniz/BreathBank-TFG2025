import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:breath_bank/widgets/countdown_overlay_widget.dart';
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
  final int testDuration = 60;
  int tapCount = 0;
  int breathCount = 0;

  @override
  void initState() {
    super.initState();
    controller.init(this);
    controller.loadDescriptionAndInstructions().then((_) {
      setState(() {});
    });

    controller.animationController.addListener(() {
      setState(() {});
      if (controller.remainingTime == 0 && breathCount > 0) {
        resultFieldController.text = breathCount.toString();
        resultValue = breathCount.toString();
      }
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
      title: '1. Nº respiraciones en reposo',
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
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.model.instructions,
            style: const TextStyle(fontSize: 16, color: kPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveContent() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (controller.isRunning && controller.remainingTime > 0) {
          tapCount++;
          if (tapCount % 2 == 0) {
            setState(() {
              breathCount++;
            });
          }
        }
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            'Llevas $breathCount respiracion${breathCount == 1 ? '' : 'es'}',
            style: const TextStyle(
              fontSize: 22,
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (controller.isRunning && controller.remainingTime > 0)
            Text(
              'Pulsa cuando termines de ${tapCount % 2 == 0 ? 'inspirar' : 'expirar'}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: kPrimaryColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: controller.animationController.value,
                  strokeWidth: 10,
                  backgroundColor:
                      controller.remainingTime == 60
                          ? const Color.fromARGB(255, 7, 71, 94)
                          : kRedAccentColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    kPrimaryColor,
                  ),
                ),
              ),
              Text(
                '${controller.remainingTime}',
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color:
                      controller.remainingTime < 10
                          ? kRedAccentColor
                          : kPrimaryColor,
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
                      if (controller.remainingTime < testDuration) {
                        controller.startClock();
                      } else {
                        CountdownOverlayWidget.show(
                          context: context,
                          initialCountdown: 3,
                          onCountdownComplete: () {
                            controller.startClock();
                            setState(() {});
                          },
                        );
                      }
                    }
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                child: Icon(
                  controller.isRunning ? Icons.pause : Icons.play_arrow,
                  color: kWhiteColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    controller.resetClock();
                    tapCount = 0;
                    breathCount = 0;
                    resultFieldController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kRedAccentColor,
                ),
                child: const Icon(Icons.stop, color: kWhiteColor, size: 30),
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
              enabled: controller.remainingTime == 0,
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
                        Navigator.pop(context, controller.model.testResult);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, ingrese un número válido.',
                            ),
                            backgroundColor: kRedAccentColor,
                          ),
                        );
                      }
                    }
                    : null, // Deshabilita el botón si el tiempo no es 0
            backgroundColor:
                controller.remainingTime == 0 ? kPrimaryColor : kDisabledColor,
            height: 50,
            borderRadius: 12,
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kWhiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
