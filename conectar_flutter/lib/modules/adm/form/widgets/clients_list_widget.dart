import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../clients/clients_controller.dart';

class ClientsListWidget extends GetView<ClientsController> {
  const ClientsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ClientsHeaderWidget(),
          const Expanded(child: ClientsDataTableWidget()),
        ],
      ),
    );
  }
}

class ClientsHeaderWidget extends GetView<ClientsController> {
  const ClientsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            onPressed: () => controller.navigateToNewClient(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: const Text('Novo'),
          ),
        ],
      ),
    );
  }
}

class ClientsDataTableWidget extends GetView<ClientsController> {
  const ClientsDataTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
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
                          onTap: () => controller.navigateToEditClient(context, client.id),
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
                      DataCell(
                        client.tags.isEmpty 
                          ? const Text('-', style: TextStyle(color: Colors.grey))
                          : Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: client.tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                      ),
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
                controller.deleteClient(clientId);
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