import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsCalculator {
  static Map<String, dynamic> calculateEvaluationStatistics(
    List<Map<String, dynamic>> datos,
  ) {
    final niveles = datos.map((d) => d['nivel']).whereType<int>().toList();
    final fechas =
        datos
            .map((d) => d['fecha'] as Timestamp?)
            .whereType<Timestamp>()
            .toList();
    final totalEvaluaciones = datos.length;
    final promedioNivel =
        niveles.isNotEmpty
            ? (niveles.reduce((a, b) => a + b) / niveles.length)
                .toStringAsFixed(1)
            : 'N/A';
    final prueba1 = datos.map((d) => d['prueba1']).whereType<num>().toList();
    final prueba2 = datos.map((d) => d['prueba2']).whereType<num>().toList();
    final prueba3 = datos.map((d) => d['prueba3']).whereType<num>().toList();

    final mejorNivel =
        niveles.isNotEmpty ? niveles.reduce((a, b) => a > b ? a : b) : 'N/A';

    final variacionNivel =
        niveles.length > 1
            ? (niveles.last - niveles[niveles.length - 2]).toString()
            : 'N/A';

    final mejorP1 =
        prueba1.isNotEmpty ? prueba1.reduce((a, b) => a > b ? a : b) : 'N/A';
    final mejorP2 =
        prueba2.isNotEmpty ? prueba2.reduce((a, b) => a > b ? a : b) : 'N/A';
    final mejorP3 =
        prueba3.isNotEmpty ? prueba3.reduce((a, b) => a > b ? a : b) : 'N/A';

    final fechaUltimaEvaluacion =
        fechas.isNotEmpty
            ? formatFecha(fechas.reduce((a, b) => a.compareTo(b) > 0 ? a : b))
            : 'N/A';

    return {
      'fechaUltimaEvaluacion': fechaUltimaEvaluacion,
      'totalEvaluaciones': totalEvaluaciones,
      'variacionNivel': variacionNivel,
      'mejorNivel': mejorNivel,
      'promedioNivel': promedioNivel,
      'mejorP1': mejorP1,
      'mejorP2': mejorP2,
      'mejorP3': mejorP3,
    };
  }

  static Map<String, dynamic> calculateInvestmentStatistics(
    List<Map<String, dynamic>> datos,
    String Function(Timestamp) formatFecha,
  ) {
    final listones =
        datos.map((d) => d['ListónInversión']).whereType<num>().toList();
    final tiempos =
        datos.map((d) => d['TiempoInversión']).whereType<num>().toList();
    final resultados =
        datos.map((d) => d['ResultadoInversión']).whereType<num>().toList();
    final fechas =
        datos
            .map((d) => d['FechaInversión'] as Timestamp?)
            .whereType<Timestamp>()
            .toList();
    final superadas = datos.map((d) => d['Superada'] as bool).toList();

    final totalInversiones = datos.length;

    final inversionesManual =
        datos.where((d) => d['TipoInversión'] == 'Manual').length;

    final inversionesGuiadas =
        datos.where((d) => d['TipoInversión'] == 'Guiada').length;

    final duracionMasElegida =
        tiempos.isNotEmpty
            ? tiempos
                .fold<Map<num, int>>({}, (map, tiempo) {
                  map[tiempo] = (map[tiempo] ?? 0) + 1;
                  return map;
                })
                .entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key
            : 'N/A';

    final listonMasAlto =
        listones.isNotEmpty ? listones.reduce((a, b) => a > b ? a : b) : 'N/A';

    final totalRespiraciones =
        resultados.isNotEmpty ? resultados.reduce((a, b) => a + b) : 0;

    final fechaUltimaInversion =
        fechas.isNotEmpty
            ? formatFecha(fechas.reduce((a, b) => a.compareTo(b) > 0 ? a : b))
            : 'N/A';

    final porcentajeSuperadas =
        superadas.isNotEmpty
            ? ((superadas.where((s) => s).length / superadas.length) * 100)
                .round()
            : 'N/A';

    return {
      'totalInversiones': totalInversiones,
      'duracionMasElegida': duracionMasElegida,
      'listonMasAlto': listonMasAlto,
      'totalRespiraciones': totalRespiraciones,
      'fechaUltimaInversion': fechaUltimaInversion,
      'porcentajeSuperadas': porcentajeSuperadas,
      'inversionesManual': inversionesManual,
      'inversionesGuiadas': inversionesGuiadas,
    };
  }

  static String formatFecha(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
