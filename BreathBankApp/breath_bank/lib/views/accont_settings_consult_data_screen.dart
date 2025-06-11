import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/controllers/account_settings_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/views/base_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String noDisponible = "No disponible";

class AccountSettingsConsultDataScreen extends StatefulWidget {
  const AccountSettingsConsultDataScreen({super.key});

  @override
  State<AccountSettingsConsultDataScreen> createState() =>
      _AccountSettingsConsultDataScreenState();
}

class _AccountSettingsConsultDataScreenState
    extends State<AccountSettingsConsultDataScreen> {
  final AccountSettingsController controller = AccountSettingsController();
  final TextEditingController nameController = TextEditingController();

  late String email;
  late String creationDate = '';
  late String lastEvaluationDate = '';
  late String lastInvestmentDate = '';
  late int numEvaluations = 0;
  late int numInvestments = 0;
  late int investorLevel = 0;
  late int balance = 0;
  late String name = '';

  @override
  void initState() {
    super.initState();
    email = FirebaseAuth.instance.currentUser?.email ?? noDisponible;
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final data = await controller.getUsuarioStats();

      if (!mounted) return;

      setState(() {
        name = data?["Nombre"] ?? noDisponible;

        final Timestamp? fechaCreacion = data?["FechaCreación"];
        final Timestamp? fechaEval = data?["FechaÚltimaEvaluación"];
        final Timestamp? fechaInversion = data?["FechaUltimaInversión"];

        creationDate =
            fechaCreacion != null ? formatFecha(fechaCreacion) : noDisponible;
        lastEvaluationDate =
            fechaEval != null ? formatFecha(fechaEval) : noDisponible;
        lastInvestmentDate =
            fechaInversion != null ? formatFecha(fechaInversion) : noDisponible;

        numEvaluations = data?["NúmeroEvaluacionesRealizadas"] ?? 0;
        numInvestments = data?["NúmeroInversionesRealizadas"] ?? 0;
        investorLevel = data?["NivelInversor"] ?? 0;
        balance = data?["Saldo"] ?? 0;

        nameController.text = name;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al cargar los datos: $e"),
          backgroundColor: kRedAccentColor,
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
    return nameController.text != name;
  }

  Future<void> saveChanges() async {
    try {
      await controller.updateNombreYApellidos(nombre: nameController.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Datos actualizados correctamente"),
          backgroundColor: kGreenColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al actualizar los datos"),
          backgroundColor: kRedAccentColor,
        ),
      );
    }
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
    return BaseScreen(
      title: 'Consultar Datos',
      canGoBack: true,
      isScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Puedes editar tu nombre de usuario y consultar tus datos",
            style: TextStyle(fontSize: 16, color: kPrimaryColor),
          ),
          const SizedBox(height: 20),
          buildEditableField(
            label: "Nombre",
            controller: nameController,
            icon: const Icon(Icons.person),
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
              onPressed: () async {
                if (!hasChanges()) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No hay cambios que guardar"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                if (nameController.text.isEmpty) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("El campo Nombre no puede estar vacío"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                FocusScope.of(context).unfocus();
                await saveChanges();
                await cargarDatos();
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, '/dashboard');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
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
    );
  }
}
