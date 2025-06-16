import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breath_bank/models/statistics_model.dart';

void main() {
  group('StatisticsCalculator', () {
    test('calculateEvaluationStatistics calcula correctamente', () {
      final now = Timestamp.fromDate(DateTime(2024, 5, 1));
      final datos = [
        {'nivel': 2, 'fecha': now, 'prueba1': 10, 'prueba2': 20, 'prueba3': 30},
        {
          'nivel': 3,
          'fecha': Timestamp.fromDate(DateTime(2024, 6, 1)),
          'prueba1': 15,
          'prueba2': 25,
          'prueba3': 35,
        },
      ];

      final stats = StatisticsCalculator.calculateEvaluationStatistics(datos);

      expect(stats['totalEvaluaciones'], 2);
      expect(stats['mejorNivel'], 3);
      expect(stats['promedioNivel'], '2.5');
      expect(stats['variacionNivel'], '1');
      expect(stats['mejorP1'], 15);
      expect(stats['mejorP2'], 25);
      expect(stats['mejorP3'], 35);
      expect(stats['fechaUltimaEvaluacion'], '01/06/2024');
    });

    test('calculateInvestmentStatistics calcula correctamente', () {
      final now = Timestamp.fromDate(DateTime(2024, 5, 1));
      final datos = [
        {
          'ListónInversión': 5,
          'TiempoInversión': 30,
          'ResultadoInversión': 8,
          'FechaInversión': now,
          'Superada': true,
          'TipoInversión': 'Manual',
        },
        {
          'ListónInversión': 7,
          'TiempoInversión': 40,
          'ResultadoInversión': 10,
          'FechaInversión': Timestamp.fromDate(DateTime(2024, 6, 1)),
          'Superada': false,
          'TipoInversión': 'Guiada',
        },
        {
          'ListónInversión': 7,
          'TiempoInversión': 40,
          'ResultadoInversión': 12,
          'FechaInversión': Timestamp.fromDate(DateTime(2024, 7, 1)),
          'Superada': true,
          'TipoInversión': 'Manual',
        },
      ];

      final stats = StatisticsCalculator.calculateInvestmentStatistics(
        datos,
        StatisticsCalculator.formatFecha,
      );

      expect(stats['totalInversiones'], 3);
      expect(stats['listonMasAlto'], 7);
      expect(stats['totalRespiraciones'], 30);
      expect(stats['fechaUltimaInversion'], '01/07/2024');
      expect(stats['porcentajeSuperadas'], 67);
      expect(stats['inversionesManual'], 2);
      expect(stats['inversionesGuiadas'], 1);
      expect(stats['duracionMasElegida'], 40);
    });
  });
}
