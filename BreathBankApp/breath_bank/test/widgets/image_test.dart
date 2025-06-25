import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/image.dart';

void main() {
  testWidgets(
    'ImageWidget muestra la imagen con el tamaño y el padding correctos',
    (WidgetTester tester) async {
      const testImage = 'assets/images/reloj_inicio_inversion_manual.png';
      const testWidth = 100.0;
      const testHeight = 150.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageWidget(
              photoString: testImage,
              imageWidth: testWidth,
              imageHeight: testHeight,
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final containerWidget = tester.widget<Container>(containerFinder);
      expect(containerWidget.padding, const EdgeInsets.all(40));

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.width, testWidth);
      expect(imageWidget.height, testHeight);
      expect(imageWidget.fit, BoxFit.cover);

      final imageProvider = imageWidget.image as AssetImage;
      expect(imageProvider.assetName, testImage);
    },
  );

  testWidgets('ImageWidget renderiza con diferentes tamaños de imagen', (
    WidgetTester tester,
  ) async {
    const testImage = 'assets/images/reloj_fin_inversion_manual.png';
    const testWidth = 50.0;
    const testHeight = 75.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ImageWidget(
            photoString: testImage,
            imageWidth: testWidth,
            imageHeight: testHeight,
          ),
        ),
      ),
    );

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);
    final imageWidget = tester.widget<Image>(imageFinder);
    expect(imageWidget.width, testWidth);
    expect(imageWidget.height, testHeight);

    final imageProvider = imageWidget.image as AssetImage;
    expect(imageProvider.assetName, testImage);
  });
}
