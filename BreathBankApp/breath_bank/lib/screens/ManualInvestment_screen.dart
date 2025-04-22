import 'package:flutter/material.dart';

class ManualInvestmentScreen extends StatefulWidget {
  const ManualInvestmentScreen({Key? key}) : super(key: key);

  @override
  State<ManualInvestmentScreen> createState() => _ManualInvestmentScreenState();
}

class _ManualInvestmentScreenState extends State<ManualInvestmentScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar_ManualInvestment(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Inversión Manual',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aquí puedes realizar una inversión manualmente.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón
              },
              child: const Text('Realizar Inversión'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBar_ManualInvestment extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBar_ManualInvestment({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: Text(
        'Nueva Inversión',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
