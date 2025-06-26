import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../user_clients_controller.dart';

class UserClientsListWidget extends GetView<UserClientsController> {
  const UserClientsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserClientsHeaderWidget(),
          const Expanded(child: UserClientsDataTableWidget()),
        ],
      ),
    );
  }
}

class UserClientsHeaderWidget extends GetView<UserClientsController> {
  const UserClientsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
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
            'Visualizar e editar informações dos clientes',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class UserClientsDataTableWidget extends GetView<UserClientsController> {
  const UserClientsDataTableWidget({super.key});

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
                      'Tente ajustar os filtros de pesquisa',
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
                    columns: UserDataTableColumnsWidget(
                      isWideScreen: isWideScreen,
                      isMediumScreen: isMediumScreen,
                    ).build(),
                    rows: clients.map((client) {
                      return DataRow(
                        cells: UserDataTableCellsWidget(
                          client: client,
                          context: context,
                          isWideScreen: isWideScreen,
                          isMediumScreen: isMediumScreen,
                          controller: controller,
                        ).build(),
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
              const Text(
                'Erro ao carregar clientes',
                style: TextStyle(
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
}

class UserDataTableColumnsWidget {
  final bool isWideScreen;
  final bool isMediumScreen;

  const UserDataTableColumnsWidget({
    required this.isWideScreen,
    required this.isMediumScreen,
  });

  List<DataColumn> build() {
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
}

class UserDataTableCellsWidget {
  final dynamic client;
  final BuildContext context;
  final bool isWideScreen;
  final bool isMediumScreen;
  final UserClientsController controller;

  const UserDataTableCellsWidget({
    required this.client,
    required this.context,
    required this.isWideScreen,
    required this.isMediumScreen,
    required this.controller,
  });

  List<DataCell> build() {
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
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF4CAF50)),
            tooltip: 'Editar',
            onPressed: () => controller.navigateToEditClient(context, client.id),
            splashRadius: 20,
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
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF4CAF50)),
            tooltip: 'Editar',
            onPressed: () => controller.navigateToEditClient(context, client.id),
            splashRadius: 20,
          ),
        ),
      ];
    } else {
      return [
        ...baseCells,
        DataCell(
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF4CAF50)),
            tooltip: 'Editar',
            onPressed: () => controller.navigateToEditClient(context, client.id),
            splashRadius: 20,
          ),
        ),
      ];
    }
  }
} 