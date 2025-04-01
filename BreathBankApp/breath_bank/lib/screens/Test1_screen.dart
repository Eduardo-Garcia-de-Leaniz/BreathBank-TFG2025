import 'package:flutter/material.dart';

class Test1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test1 Screen')),
      body: Center(
        child: Text('Welcome to Test1 Screen!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
