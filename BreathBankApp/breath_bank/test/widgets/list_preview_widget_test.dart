import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/list_preview_widget.dart';

void main() {
  testWidgets('ListPreview muestra los elementos y el botón Ver más', (
    WidgetTester tester,
  ) async {
    final items = List.generate(5, (i) => {'nombre': 'Item $i'});
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListPreview(
            items: items,
            icon: Icons.list,
            isEvaluacion: false,
            getTitle: (item) => item['nombre'],
            maxItemsToShow: 3,
          ),
        ),
      ),
    );

    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
    expect(find.text('Item 3'), findsNothing);

    expect(find.text('Ver más'), findsOneWidget);

    await tester.tap(find.text('Ver más'));
    await tester.pumpAndSettle();
    expect(find.text('Item 4'), findsOneWidget);
    expect(find.text('Ver menos'), findsOneWidget);
  });
}
