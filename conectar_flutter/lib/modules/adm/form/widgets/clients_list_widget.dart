import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../clients/clients_controller.dart';

class ClientsListWidget extends GetView<ClientsController> {
  const ClientsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: isWideScreen
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Clientes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Administrar clientes para acessar suas informações',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.navigateToNewClient(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Novo Cliente',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Clientes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Administrar clientes para acessar suas informações',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => controller.navigateToNewClient(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Novo Cliente',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;
    final isMediumScreen = screenWidth > 768;
    
    return controller.obx(
      (clients) => clients!.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum cliente encontrado',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Adicione um novo cliente para começar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 32,
                  ),
                  child: DataTable(
                    columnSpacing: isWideScreen ? 32 : (isMediumScreen ? 24 : 16),
                    headingRowHeight: 56,
                    dataRowHeight: 72,
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF2E7D32),
                    ),
                    columns: _buildColumns(isWideScreen, isMediumScreen),
                    rows: clients.map((client) {
                      return DataRow(
                        cells: _buildCells(client, context, isWideScreen, isMediumScreen),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
      onLoading: const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(
            color: Color(0xFF4CAF50),
          ),
        ),
      ),
      onError: (error) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Erro ao carregar clientes',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error ?? 'Erro desconhecido',
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(bool isWideScreen, bool isMediumScreen) {
    final baseColumns = [
      const DataColumn(label: Text('Razão social')),
      const DataColumn(label: Text('CNPJ')),
      const DataColumn(label: Text('Nome na fachada')),
    ];

    if (isWideScreen) {
      return [
        ...baseColumns,
        const DataColumn(label: Text('Tags')),
        const DataColumn(label: Text('Status')),
        const DataColumn(label: Text('Conecta Plus')),
        const DataColumn(label: Text('Ações')),
      ];
    } else if (isMediumScreen) {
      return [
        ...baseColumns,
        const DataColumn(label: Text('Status')),
        const DataColumn(label: Text('Ações')),
      ];
    } else {
      return [
        ...baseColumns,
        const DataColumn(label: Text('Ações')),
      ];
    }
  }

  List<DataCell> _buildCells(dynamic client, BuildContext context, bool isWideScreen, bool isMediumScreen) {
    final baseCells = [
      DataCell(
        InkWell(
          onTap: () => controller.navigateToEditClient(context, client.id),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              client.razaoSocial,
              style: const TextStyle(
                color: Color(0xFF4CAF50),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      DataCell(
        Container(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Text(
            client.cnpj,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ),
      DataCell(
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            client.nomeNaFachada,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];

    if (isWideScreen) {
      return [
        ...baseCells,
        DataCell(
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: client.tags.isEmpty 
              ? const Text('-', style: TextStyle(color: Colors.grey))
              : Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: client.tags.map<Widget>((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: client.status == 'Ativo' ? const Color(0xFF4CAF50) : Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              client.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                client.conectaPlus ? Icons.check_circle : Icons.cancel,
                color: client.conectaPlus ? const Color(0xFF4CAF50) : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                client.conectaPlus ? 'Sim' : 'Não',
                style: TextStyle(
                  color: client.conectaPlus ? const Color(0xFF4CAF50) : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF4CAF50)),
                tooltip: 'Editar',
                onPressed: () => controller.navigateToEditClient(context, client.id),
                splashRadius: 20,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Deletar',
                onPressed: () => _showDeleteDialog(context, client.id, client.razaoSocial),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ];
    } else if (isMediumScreen) {
      return [
        ...baseCells,
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: client.status == 'Ativo' ? const Color(0xFF4CAF50) : Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              client.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF4CAF50)),
                tooltip: 'Editar',
                onPressed: () => controller.navigateToEditClient(context, client.id),
                splashRadius: 20,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Deletar',
                onPressed: () => _showDeleteDialog(context, client.id, client.razaoSocial),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ];
    } else {
      return [
        ...baseCells,
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  controller.navigateToEditClient(context, client.id);
                  break;
                case 'delete':
                  _showDeleteDialog(context, client.id, client.razaoSocial);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: Color(0xFF4CAF50)),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Deletar'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
    }
  }

  void _showDeleteDialog(BuildContext context, String clientId, String clientName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Confirmar exclusão',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          content: Text('Tem certeza que deseja excluir o cliente "$clientName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteClient(clientId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
} 