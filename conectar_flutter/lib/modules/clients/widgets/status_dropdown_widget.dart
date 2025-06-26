import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client_form_controller.dart';

class StatusDropdownWidget extends GetView<ClientFormController> {
  const StatusDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedStatus.value,
      decoration: const InputDecoration(
        labelText: 'Status do cliente',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
        DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
      ],
      onChanged: (value) {
        if (value != null) {
          controller.selectedStatus.value = value;
        }
      },
    ));
  }
} 