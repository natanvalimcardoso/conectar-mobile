import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/client_model.dart';
import '../../core/data/clients_mock_data.dart';

class UserClientsController extends GetxController with StateMixin<List<ClientModel>> {
  // Controllers dos filtros
  final nomeController = TextEditingController();
  final cnpjController = TextEditingController();
  final selectedStatus = Rx<String?>(null);
  final selectedConectaPlus = Rx<String?>(null);

  // Estado dos filtros
  final isFiltersExpanded = false.obs;

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
      final allClients = ClientsMockData.getAllClients();
      filteredClients.value = allClients;
      change(allClients, status: RxStatus.success());
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
    final allClients = ClientsMockData.getAllClients();
    filteredClients.value = allClients;
    change(allClients, status: RxStatus.success());
  }

  void applyFilters() {
    change(null, status: RxStatus.loading());

    // Simula uma chamada de API com filtros
    Future.delayed(const Duration(milliseconds: 300), () {
      List<ClientModel> filtered = ClientsMockData.getAllClients();

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

  // Método para navegar para edição (disponível para usuários)
  void navigateToEditClient(BuildContext context, String clientId) {
    GoRouter.of(context).go('/user/clients/edit/$clientId');
  }

  // Método para atualizar cliente (disponível para usuários)
  void updateClient(ClientModel updatedClient) {
    ClientsMockData.updateClient(updatedClient);
    
    final filteredIndex = filteredClients.indexWhere((client) => client.id == updatedClient.id);
    if (filteredIndex != -1) {
      filteredClients[filteredIndex] = updatedClient;
    }
    
    final allClients = ClientsMockData.getAllClients();
    change(allClients, status: RxStatus.success());
  }

  // Métodos NÃO disponíveis para usuários comuns:
  // - navigateToNewClient (apenas admin)
  // - deleteClient (apenas admin)
  // - addClient (apenas admin)
} 