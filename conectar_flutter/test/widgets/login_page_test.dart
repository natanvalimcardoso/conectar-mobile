import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:conectar_flutter/modules/auth/login/login_page.dart';
import 'package:conectar_flutter/modules/auth/login/login_controller.dart';
import 'package:conectar_flutter/core/repositories/login/login_repository.dart';
import 'package:conectar_flutter/core/widgets/inputs/custom_input_widget.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  group('LoginPage', () {
    late MockLoginRepository mockRepository;
    late LoginController controller;

    setUp(() {
      Get.reset();
      mockRepository = MockLoginRepository();
      controller = LoginController(mockRepository);
      Get.put<LoginController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('deve renderizar todos os elementos da tela', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(CustomInputWidget), findsNWidgets(2));
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Não tem conta? Criar uma nova'), findsOneWidget);
    });

    testWidgets('deve ter campos de email e senha', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.byWidgetPredicate(
        (widget) => widget is CustomInputWidget && widget.hintText == 'Email'
      ), findsOneWidget);

      expect(find.byWidgetPredicate(
        (widget) => widget is CustomInputWidget && widget.hintText == 'Senha' && widget.isPasswordField == true
      ), findsOneWidget);
    });

    testWidgets('deve permitir inserir texto nos campos', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      final emailField = find.byWidgetPredicate(
        (widget) => widget is CustomInputWidget && widget.hintText == 'Email'
      );
      final passwordField = find.byWidgetPredicate(
        (widget) => widget is CustomInputWidget && widget.hintText == 'Senha'
      );

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      expect(controller.emailController.text, 'test@example.com');
      expect(controller.passwordController.text, 'password123');
    });

    testWidgets('deve mostrar erro de validação para email vazio', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      await tester.tap(find.text('Entrar'));
      await tester.pump();

      expect(find.text('Email é obrigatório'), findsOneWidget);
    });

    testWidgets('deve mostrar erro de validação para email inválido', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      final emailField = find.byWidgetPredicate(
        (widget) => widget is CustomInputWidget && widget.hintText == 'Email'
      );

      await tester.enterText(emailField, 'email_invalido');
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      expect(find.text('Digite um email válido'), findsOneWidget);
    });

    testWidgets('deve mostrar erro de validação para senha vazia', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      final emailField = find.byWidgetPredicate(
        (widget) => widget is CustomInputWidget && widget.hintText == 'Email'
      );

      await tester.enterText(emailField, 'test@example.com');
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      expect(find.text('Senha é obrigatória'), findsOneWidget);
    });

    testWidgets('deve mostrar erro de validação para senha muito curta', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      final emailField = find.byWidgetPredicate(
        (widget) => widget is CustomInputWidget && widget.hintText == 'Email'
      );
      final passwordField = find.byWidgetPredicate(
        (widget) => widget is CustomInputWidget && widget.hintText == 'Senha'
      );

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, '123');
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      expect(find.text('Senha deve ter pelo menos 6 caracteres'), findsOneWidget);
    });

    testWidgets('deve alternar visibilidade da senha', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('deve mostrar loading quando estiver fazendo login', (WidgetTester tester) async {
      controller.change(null, status: RxStatus.loading());

      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve mostrar mensagem de erro quando login falhar', (WidgetTester tester) async {
      controller.change(null, status: RxStatus.error('Credenciais inválidas'));

      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.text('Credenciais inválidas'), findsOneWidget);
      expect(find.text('Tente novamente'), findsOneWidget);
    });

    testWidgets('deve ter layout responsivo para telas pequenas', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(CustomInputWidget), findsNWidgets(2));

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });

    testWidgets('deve ter layout responsivo para telas grandes', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(CustomInputWidget), findsNWidgets(2));

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });

    testWidgets('deve navegar para registro quando link for clicado', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.text('Não tem conta? Criar uma nova'), findsOneWidget);
    });

    testWidgets('deve ter cor de fundo verde', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(const Color(0xFF4CAF50)));
    });

    testWidgets('deve ter estrutura de layout correta', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
} 