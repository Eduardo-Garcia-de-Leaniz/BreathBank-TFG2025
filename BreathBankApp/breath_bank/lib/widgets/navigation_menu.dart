import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  final int currentIndex;

  const NavigationMenu({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      selectedItemColor: const Color.fromARGB(255, 188, 252, 245),
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/dashboard/evaluationmenu');
            break;
          case 1:
            Navigator.pushNamed(context, '/dashboard');
            break;
          case 2:
            Navigator.pushNamed(context, '/dashboard/investmentmenu');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment, size: 30),
          label: 'Evaluaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, size: 30),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_time, size: 30),
          label: 'Inversiones',
        ),
      ],
    );
  }
}
