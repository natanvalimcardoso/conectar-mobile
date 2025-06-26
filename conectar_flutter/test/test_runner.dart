import 'package:flutter_test/flutter_test.dart';

// Importa todos os testes unitários
import 'unit/repositories/login_repository_test.dart' as login_repository_test;
import 'unit/repositories/register_repository_test.dart' as register_repository_test;
import 'unit/repositories/user_repository_test.dart' as user_repository_test;

// Importa todos os testes de widget
import 'widgets/custom_input_widget_test.dart' as custom_input_widget_test;
import 'widgets/login_page_test.dart' as login_page_test;

void main() {
  group('Testes Unitários - Repositories', () {
    login_repository_test.main();
    register_repository_test.main();
    user_repository_test.main();
  });

  group('Testes de Widgets', () {
    custom_input_widget_test.main();
    login_page_test.main();
  });
} 