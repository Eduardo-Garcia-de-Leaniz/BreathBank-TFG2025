import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/controllers/test2_controller.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:breath_bank/views/test_screen_template.dart';
import 'package:breath_bank/widgets/countdown_overlay_widget.dart';
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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TestScreenTemplate(
      title: Strings.test2Title,
      description: description(),
      interactiveContent: interactiveContent(),
    );
  }

  Widget description() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: kBackgroundColor,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.description,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            Strings.test2Description,
            style: TextStyle(fontSize: 15, color: kPrimaryColor),
          ),
          SizedBox(height: 15),
          Text(
            Strings.instructions,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            Strings.test2Instructions,
            style: TextStyle(fontSize: 15, color: kPrimaryColor),
          ),
          SizedBox(height: 15),
          Text(
            Strings.swipeToStart,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget interactiveContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!controller.isRunning && controller.elapsedSeconds == 0)
          Text(
            Strings.startInvestmentText
                .replaceAll('{0}', 'azul')
                .replaceAll('{1}', 'comenzar'),
            style: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: kPrimaryColor,
            ),
          ),
        if (!controller.isRunning && controller.elapsedSeconds > 0)
          Container(
            padding: const EdgeInsets.only(left: 35.0, right: 35.0),
            child: const Text(
              Strings.finishEvaluationText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: kPrimaryColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
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
                    if (controller.elapsedSeconds > 0) {
                      controller.startClock(() => setState(() {}));
                    } else {
                      CountdownOverlayWidget.show(
                        context: context,
                        initialCountdown: 3,
                        onCountdownComplete: () {
                          controller.startClock(() => setState(() {}));
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
              labelText: Strings.test2Label,
              hintText: Strings.test2Hint,
            ),
            onChanged: (value) {
              resultValue = value;
            },
          ),
        ),
        const SizedBox(height: 40),
        AppButton(
          width: MediaQuery.of(context).size.width * 0.6,
          text: Strings.next,
          onPressed: () {
            if (controller.validateTestResult(resultValue)) {
              controller.model.testResult = int.parse(resultValue);
              Navigator.pop(context, controller.model.testResult);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Strings.testError),
                  backgroundColor: kRedAccentColor,
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
            color: kWhiteColor,
          ),
        ),
      ],
    );
  }
}
