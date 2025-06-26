# 🧪 Testes - Conectar Flutter

Este diretório contém todos os testes do projeto Conectar Flutter, organizados em testes unitários e testes de widget.

## 📁 Estrutura dos Testes

```
test/
├── unit/
│   └── repositories/           # Testes unitários dos repositories
│       ├── login_repository_test.dart
│       ├── register_repository_test.dart
│       └── user_repository_test.dart
├── widgets/                   # Testes de widgets
│   ├── custom_input_widget_test.dart
│   └── login_page_test.dart
├── test_runner.dart          # Executa todos os testes
└── README.md                 # Este arquivo
```

## 🚀 Como Executar os Testes

### Executar todos os testes
```bash
flutter test
```

### Executar testes específicos
```bash
# Testes unitários dos repositories
flutter test test/unit/repositories/

# Testes de widgets
flutter test test/widgets/

# Teste específico
flutter test test/unit/repositories/login_repository_test.dart
```

### Executar com coverage
```bash
flutter test --coverage
```

## 📊 Tipos de Teste

### 🧪 Testes Unitários (Repositories)

Os testes unitários focam em testar a lógica de negócio isoladamente, usando mocks para dependências externas.

**LoginRepositoryImpl:**
- ✅ Login bem-sucedido
- ✅ Credenciais inválidas
- ✅ Erros de rede
- ✅ Respostas inesperadas

**RegisterRepositoryImpl:**
- ✅ Registro bem-sucedido
- ✅ Email já cadastrado
- ✅ Dados inválidos
- ✅ Erros de rede

**UserRepositoryImpl:**
- ✅ Buscar perfil do usuário
- ✅ Atualizar perfil
- ✅ Diferentes tipos de erro (401, 403, 404, timeout)
- ✅ Validação de dados

### 🎭 Testes de Widget

Os testes de widget verificam se a interface do usuário se comporta corretamente.

**CustomInputWidget:**
- ✅ Renderização básica
- ✅ Campo de senha com visibilidade
- ✅ Validação de formulário
- ✅ Propriedades (keyboardType, inputFormatters, etc.)
- ✅ Estilo visual

**LoginPage:**
- ✅ Renderização de todos os elementos
- ✅ Interação com campos de entrada
- ✅ Estados da aplicação (loading, erro, sucesso)
- ✅ Validação de formulário
- ✅ Layout responsivo
- ✅ Navegação

## 🛠️ Ferramentas Utilizadas

- **flutter_test**: Framework de testes do Flutter
- **mocktail**: Biblioteca para criação de mocks
- **get**: Gerenciamento de estado (testado com GetX)

## 📝 Padrões de Teste

### Estrutura AAA (Arrange-Act-Assert)
```dart
test('deve fazer alguma coisa', () async {
  // Arrange - Preparar o ambiente
  final mockRepo = MockRepository();
  final service = Service(mockRepo);
  
  // Act - Executar a ação
  final result = await service.doSomething();
  
  // Assert - Verificar o resultado
  expect(result, equals(expectedValue));
});
```

### Nomenclatura
- Testes em português para melhor legibilidade
- Descrições claras do comportamento esperado
- Agrupamento por funcionalidade usando `group()`

### Mocks
- Use `mocktail` para criar mocks simples
- Configure apenas o comportamento necessário para o teste
- Verifique chamadas de métodos quando relevante

## 🎯 Métricas de Cobertura

Para visualizar a cobertura de testes:

1. Execute os testes com coverage:
```bash
flutter test --coverage
```

2. Instale o `lcov` (se necessário):
```bash
# macOS
brew install lcov

# Ubuntu/Debian
sudo apt-get install lcov
```

3. Gere o relatório HTML:
```bash
genhtml coverage/lcov.info -o coverage/html
```

4. Abra o relatório:
```bash
open coverage/html/index.html
```

## 📚 Exemplos de Uso

### Teste Unitário Simples
```dart
test('deve retornar dados quando chamada for bem-sucedida', () async {
  // Arrange
  when(() => mockClient.get(any())).thenAnswer(
    (_) async => Response(data: {'success': true}, statusCode: 200),
  );
  
  // Act
  final result = await repository.getData();
  
  // Assert
  expect(result.success, isTrue);
  verify(() => mockClient.get('endpoint')).called(1);
});
```

### Teste de Widget Simples
```dart
testWidgets('deve mostrar texto quando renderizado', (tester) async {
  // Arrange
  await tester.pumpWidget(
    MaterialApp(home: MyWidget(text: 'Hello')),
  );
  
  // Assert
  expect(find.text('Hello'), findsOneWidget);
});
```

## 🐛 Troubleshooting

### Problemas Comuns

**Erro de dependência não encontrada:**
```bash
flutter packages get
```

**Testes falhando com GetX:**
- Certifique-se de limpar o estado do GetX no `tearDown()`
- Use `Get.reset()` ou `Get.delete<Controller>()`

**Problemas com assets em testes:**
- Configure os assets no `pubspec.yaml`
- Use `flutter_test` específico para assets

---

Para mais informações sobre testes no Flutter, consulte a [documentação oficial](https://docs.flutter.dev/testing). 