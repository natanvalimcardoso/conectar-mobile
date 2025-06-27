# Conectar Mobile

Aplicativo mobile desenvolvido em Flutter com backend NestJS para sistema de autenticação e gerenciamento de usuários.

## 🚀 Como Executar

### Backend (NestJS)
```bash
cd backend && npm run start:dev
```

### Frontend (Flutter)
```bash
cd conectar_flutter
flutter pub get
flutter run
```

### Executar Testes (60 ao todo)
- testes unitarios
- testes de widgets
```bash
cd conectar_flutter
flutter test
```

## 🏗️ Arquitetura e Decisões Técnicas

### Tecnologias Escolhidas

**Flutter (Frontend):**
- **GetX**: Gerenciamento de estado, e injeção de dependência
- **Dio**: Cliente HTTP para comunicação com API
- **Flutter Secure Storage**: Armazenamento seguro de tokens
- **Go Router**: Roteamento robusto e declarativo
- **Validatorless**: Validação de formulários
- **Mocktail**: Testes unitários e mocking

**NestJS (Backend):**
- **TypeORM**: ORM para banco de dados
- **JWT**: Autenticação via tokens
- **Passport**: Estratégias de autenticação
- **SQLite**: Banco de dados para desenvolvimento

### Justificativa das Escolhas (2 dias de desenvolvimento)

**GetX vs Provider:**
- **Escolha**: GetX
- **Motivo**: Configuração mais rápida, menos boilerplate, gerenciamento de estado reativo integrado e injeção de dependência em um único pacote.

**Arquitetura:**
- **Padrão Repository**: Separação clara entre lógica de negócio e acesso a dados
- **Clean Dart**: Organização em camadas (core, modules, shared)
- **Binding/Controller**: Padrão GetX para organizar dependências por feature

**Decisões para otimizar tempo:**
1. **GetX** ao invés de Provider: Menos configuração inicial
3. **Validatorless** ao invés de validação manual: Biblioteca brasileira com validações prontas
4. **Estrutura modular**: Facilita desenvolvimento paralelo de features

## 📱 Features Implementadas

- ✅ Autenticação (Login/Registro)
- ✅ Armazenamento seguro de tokens
- ✅ Interface responsiva
- ✅ Gerenciamento de estado reativo
- ✅ Navegação com guard de rotas
- ✅ Validação de formulários
- ✅ Tratamento de erros
- ✅ Testes unitários

## 🔧 Estrutura do Projeto

```
conectar_flutter/
├── lib/
│   ├── core/           # Configurações, constantes, helpers...
│   ├── modules/        # Features da aplicação
│   └── main.dart       # Ponto de entrada
```

## 🧪 Testes

O projeto inclui testes unitários e de widgets para controllers e repositórios, focando na lógica de negócio crítica devido ao tempo limitado de desenvolvimento.
