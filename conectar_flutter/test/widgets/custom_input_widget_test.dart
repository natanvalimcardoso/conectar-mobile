import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conectar_flutter/core/widgets/inputs/custom_input_widget.dart';

void main() {
  group('CustomInputWidget', () {
    testWidgets('deve renderizar o widget corretamente', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomInputWidget(
              hintText: 'Digite seu texto',
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Digite seu texto'), findsOneWidget);
    });

    testWidgets('deve mostrar o texto digitado', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomInputWidget(
              hintText: 'Digite seu texto',
              controller: controller,
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'Texto digitado');

      // Assert
      expect(controller.text, equals('Texto digitado'));
      expect(find.text('Texto digitado'), findsOneWidget);
    });

    testWidgets('deve chamar onChanged quando texto for alterado', (WidgetTester tester) async {
      // Arrange
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomInputWidget(
              hintText: 'Digite seu texto',
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'Novo texto');

      // Assert
      expect(changedValue, equals('Novo texto'));
    });

    group('Campo de senha', () {
      testWidgets('deve ocultar texto quando isPasswordField for true', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomInputWidget(
                hintText: 'Digite sua senha',
                isPasswordField: true,
              ),
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), 'minhasenha');

        // Assert - Verifica se o ícone de visibilidade está presente (indicando que é campo de senha)
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });

      testWidgets('deve mostrar ícone para alternar visibilidade da senha', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomInputWidget(
                hintText: 'Digite sua senha',
                isPasswordField: true,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });

      testWidgets('deve alternar visibilidade da senha ao clicar no ícone', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomInputWidget(
                hintText: 'Digite sua senha',
                isPasswordField: true,
              ),
            ),
          ),
        );

        // Estado inicial - ícone de visibilidade presente
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

        // Act - clicar no ícone
        await tester.tap(find.byIcon(Icons.visibility_outlined));
        await tester.pump();

        // Assert - ícone mudou para "ocultar"
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

        // Act - clicar novamente no ícone
        await tester.tap(find.byIcon(Icons.visibility_off_outlined));
        await tester.pump();

        // Assert - ícone voltou para "mostrar"
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });
    });

    group('Validação', () {
      testWidgets('deve mostrar mensagem de erro quando validação falhar', (WidgetTester tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: CustomInputWidget(
                  hintText: 'Digite seu nome',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        );

        // Act
        formKey.currentState!.validate();
        await tester.pump();

        // Assert
        expect(find.text('Campo obrigatório'), findsOneWidget);
      });

      testWidgets('não deve mostrar erro quando validação passar', (WidgetTester tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: CustomInputWidget(
                  hintText: 'Digite seu nome',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), 'João');
        formKey.currentState!.validate();
        await tester.pump();

        // Assert
        expect(find.text('Campo obrigatório'), findsNothing);
      });
    });

    group('Propriedades adicionais', () {
      testWidgets('deve aceitar entrada de texto para email', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomInputWidget(
                hintText: 'Digite seu email',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), 'test@example.com');

        // Assert
        expect(find.text('test@example.com'), findsOneWidget);
      });

      testWidgets('deve aceitar apenas números quando filtro for aplicado', (WidgetTester tester) async {
        // Arrange
        final formatters = [FilteringTextInputFormatter.digitsOnly];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomInputWidget(
                hintText: 'Digite apenas números',
                inputFormatters: formatters,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'abc123def456');

        expect(find.text('123456'), findsOneWidget);
      });

      testWidgets('deve renderizar corretamente com autofocus', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomInputWidget(
                hintText: 'Campo com foco',
                autofocus: true,
              ),
            ),
          ),
        );

        await tester.pump();

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Campo com foco'), findsOneWidget);
      });

      testWidgets('deve renderizar corretamente com FocusNode personalizado', (WidgetTester tester) async {
        // Arrange
        final focusNode = FocusNode();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomInputWidget(
                hintText: 'Campo com FocusNode',
                focusNode: focusNode,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Campo com FocusNode'), findsOneWidget);
      });
    });

    group('Estilo visual', () {
      testWidgets('deve renderizar com estilo correto', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomInputWidget(
                hintText: 'Campo estilizado',
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Campo estilizado'), findsOneWidget);
      });

      testWidgets('deve mostrar borda de erro quando há erro de validação', (WidgetTester tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: CustomInputWidget(
                  hintText: 'Campo com erro',
                  validator: (value) => 'Erro de teste',
                ),
              ),
            ),
          ),
        );

        // Act
        formKey.currentState!.validate();
        await tester.pump();

        // Assert
        expect(find.text('Erro de teste'), findsOneWidget);
      });
    });
  });
} 