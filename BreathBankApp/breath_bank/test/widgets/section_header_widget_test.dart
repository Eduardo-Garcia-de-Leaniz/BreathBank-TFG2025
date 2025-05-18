import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/section_header_widget.dart';

void main() {
  testWidgets('SectionHeader muestra título y subtítulo y responde al tap', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Mi Sección',
            subtitle: 'Ver todo',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Mi Sección'), findsOneWidget);
    expect(find.text('Ver todo'), findsOneWidget);

    await tester.tap(find.text('Ver todo'));
    expect(tapped, isTrue);
  });
}
