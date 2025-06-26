import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../clients/clients_controller.dart';

class ClientsFiltersWidget extends GetView<ClientsController> {
  const ClientsFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                initiallyExpanded: controller.isFiltersExpanded.value,
                onExpansionChanged: (expanded) {
                  controller.isFiltersExpanded.value = expanded;
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16.0),
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
    return Column(
      children: [
        const FiltersRowOneWidget(),
        const SizedBox(height: 16),
        const FiltersRowTwoWidget(),
        const SizedBox(height: 16),
        const FiltersActionsWidget(),
      ],
    );
  }
}

class FiltersRowOneWidget extends GetView<ClientsController> {
  const FiltersRowOneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.nomeController,
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
            controller: controller.cnpjController,
            decoration: const InputDecoration(
              labelText: 'Buscar por CNPJ',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}

class FiltersRowTwoWidget extends GetView<ClientsController> {
  const FiltersRowTwoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedStatus.value,
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
                  controller.selectedStatus.value = value;
                },
              )),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedConectaPlus.value,
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
                  controller.selectedConectaPlus.value = value;
                },
              )),
        ),
      ],
    );
  }
}

class FiltersActionsWidget extends GetView<ClientsController> {
  const FiltersActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: controller.clearFilters,
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
          onPressed: controller.applyFilters,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
          ),
          child: const Text('Filtrar'),
        ),
      ],
    );
  }
} 