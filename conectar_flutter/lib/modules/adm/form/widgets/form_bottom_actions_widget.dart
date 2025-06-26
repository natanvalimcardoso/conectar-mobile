import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../adm_form_controller.dart';

class FormBottomActionsWidget extends GetView<AdmFormController> {
  const FormBottomActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(child: FormCancelButtonWidget()),
          const SizedBox(width: 12),
          const Expanded(child: FormClearButtonWidget()),
          const SizedBox(width: 12),
          const Expanded(child: FormSaveButtonWidget()),
        ],
      ),
    );
  }
}

class FormCancelButtonWidget extends GetView<AdmFormController> {
  const FormCancelButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => controller.cancel(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Color(0xFF4CAF50)),
      ),
      child: const Text(
        'Cancelar',
        style: TextStyle(color: Color(0xFF4CAF50)),
      ),
    );
  }
}

class FormClearButtonWidget extends GetView<AdmFormController> {
  const FormClearButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => controller.clearForm(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Colors.orange),
      ),
      child: const Text(
        'Limpar',
        style: TextStyle(color: Colors.orange),
      ),
    );
  }
}

class FormSaveButtonWidget extends GetView<AdmFormController> {
  const FormSaveButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDisabled = controller.isLoading.value || controller.isSaving.value;
      
      return ElevatedButton(
        onPressed: isDisabled
            ? null
            : () {
                // Proteção adicional contra duplo clique
                if (!controller.isLoading.value && !controller.isSaving.value) {
                  controller.saveClient(context);
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: isDisabled
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
      );
    });
  }
} 