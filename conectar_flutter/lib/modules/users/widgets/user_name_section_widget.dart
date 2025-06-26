import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/inputs/custom_input_widget.dart';
import '../user_controller.dart';

class UserNameSectionWidget extends GetView<UserController> {
  const UserNameSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Editar Nome',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GetBuilder<UserController>(
              id: 'editingName',
              builder: (controller) => !controller.isEditingName.value
                  ? const UserNameDisplayWidget()
                  : const UserNameEditWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class UserNameDisplayWidget extends GetView<UserController> {
  const UserNameDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nome atual',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              GetBuilder<UserController>(
                builder: (controller) => Text(
                  controller.state?.name ?? 'Carregando...',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: controller.toggleEditName,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          icon: const Icon(Icons.edit, size: 18),
          label: const Text('Editar'),
        ),
      ],
    );
  }
}

class UserNameEditWidget extends GetView<UserController> {
  const UserNameEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.profileFormKey,
      child: Column(
        children: [
          CustomInputWidget(
            hintText: 'Digite seu novo nome',
            controller: controller.nameController,
            validator: controller.validateName,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.toggleEditName,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GetBuilder<UserController>(
                  id: 'loadingProfile',
                  builder: (controller) => ElevatedButton(
                    onPressed: controller.isLoadingProfile.value
                        ? null
                        : () => controller.updateUserName(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: controller.isLoadingProfile.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Salvar'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 