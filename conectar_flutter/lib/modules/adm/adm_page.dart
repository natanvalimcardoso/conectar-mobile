import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_constant.dart';
import '../../core/network/storage_client.dart';
import '../auth/login/login_controller.dart';
import 'clients/clients_controller.dart';

class AdmPage extends StatefulWidget {
  const AdmPage({super.key});

  @override
  State<AdmPage> createState() => _AdmPageState();
}

class _AdmPageState extends State<AdmPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ClientsController _clientsController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _clientsController = Get.put(ClientsController());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await StorageClient.removeToken();
      
      if (Get.isRegistered<LoginController>()) {
        Get.find<LoginController>().clearForm();
      }
      
      if (context.mounted) {
        GoRouter.of(context).go(AppRoutes.login);
      }
    } catch (e) {
      if (context.mounted) {
        GoRouter.of(context).go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/pngs/conectar.png',
              height: 24,
              color: Colors.white,
            ),
           
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Clientes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildClientsTab(),
        ],
      ),
    );
  }

  Widget _buildClientsTab() {
    return Column(
      children: [
        _buildFiltersSection(),
        Expanded(
          child: _buildClientsList(),
        ),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => ExpansionTile(
                title: const Row(
                  children: [
                    Icon(Icons.filter_list, color: Color(0xFF4CAF50)),
                    SizedBox(width: 8),
                    Text(
                      'Filtros',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Clique aqui para filtrar sua pesquisa',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                initiallyExpanded: _clientsController.isFiltersExpanded.value,
                onExpansionChanged: (expanded) {
                  _clientsController.isFiltersExpanded.value = expanded;
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _clientsController.nomeController,
                                decoration: const InputDecoration(
                                  labelText: 'Buscar por nome',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _clientsController.cnpjController,
                                decoration: const InputDecoration(
                                  labelText: 'Buscar por CNPJ',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => DropdownButtonFormField<String>(
                                    value: _clientsController.selectedStatus.value,
                                    decoration: const InputDecoration(
                                      labelText: 'Buscar por status',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: '', child: Text('Selecione')),
                                      DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                                      DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
                                    ],
                                    onChanged: (value) {
                                      _clientsController.selectedStatus.value = value;
                                    },
                                  )),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Obx(() => DropdownButtonFormField<String>(
                                    value: _clientsController.selectedConectaPlus.value,
                                    decoration: const InputDecoration(
                                      labelText: 'Buscar por conecta+',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: '', child: Text('Selecione')),
                                      DropdownMenuItem(value: 'Sim', child: Text('Sim')),
                                      DropdownMenuItem(value: 'Não', child: Text('Não')),
                                    ],
                                    onChanged: (value) {
                                      _clientsController.selectedConectaPlus.value = value;
                                    },
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: _clientsController.clearFilters,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF4CAF50)),
                              ),
                              child: const Text(
                                'Limpar campos',
                                style: TextStyle(color: Color(0xFF4CAF50)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _clientsController.applyFilters,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Filtrar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildClientsList() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Clientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Administrar clientes para acessar suas informações',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _clientsController.navigateToNewClient(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Novo'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _clientsController.obx(
              (clients) => clients!.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum cliente encontrado',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('Razão social', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('CNPJ', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Nome na fachada', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Tags', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Conecta Plus', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: clients.map((client) {
                          return DataRow(
                            cells: [
                              DataCell(
                                InkWell(
                                  onTap: () => _clientsController.navigateToEditClient(context, client.id),
                                  child: Text(
                                    client.razaoSocial,
                                    style: const TextStyle(
                                      color: Color(0xFF4CAF50),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text(client.cnpj)),
                              DataCell(Text(client.nomeNaFachada)),
                              DataCell(Text(client.tags.join(', '))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: client.status == 'Ativo' ? Colors.green : Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    client.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text(client.conectaPlus ? 'Sim' : 'Não')),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _showDeleteDialog(context, client.id, client.razaoSocial),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
              onLoading: const Center(child: CircularProgressIndicator()),
              onError: (error) => Center(
                child: Text(
                  'Erro ao carregar clientes: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String clientId, String clientName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text('Tem certeza que deseja excluir o cliente "$clientName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clientsController.deleteClient(clientId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}