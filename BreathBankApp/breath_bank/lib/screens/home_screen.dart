import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BreathBank'),
        backgroundColor: const Color.fromARGB(255, 27, 180, 235),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        //padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 350,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 180, 46, 46),
        ),
        child: const Center(child: Text('Bienvenido a BreathBank!')),
      ),
      backgroundColor: const Color.fromARGB(255, 202, 226, 236),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 27, 180, 235),
      ),
    );
  }
}
