import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client_form_controller.dart';

class ConectaPlusCheckboxWidget extends GetView<ClientFormController> {
  const ConectaPlusCheckboxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CheckboxListTile(
      title: const Text('Conecta Plus'),
      subtitle: const Text('Cliente possui serviço Conecta Plus'),
      value: controller.conectaPlus.value,
      onChanged: (value) {
        controller.conectaPlus.value = value ?? false;
      },
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color(0xFF4CAF50),
    ));
  }
} 