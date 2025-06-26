import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../user_clients_controller.dart';

class UserClientsFiltersWidget extends GetView<UserClientsController> {
  const UserClientsFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Clique aqui para filtrar sua pesquisa',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                initiallyExpanded: controller.isFiltersExpanded.value,
                onExpansionChanged: (expanded) {
                  controller.isFiltersExpanded.value = expanded;
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: UserFiltersContentWidget(),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class UserFiltersContentWidget extends GetView<UserClientsController> {
  const UserFiltersContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 768;
    
    return Column(
      children: [
        if (isWideScreen) ...[
          // Layout para telas largas - uma linha
          Row(
            children: [
              Expanded(child: UserFilterNameFieldWidget()),
              const SizedBox(width: 16),
              Expanded(child: UserFilterCnpjFieldWidget()),
              const SizedBox(width: 16),
              Expanded(child: UserFilterStatusDropdownWidget()),
              const SizedBox(width: 16),
              Expanded(child: UserFilterConectaPlusDropdownWidget()),
            ],
          ),
        ] else ...[
          // Layout para telas pequenas - duas linhas
          Row(
            children: [
              Expanded(child: UserFilterNameFieldWidget()),
              const SizedBox(width: 16),
              Expanded(child: UserFilterCnpjFieldWidget()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: UserFilterStatusDropdownWidget()),
              const SizedBox(width: 16),
              Expanded(child: UserFilterConectaPlusDropdownWidget()),
            ],
          ),
        ],
        const SizedBox(height: 20),
        const UserFiltersActionsWidget(),
      ],
    );
  }
}

class UserFilterNameFieldWidget extends GetView<UserClientsController> {
  const UserFilterNameFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.nomeController,
      decoration: const InputDecoration(
        labelText: 'Buscar por nome',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        isDense: false,
      ),
    );
  }
}

class UserFilterCnpjFieldWidget extends GetView<UserClientsController> {
  const UserFilterCnpjFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.cnpjController,
      decoration: const InputDecoration(
        labelText: 'Buscar por CNPJ',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        isDense: false,
      ),
    );
  }
}

class UserFilterStatusDropdownWidget extends GetView<UserClientsController> {
  const UserFilterStatusDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedStatus.value,
          decoration: const InputDecoration(
            labelText: 'Buscar por status',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            isDense: false,
          ),
          items: const [
            DropdownMenuItem(value: '', child: Text('Selecione')),
            DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
            DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
          ],
          onChanged: (value) {
            controller.selectedStatus.value = value;
          },
        ));
  }
}

class UserFilterConectaPlusDropdownWidget extends GetView<UserClientsController> {
  const UserFilterConectaPlusDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedConectaPlus.value,
          decoration: const InputDecoration(
            labelText: 'Buscar por conecta+',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            isDense: false,
          ),
          items: const [
            DropdownMenuItem(value: '', child: Text('Selecione')),
            DropdownMenuItem(value: 'Sim', child: Text('Sim')),
            DropdownMenuItem(value: 'Não', child: Text('Não')),
          ],
          onChanged: (value) {
            controller.selectedConectaPlus.value = value;
          },
        ));
  }
}

class UserFiltersActionsWidget extends GetView<UserClientsController> {
  const UserFiltersActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    
    return Row(
      mainAxisAlignment: isWideScreen ? MainAxisAlignment.end : MainAxisAlignment.spaceEvenly,
      children: [
        if (isWideScreen) ...[
          OutlinedButton(
            onPressed: controller.clearFilters,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF4CAF50)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Limpar campos',
              style: TextStyle(color: Color(0xFF4CAF50)),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: controller.applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Filtrar'),
          ),
        ] else ...[
          Expanded(
            child: OutlinedButton(
              onPressed: controller.clearFilters,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF4CAF50)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Limpar',
                style: TextStyle(color: Color(0xFF4CAF50)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Filtrar'),
            ),
          ),
        ],
      ],
    );
  }
} 