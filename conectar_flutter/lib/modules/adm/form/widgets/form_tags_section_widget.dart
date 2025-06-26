import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../adm_form_controller.dart';

class FormTagsSectionWidget extends GetView<AdmFormController> {
  const FormTagsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormAddTagWidget(),
        const SizedBox(height: 16),
        const FormTagsListWidget(),
      ],
    );
  }
}

class FormAddTagWidget extends GetView<AdmFormController> {
  const FormAddTagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tagController = TextEditingController();
    
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: tagController,
            decoration: const InputDecoration(
              labelText: 'Digite uma tag e pressione Enter para adicionar',
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (value) {
              _addTag(tagController);
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
      controller.addTag(newTag);
      tagController.clear();
    }
  }
}

class FormTagsListWidget extends GetView<AdmFormController> {
  const FormTagsListWidget({super.key});

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