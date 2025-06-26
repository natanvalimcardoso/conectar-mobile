import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/inputs/custom_input_widget.dart';
import '../client_form_controller.dart';

class TagsSectionWidget extends GetView<ClientFormController> {
  const TagsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddTagWidget(),
        SizedBox(height: 16),
        TagsListWidget(),
      ],
    );
  }
}

class AddTagWidget extends GetView<ClientFormController> {
  const AddTagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tagController = TextEditingController();
    
    return Row(
      children: [
        Expanded(
          child: CustomInputWidget(
            hintText: 'Digite uma tag e pressione Enter',
            controller: tagController,
            validator: null,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              if (value.endsWith('\n')) {
                _addTag(tagController);
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => _addTag(tagController),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          child: const Text('Adicionar'),
        ),
      ],
    );
  }

  void _addTag(TextEditingController tagController) {
    final newTag = tagController.text.trim();
    if (newTag.isNotEmpty) {
      final validationResult = controller.validateTag(newTag);
      if (validationResult == null) {
        controller.addTag(newTag);
        tagController.clear();
      } else {
        Get.snackbar(
          'Erro na Tag',
          validationResult,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }
}

class TagsListWidget extends GetView<ClientFormController> {
  const TagsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.tags.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tags adicionadas:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  labelStyle: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w500,
                  ),
                  deleteIcon: const Icon(
                    Icons.close,
                    size: 18,
                    color: Color(0xFF4CAF50),
                  ),
                  onDeleted: () => controller.removeTag(tag),
                );
              }).toList(),
            ),
          ],
        );
      } else {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: const Text(
            'Nenhuma tag adicionada',
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }
    });
  }
} 