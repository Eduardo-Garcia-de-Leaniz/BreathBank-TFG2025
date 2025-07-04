import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:breath_bank/widgets/appbar_dashboard.dart';
import 'package:breath_bank/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/controllers/dashboard_controller.dart';
import 'package:breath_bank/widgets/info_card_widget.dart';
import 'package:breath_bank/widgets/section_header_widget.dart';
import 'package:breath_bank/widgets/list_preview_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController _controller = DashboardController();

  final yellowColor = kLevelColor;
  final greenColor = kGreenColor;

  String? _saldo;
  String? _nivelInversor;
  String? _nombreUsuario;
  bool evalDisponible = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await _controller.fetchUsuarioStats();
    final nombre = await _controller.fetchNombreUsuario();

    setState(() {
      _saldo = stats?['Saldo']?.toString();
      if (_saldo != null && double.tryParse(_saldo!)! >= 100) {
        evalDisponible = true;
      }
      _nivelInversor = stats?['NivelInversor']?.toString();
      _nombreUsuario = nombre;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBarDashboard(),
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.dashboardWelcome.replaceFirst(
                  '{0}',
                  _nombreUsuario ?? '...',
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoCard(
                    title: Strings.investorLevel,
                    value: _nivelInversor ?? '0',
                    numberColor: yellowColor,
                    textColor: yellowColor,
                    maxValue: 10,
                    width: 140,
                    height: 130,
                  ),
                  InfoCard(
                    title: Strings.saldo,
                    value: _saldo ?? '0',
                    numberColor: greenColor,
                    textColor: greenColor,
                    maxValue: 100,
                    width: 140,
                    height: 130,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SectionHeader(
                title: Strings.lastInvestments,

                onTap:
                    () => Navigator.pushNamed(
                      context,
                      '/dashboard/investmentmenu',
                    ),
                subtitle: Strings.seeInvestments,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _controller.fetchUltimasInversiones(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    );
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Text(Strings.noData);
                  }
                  return ListPreview(
                    items: snapshot.data ?? [],
                    icon: Icons.trending_up,
                    isEvaluacion: false,
                    getTitle: (item) {
                      final index = snapshot.data!.indexOf(item) + 1;
                      final fecha =
                          item['FechaInversión'] != null
                              ? _controller.formatFecha(item['FechaInversión'])
                              : 'Sin fecha';
                      return '${Strings.investmentTitle} $index ($fecha)';
                    },
                    maxItemsToShow: 2,
                  );
                },
              ),
              const SizedBox(height: 20),
              SectionHeader(
                title: Strings.lastEvaluations,
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      '/dashboard/evaluationmenu',
                    ),
                subtitle: Strings.seeEvaluations,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _controller.fetchUltimasEvaluaciones(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    );
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Text(Strings.noData);
                  }
                  return ListPreview(
                    items: snapshot.data!,
                    icon: Icons.assignment,
                    isEvaluacion: true,
                    getTitle: (item) {
                      final index = snapshot.data!.indexOf(item) + 1;
                      final fecha =
                          item['Fecha'] != null
                              ? _controller.formatFecha(item['Fecha'])
                              : 'Sin fecha';
                      return '${Strings.evaluationTitle} $index ($fecha)';
                    },
                    maxItemsToShow: 2,
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: evalDisponible ? greenColor : yellowColor,
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 3.0,
                bottom: 3.0,
              ),
              child: Text(
                evalDisponible
                    ? Strings.evaluationAvailable
                    : Strings.evaluationNotAvailable,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: AppButton(
                      isDisabled: evalDisponible ? false : true,
                      text: Strings.newEvaluation,
                      onPressed: () {
                        Navigator.pushNamed(context, '/evaluation');
                      },
                      backgroundColor:
                          evalDisponible ? kPrimaryColor : kDisabledColor,
                      textColor: evalDisponible ? yellowColor : kWhiteColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    child: AppButton(
                      text: Strings.newInvestment,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/dashboard/newinvestmentmenu',
                        );
                      },
                      backgroundColor: kPrimaryColor,
                      textColor: greenColor,
                    ),
                  ),
                ),
              ],
            ),
            const NavigationMenu(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}
