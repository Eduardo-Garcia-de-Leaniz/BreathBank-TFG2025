import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/controllers/test3_controller.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:breath_bank/views/test_screen_template.dart';
import 'package:breath_bank/widgets/breathing_animation_widget.dart';
import 'package:breath_bank/widgets/countdown_overlay_widget.dart';
import 'package:flutter/material.dart';

class Test3Screen extends StatefulWidget {
  const Test3Screen({super.key});

  @override
  Test3ScreenState createState() => Test3ScreenState();
}

class Test3ScreenState extends State<Test3Screen> {
  final Test3Controller controller = Test3Controller();
  final GlobalKey<BreathingAnimationWidgetState> breathingKey = GlobalKey();
  bool showCountdown = false;

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
      title: Strings.test3Title,
      description: description(),
      interactiveContent: interactiveContent(),
    );
  }

  Widget description() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: kBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            Strings.description,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            Strings.test3Description,
            style: const TextStyle(fontSize: 15, color: kPrimaryColor),
          ),
          const SizedBox(height: 15),
          const Text(
            Strings.instructions,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            Strings.test3Instructions,
            style: const TextStyle(fontSize: 15, color: kPrimaryColor),
          ),
          const SizedBox(height: 15),
          const Text(
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
        const SizedBox(height: 10),
        BreathingAnimationWidget(
          key: breathingKey,
          initialDuration: 3,
          incrementPerBreath: 0.5,
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (controller.isRunning) {
                    controller.startOrPauseBreathing(breathingKey);
                  } else {
                    if (!showCountdown) {
                      CountdownOverlayWidget.show(
                        context: context,
                        initialCountdown: 3,
                        onCountdownComplete: () {
                          setState(() {
                            showCountdown = true;
                            controller.startOrPauseBreathing(breathingKey);
                          });
                        },
                      );
                    } else {
                      controller.startOrPauseBreathing(breathingKey);
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
                  controller.resetBreathing(breathingKey);
                  showCountdown = false;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: kRedAccentColor),
              child: const Icon(Icons.stop, color: kWhiteColor, size: 30),
            ),
          ],
        ),

        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            controller: controller.resultFieldController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: Strings.test3Label,
              hintText: Strings.test3Hint,
            ),
            onChanged: (value) {
              controller.model.testResult = int.tryParse(value) ?? 0;
            },
          ),
        ),
        const SizedBox(height: 50),
        AppButton(
          width: MediaQuery.of(context).size.width * 0.6,
          text: Strings.next,
          onPressed: () {
            if (controller.validateTestResult(
              controller.resultFieldController.text,
            )) {
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
