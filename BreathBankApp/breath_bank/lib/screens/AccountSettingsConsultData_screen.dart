import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/Database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingsModifyDataScreen extends StatefulWidget {
  const AccountSettingsModifyDataScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsModifyDataScreen> createState() =>
      _AccountSettingsModifyDataScreenState();
}

class _AccountSettingsModifyDataScreenState
    extends State<AccountSettingsModifyDataScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  final Database_service db = Database_service();
  final Authentication_service authenticationService = Authentication_service();

  // Simulación de datos estáticos (deberías reemplazar por datos reales de tu base de datos)
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final String email =
      FirebaseAuth.instance.currentUser?.email ?? "No disponible";
  late String name = '';
  late String surname = '';
  late String creationDate = '';
  late String lastEvaluationDate = '';
  late String lastInvestmentDate = '';
  late int numEvaluations = 0;
  late int numInvestments = 0;
  late int investorLevel = 0;
  late int balance = 0;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final data = await db.getUsuarioStats(userId: userId);

      setState(() {
        name = data?["Nombre"] ?? "No disponible";
        surname = data?["Apellidos"] ?? "No disponible";

        final Timestamp? fechaCreacion = data?["FechaCreación"];
        final Timestamp? fechaEval = data?["FechaÚltimaEvaluación"];
        final Timestamp? fechaInversion = data?["FechaUltimaInversión"];

        creationDate =
            fechaCreacion != null
                ? formatFecha(fechaCreacion)
                : "No disponible";
        lastEvaluationDate =
            fechaEval != null ? formatFecha(fechaEval) : "No disponible";
        lastInvestmentDate =
            fechaInversion != null
                ? formatFecha(fechaInversion)
                : "No disponible";

        numEvaluations = data?["NúmeroEvaluacionesRealizadas"] ?? 0;
        numInvestments = data?["NúmeroInversionesRealizadas"] ?? 0;
        investorLevel = data?["NivelInversor"] ?? 0;
        balance = data?["Saldo"] ?? 0;

        nameController.text = name;
        surnameController.text = surname;
      });
    } catch (e) {
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al cargar los datos: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatFecha(Timestamp timestamp) {
    final date = timestamp.toDate();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  bool hasChanges() {
    return nameController.text != name || surnameController.text != surname;
  }

  void saveChanges() async {
    try {
      await db.updateNombreYApellidos(
        userId: userId,
        nombre: nameController.text,
        apellidos: surnameController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al actualizar los datos"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Datos actualizados correctamente"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget buildEditableField({
    required String label,
    required TextEditingController controller,
    required Icon icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget buildReadOnlyField({
    required String label,
    required String value,
    required Icon icon,
  }) {
    return TextField(
      controller: TextEditingController(text: value),
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarModifyData(),
      body: Scrollbar(
        trackVisibility: true,
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(10),

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Puedes editar tu nombre y apellidos. El resto de campos no son editables.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 7, 71, 94),
                  ),
                ),
                const SizedBox(height: 20),
                buildEditableField(
                  label: "Nombre",
                  controller: nameController,
                  icon: const Icon(Icons.person),
                ),
                const SizedBox(height: 16),
                buildEditableField(
                  label: "Apellidos",
                  controller: surnameController,
                  icon: const Icon(Icons.person_outline),
                ),
                const SizedBox(height: 16),
                buildReadOnlyField(
                  label: "Email",
                  value: email,
                  icon: const Icon(Icons.email),
                ),
                const SizedBox(height: 16),
                buildReadOnlyField(
                  label: "Fecha de creación",
                  value: creationDate,
                  icon: const Icon(Icons.person_add),
                ),
                const SizedBox(height: 16),
                buildReadOnlyField(
                  label: "Fecha última evaluación",
                  value: lastEvaluationDate,
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
                const SizedBox(height: 16),
                buildReadOnlyField(
                  label: "Fecha última inversión",
                  value: lastInvestmentDate,
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
                const SizedBox(height: 16),
                buildReadOnlyField(
                  label: "Número de evaluaciones",
                  value: numEvaluations.toString(),
                  icon: const Icon(Icons.assignment),
                ),
                const SizedBox(height: 16),
                buildReadOnlyField(
                  label: "Número de inversiones",
                  value: numInvestments.toString(),
                  icon: const Icon(Icons.more_time),
                ),
                const SizedBox(height: 16),
                buildReadOnlyField(
                  label: "Nivel de inversor",
                  value: investorLevel.toString(),
                  icon: const Icon(Icons.military_tech),
                ),
                const SizedBox(height: 16),
                buildReadOnlyField(
                  label: "Saldo",
                  value: balance.toString(),
                  icon: const Icon(Icons.account_balance_wallet),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!hasChanges()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No hay cambios que guardar"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      if (nameController.text.isEmpty ||
                          surnameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Los campos Nombre y/o Apellidos no pueden estar vacíos",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      saveChanges();
                      FocusScope.of(context).unfocus();
                      cargarDatos();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Guardar Cambios",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}

class AppBarModifyData extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: const Text(
        'Consultar Datos',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
