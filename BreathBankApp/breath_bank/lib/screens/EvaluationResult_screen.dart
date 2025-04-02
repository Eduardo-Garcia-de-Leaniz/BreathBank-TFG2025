import 'package:flutter/material.dart';

class EvaluationresultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Evaluation Result Screen')),
      body: Center(
        child: Text(
          'Welcome to Evaluation Result Screen!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
