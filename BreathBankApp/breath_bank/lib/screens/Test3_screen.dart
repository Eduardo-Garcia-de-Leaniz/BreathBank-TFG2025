import 'package:flutter/material.dart';

class Test3Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test3 Screen')),
      body: Center(
        child: Text('Welcome to Test3 Screen!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
