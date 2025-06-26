import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../adm_form_controller.dart';

class FormBottomActionsWidget extends GetView<AdmFormController> {
  const FormBottomActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: isWideScreen
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const FormCancelButtonWidget(),
                const SizedBox(width: 16),
                const FormClearButtonWidget(),
                const SizedBox(width: 16),
                const FormSaveButtonWidget(),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: FormCancelButtonWidget()),
                    const SizedBox(width: 12),
                    const Expanded(child: FormClearButtonWidget()),
                  ],
                ),
                const SizedBox(height: 12),
                const SizedBox(
                  width: double.infinity,
                  child: FormSaveButtonWidget(),
                ),
              ],
            ),
    );
  }
}

class FormCancelButtonWidget extends GetView<AdmFormController> {
  const FormCancelButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    
    return OutlinedButton(
      onPressed: () => controller.cancel(context),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: isWideScreen ? 24 : 16,
        ),
        side: const BorderSide(color: Color(0xFF4CAF50)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Cancelar',
        style: TextStyle(
          color: Color(0xFF4CAF50),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class FormClearButtonWidget extends GetView<AdmFormController> {
  const FormClearButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    
    return OutlinedButton(
      onPressed: () => controller.clearForm(),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: isWideScreen ? 24 : 16,
        ),
        side: const BorderSide(color: Colors.orange),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Limpar',
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class FormSaveButtonWidget extends GetView<AdmFormController> {
  const FormSaveButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    
    return Obx(() {
      final isDisabled = controller.isLoading.value || controller.isSaving.value;
      
      return ElevatedButton(
        onPressed: isDisabled
            ? null
            : () {
                if (!controller.isLoading.value && !controller.isSaving.value) {
                  controller.saveClient(context);
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: isWideScreen ? 24 : 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
      );
    });
  }
} 