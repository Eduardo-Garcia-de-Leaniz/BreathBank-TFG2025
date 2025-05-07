import 'package:breath_bank/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InvestmentResultScreen extends StatelessWidget {
  final DatabaseService db = DatabaseService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  InvestmentResultScreen({super.key});

  Future<bool> guardarInversion(
    int liston,
    int resultado,
    int tiempo,
    bool exito,
  ) async {
    try {
      await db.addNuevaInversion(
        userId: userId,
        fechaInversion: DateTime.now(),
        listonInversion: liston,
        resultadoInversion: resultado,
        tiempoInversion: tiempo,
        superada: exito,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarSaldo(int resultado) async {
    try {
      await db.updateInversionesYSaldo(
        userId: userId,
        saldo: resultado,
        fechaUltimaInversion: DateTime.now(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final breathResult = args['breath_result'] as int;
    final breathTarget = args['breath_target'] as int;
    final investmentTime = args['investment_time'] as int;
    final listonInversion = args['liston_inversion'] as int;

    final breathSecondsResult =
        (breathResult == 0)
            ? '0'
            : (investmentTime / breathResult).toInt().toString();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 188, 252, 245),
        appBar: const AppBarInvestmentResult(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                '¡Inversión completada!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (breathResult > 0 && breathResult <= breathTarget)
                _buildResultMessageBox(
                  icon: Icons.check_circle,
                  message: '¡Has superado con éxito la inversión!',
                  backgroundColor: Colors.green.shade900,
                  textColor: Colors.green.shade100,
                )
              else if (breathResult > breathTarget)
                _buildResultMessageBox(
                  icon: Icons.warning_amber_rounded,
                  message: 'No has superado el objetivo. ¡Sigue practicando!',
                  backgroundColor: Colors.red.shade900,
                  textColor: Colors.red.shade100,
                ),
              const SizedBox(height: 8),
              const Text(
                'Aquí están los resultados de tu ejercicio de inversión:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // RESULTADOS DE LA INVERSIÓN
              Expanded(
                child: ListView(
                  children: [
                    _buildResultCard(
                      icon: Icons.timelapse,
                      title: 'Duración',
                      value: '$investmentTime segundos',
                    ),
                    _buildResultCard(
                      icon: Icons.done_outline_sharp,
                      title: 'Respiraciones realizadas',
                      value: '$breathResult',
                    ),
                    _buildResultCard(
                      icon: Icons.straighten,
                      title: 'Límite de respiraciones',
                      value: '$breathTarget',
                    ),
                    _buildResultCard(
                      icon: Icons.timer_outlined,
                      title: 'Tiempo por respiración',
                      value: '$breathSecondsResult segundos',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (await guardarInversion(
                      listonInversion,
                      breathResult,
                      investmentTime,
                      breathResult <= breathTarget,
                    )) {
                      if (await actualizarSaldo(breathResult)) {}
                    } else {
                      // Si hubo un error al actualizar el saldo, muestra un mensaje de error
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al actualizar el saldo.'),
                        ),
                      );
                    }
                    // Si la actualización del saldo fue exitosa, navega al dashboard
                    if (!context.mounted) return;
                    Navigator.pushNamed(context, '/dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Volver',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      color: const Color.fromARGB(255, 7, 71, 94),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildResultMessageBox({
    required IconData icon,
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: textColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarInvestmentResult extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarInvestmentResult({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF073C5E),
      title: const Text(
        'Resultados de Inversión',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
