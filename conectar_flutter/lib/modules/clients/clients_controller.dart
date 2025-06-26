import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/client_model.dart';

class ClientsController extends GetxController with StateMixin<List<ClientModel>> {
  // Controllers dos filtros
  final nomeController = TextEditingController();
  final cnpjController = TextEditingController();
  final selectedStatus = Rx<String?>(null);
  final selectedConectaPlus = Rx<String?>(null);

  // Estado dos filtros
  final isFiltersExpanded = false.obs;

  // Set completo de clientes (mock) - não permite duplicações automáticas
  final Set<ClientModel> _allClients = {
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

  // Lista filtrada para a UI
  final RxList<ClientModel> filteredClients = <ClientModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadClients();
  }

  @override
  void onClose() {
    nomeController.dispose();
    cnpjController.dispose();
    super.onClose();
  }

  void _loadClients() {
    change(null, status: RxStatus.loading());

    // Simula uma chamada de API
    Future.delayed(const Duration(milliseconds: 500), () {
      filteredClients.value = _allClients.toList();
      change(_allClients.toList(), status: RxStatus.success());
    });
  }

  void toggleFilters() {
    isFiltersExpanded.value = !isFiltersExpanded.value;
  }

  void clearFilters() {
    nomeController.clear();
    cnpjController.clear();
    selectedStatus.value = null;
    selectedConectaPlus.value = null;

    // Recarrega todos os clientes
    filteredClients.value = _allClients.toList();
    change(_allClients.toList(), status: RxStatus.success());
  }

  void applyFilters() {
    change(null, status: RxStatus.loading());

    // Simula uma chamada de API com filtros
    Future.delayed(const Duration(milliseconds: 300), () {
      List<ClientModel> filtered = _allClients.toList();

      // Filtro por nome
      if (nomeController.text.isNotEmpty) {
        filtered = filtered
            .where(
              (client) =>
                  client.nomeNaFachada.toLowerCase().contains(nomeController.text.toLowerCase()) ||
                  client.razaoSocial.toLowerCase().contains(nomeController.text.toLowerCase()),
            )
            .toList();
      }

      // Filtro por CNPJ
      if (cnpjController.text.isNotEmpty) {
        filtered = filtered.where((client) => client.cnpj.contains(cnpjController.text)).toList();
      }

      // Filtro por status
      if (selectedStatus.value != null && selectedStatus.value!.isNotEmpty) {
        filtered = filtered.where((client) => client.status == selectedStatus.value).toList();
      }

      // Filtro por Conecta Plus
      if (selectedConectaPlus.value != null && selectedConectaPlus.value!.isNotEmpty) {
        final hasConectaPlus = selectedConectaPlus.value == 'Sim';
        filtered = filtered.where((client) => client.conectaPlus == hasConectaPlus).toList();
      }

      filteredClients.value = filtered;
      change(filtered, status: RxStatus.success());
    });
  }

  void navigateToNewClient(BuildContext context) {
    // Navega para a página de novo cliente usando GoRouter
    GoRouter.of(context).go('/admin/clients/new');
  }

  void navigateToEditClient(BuildContext context, String clientId) {
    // Navega para a página de edição usando GoRouter
    GoRouter.of(context).go('/admin/clients/edit/$clientId');
  }

  Future<void> deleteClient(String clientId) async {
    try {
      _allClients.removeWhere((client) => client.id == clientId);
      applyFilters();
    } catch (e) {}
  }

  void addClient(ClientModel newClient) {
    final wasAdded = _allClients.add(newClient);
    
    if (!wasAdded) {
      return;
    }
    
    filteredClients.value = _allClients.toList();
    
    change(_allClients.toList(), status: RxStatus.success());
  }

  void updateClient(ClientModel updatedClient) {
    _allClients.removeWhere((client) => client.id == updatedClient.id);
    _allClients.add(updatedClient);
    
    final filteredIndex = filteredClients.indexWhere((client) => client.id == updatedClient.id);
    if (filteredIndex != -1) {
      filteredClients[filteredIndex] = updatedClient;
    }
    
    change(_allClients.toList(), status: RxStatus.success());
  }
}
