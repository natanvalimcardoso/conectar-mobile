import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client_form_controller.dart';

class SaveButtonWidget extends GetView<ClientFormController> {
  const SaveButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ElevatedButton(
      onPressed: controller.isLoading.value
          ? null
          : () {
              // Proteção adicional contra duplo clique
              if (!controller.isLoading.value) {
                controller.saveClient(context);
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: controller.isLoading.value
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              controller.isEditing.value ? 'Atualizar' : 'Salvar',
            ),
    ));
  }
} 