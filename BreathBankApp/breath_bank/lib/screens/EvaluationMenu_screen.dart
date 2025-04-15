import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/Database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breath_bank/Authentication_service.dart';

class EvaluationMenuScreen extends StatefulWidget {
  const EvaluationMenuScreen({Key? key}) : super(key: key);

  @override
  State<EvaluationMenuScreen> createState() => _EvaluationMenuScreenState();
}

class _EvaluationMenuScreenState extends State<EvaluationMenuScreen>
    with SingleTickerProviderStateMixin {
  final Database_service db = Database_service();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  String formatFecha(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar_EvaluationMenu(),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 7, 71, 94),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color.fromARGB(255, 188, 252, 245),
              unselectedLabelColor: Colors.white,
              indicatorColor: const Color.fromARGB(255, 188, 252, 245),
              tabs: const [Tab(text: 'Historial'), Tab(text: 'Información')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHistorialEvaluaciones(),
                _buildInformacionGeneral(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialEvaluaciones() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: db.getUltimasEvaluaciones(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay evaluaciones disponibles.'));
        }

        final evaluaciones = snapshot.data!;
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: evaluaciones.length,
          itemBuilder: (context, index) {
            final evaluacion = evaluaciones[index];
            final fecha =
                evaluacion['Fecha'] != null
                    ? formatFecha(evaluacion['Fecha'] as Timestamp)
                    : 'Sin fecha';
            final nivelFinal = evaluacion['NivelInversorFinal'] ?? 'N/A';
            final resultados = evaluacion['resultado'] as Map<String, dynamic>?;

            return ExpansionTile(
              leading: Icon(Icons.assignment, color: Colors.teal),
              title: Text('Evaluación ${index + 1} ($fecha)'),
              childrenPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      'Nivel de inversor final: $nivelFinal',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Resultados de pruebas:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (resultados != null)
                  ...resultados.entries.map((entry) {
                    return ListTile(
                      dense: true,
                      title: Text(entry.key),
                      trailing: Text(entry.value.toString()),
                    );
                  }).toList()
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Sin resultados disponibles.'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildInformacionGeneral() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text(
        'Aquí encontrarás información general sobre las evaluaciones, cómo se realizan, '
        'qué aspectos se miden y cómo interpretar los resultados.\n\n'
        'Las evaluaciones son una herramienta útil para seguir tu progreso y entender '
        'tu nivel actual. Recuerda realizarlas con regularidad para obtener mejores '
        'resultados y recomendaciones personalizadas.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class AppBar_EvaluationMenu extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: Text(
        'Evaluaciones',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
