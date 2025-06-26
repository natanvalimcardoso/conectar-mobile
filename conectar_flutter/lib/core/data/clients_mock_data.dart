import '../models/client_model.dart';

/// Mock global de clientes compartilhado entre admin e usuários
class ClientsMockData {
  static final Set<ClientModel> _clients = {
    ClientModel(
      id: '1',
      razaoSocial: 'TOKEN TEST LTDA',
      nomeNaFachada: 'JOANINHA BISTRÔ',
      cnpj: '71.567.504/0001-74',
      status: 'Inativo',
      cep: '01310-100',
      rua: 'Avenida Paulista',
      numero: '1000',
      bairro: 'Bela Vista',
      cidade: 'São Paulo',
      estado: 'SP',
      conectaPlus: false,
      tags: ['Restaurante', 'Bistrô'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ClientModel(
      id: '2',
      razaoSocial: 'RESTAURANTE BOA VISTA',
      nomeNaFachada: 'RESTAURANTE BOA VISTA',
      cnpj: '71.673.090/0001-77',
      status: 'Inativo',
      cep: '04567-890',
      rua: 'Rua das Flores',
      numero: '123',
      bairro: 'Vila Madalena',
      cidade: 'São Paulo',
      estado: 'SP',
      conectaPlus: false,
      tags: ['Restaurante', 'Alimentação'],
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ClientModel(
      id: '3',
      razaoSocial: 'TOKEN TEST LTDA',
      nomeNaFachada: 'Geo Food',
      cnpj: '64.132.434/0001-61',
      status: 'Inativo',
      cep: '12345-678',
      rua: 'Rua do Comércio',
      numero: '456',
      bairro: 'Centro',
      cidade: 'Rio de Janeiro',
      estado: 'RJ',
      conectaPlus: false,
      tags: ['Delivery', 'Fast Food'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ClientModel(
      id: '4',
      razaoSocial: 'SUPERMERCADO CENTRAL LTDA',
      nomeNaFachada: 'Super Central',
      cnpj: '88.999.777/0001-55',
      status: 'Ativo',
      cep: '54321-987',
      rua: 'Avenida Brasil',
      numero: '789',
      bairro: 'Copacabana',
      cidade: 'Rio de Janeiro',
      estado: 'RJ',
      conectaPlus: true,
      tags: ['Supermercado', 'Alimentação'],
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ClientModel(
      id: '5',
      razaoSocial: 'FARMÁCIA SAÚDE LTDA',
      nomeNaFachada: 'Farmácia Saúde Plus',
      cnpj: '22.333.444/0001-99',
      status: 'Ativo',
      cep: '87654-321',
      rua: 'Rua da Saúde',
      numero: '321',
      bairro: 'Vila Nova',
      cidade: 'Belo Horizonte',
      estado: 'MG',
      conectaPlus: true,
      tags: ['Farmácia', 'Saúde'],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
  };

  /// Obtém todos os clientes
  static List<ClientModel> getAllClients() {
    return _clients.toList();
  }

  /// Obtém um cliente por ID
  static ClientModel? getClientById(String id) {
    try {
      return _clients.firstWhere((client) => client.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Adiciona um novo cliente (apenas para admin)
  static bool addClient(ClientModel client) {
    return _clients.add(client);
  }

  /// Atualiza um cliente existente
  static bool updateClient(ClientModel updatedClient) {
    _clients.removeWhere((client) => client.id == updatedClient.id);
    return _clients.add(updatedClient);
  }

  /// Remove um cliente (apenas para admin)
  static bool removeClient(String clientId) {
    final countBefore = _clients.length;
    _clients.removeWhere((client) => client.id == clientId);
    return _clients.length < countBefore;
  }

  /// Filtra clientes por critérios
  static List<ClientModel> filterClients({
    String? nome,
    String? cnpj,
    String? status,
    bool? conectaPlus,
  }) {
    List<ClientModel> filtered = _clients.toList();

    if (nome != null && nome.isNotEmpty) {
      filtered = filtered
          .where(
            (client) =>
                client.nomeNaFachada.toLowerCase().contains(nome.toLowerCase()) ||
                client.razaoSocial.toLowerCase().contains(nome.toLowerCase()),
          )
          .toList();
    }

    if (cnpj != null && cnpj.isNotEmpty) {
      filtered = filtered.where((client) => client.cnpj.contains(cnpj)).toList();
    }

    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((client) => client.status == status).toList();
    }

    if (conectaPlus != null) {
      filtered = filtered.where((client) => client.conectaPlus == conectaPlus).toList();
    }

    return filtered;
  }
} 