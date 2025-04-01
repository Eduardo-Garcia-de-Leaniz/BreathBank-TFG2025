import 'package:flutter/material.dart';

class Test2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test2 Screen')),
      body: Center(
        child: Text('Welcome to Test2 Screen!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
