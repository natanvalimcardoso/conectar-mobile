import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../clients/clients_controller.dart';

class ClientsFiltersWidget extends GetView<ClientsController> {
  const ClientsFiltersWidget({super.key});

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
                    child: FiltersContentWidget(),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class FiltersContentWidget extends GetView<ClientsController> {
  const FiltersContentWidget({super.key});

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
              Expanded(child: FilterNameFieldWidget()),
              const SizedBox(width: 16),
              Expanded(child: FilterCnpjFieldWidget()),
              const SizedBox(width: 16),
              Expanded(child: FilterStatusDropdownWidget()),
              const SizedBox(width: 16),
              Expanded(child: FilterConectaPlusDropdownWidget()),
            ],
          ),
        ] else ...[
          // Layout para telas pequenas - duas linhas
          Row(
            children: [
              Expanded(child: FilterNameFieldWidget()),
              const SizedBox(width: 16),
              Expanded(child: FilterCnpjFieldWidget()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: FilterStatusDropdownWidget()),
              const SizedBox(width: 16),
              Expanded(child: FilterConectaPlusDropdownWidget()),
            ],
          ),
        ],
        const SizedBox(height: 20),
        const FiltersActionsWidget(),
      ],
    );
  }
}

class FilterNameFieldWidget extends GetView<ClientsController> {
  const FilterNameFieldWidget({super.key});

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

class FilterCnpjFieldWidget extends GetView<ClientsController> {
  const FilterCnpjFieldWidget({super.key});

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

class FilterStatusDropdownWidget extends GetView<ClientsController> {
  const FilterStatusDropdownWidget({super.key});

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

class FilterConectaPlusDropdownWidget extends GetView<ClientsController> {
  const FilterConectaPlusDropdownWidget({super.key});

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

class FiltersActionsWidget extends GetView<ClientsController> {
  const FiltersActionsWidget({super.key});

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