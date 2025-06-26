import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/inputs/custom_input_widget.dart';
import '../user_controller.dart';

class UserPasswordSectionWidget extends GetView<UserController> {
  const UserPasswordSectionWidget({super.key});

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
                  Icons.lock,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Alterar Senha',
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
              id: 'editingPassword',
              builder: (controller) => !controller.isEditingPassword.value
                  ? const UserPasswordDisplayWidget()
                  : const UserPasswordEditWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class UserPasswordDisplayWidget extends GetView<UserController> {
  const UserPasswordDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Senha',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '••••••••',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: controller.toggleEditPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          icon: const Icon(Icons.lock_outline, size: 18),
          label: const Text('Alterar'),
        ),
      ],
    );
  }
}

class UserPasswordEditWidget extends GetView<UserController> {
  const UserPasswordEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.passwordFormKey,
      child: Column(
        children: [
          CustomInputWidget(
            hintText: 'Senha atual',
            controller: controller.currentPasswordController,
            validator: controller.validateCurrentPassword,
            isPasswordField: true,
          ),
          const SizedBox(height: 16),
          CustomInputWidget(
            hintText: 'Nova senha',
            controller: controller.newPasswordController,
            validator: controller.validateNewPassword,
            isPasswordField: true,
          ),
          const SizedBox(height: 16),
          CustomInputWidget(
            hintText: 'Confirmar nova senha',
            controller: controller.confirmPasswordController,
            validator: controller.validateConfirmPassword,
            isPasswordField: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.toggleEditPassword,
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
                  id: 'loadingPassword',
                  builder: (controller) => ElevatedButton(
                    onPressed: controller.isLoadingPassword.value
                        ? null
                        : () => controller.updateUserPassword(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: controller.isLoadingPassword.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Alterar Senha'),
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