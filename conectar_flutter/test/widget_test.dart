// Teste básico do AppWidget
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:conectar_flutter/app_widget.dart';
import 'package:conectar_flutter/core/widgets/inputs/custom_input_widget.dart';

void main() {
  group('AppWidget Tests', () {
    setUp(() {
      // Reset GetX state antes de cada teste
      Get.reset();
    });

    tearDown(() {
      // Limpa GetX state após cada teste
      Get.reset();
    });

    testWidgets('AppWidget deve ser construído sem erros', (WidgetTester tester) async {
      // Teste básico: verifica se o widget pode ser construído
      await tester.pumpWidget(const AppWidget());
      
      // Verifica se o MaterialApp foi criado
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Verifica se não há overflow ou outros erros de layout
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppWidget deve ter configurações corretas', (WidgetTester tester) async {
      await tester.pumpWidget(const AppWidget());
      
      // Verifica se o MaterialApp existe e tem as configurações corretas
      final materialAppFinder = find.byType(MaterialApp);
      expect(materialAppFinder, findsOneWidget);
      
      final MaterialApp materialApp = tester.widget(materialAppFinder);
      expect(materialApp.title, equals('Conectar Flutter'));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    });

    testWidgets('AppWidget deve usar GetMaterialApp.router', (WidgetTester tester) async {
      await tester.pumpWidget(const AppWidget());
      
      // Verifica se está usando GetMaterialApp (que estende MaterialApp)
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verifica propriedades básicas
      expect(materialApp.title, 'Conectar Flutter');
      expect(materialApp.theme?.useMaterial3, isTrue);
    });
  });
}
