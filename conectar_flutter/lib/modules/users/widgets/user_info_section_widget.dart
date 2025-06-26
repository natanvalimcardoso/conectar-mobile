import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../user_controller.dart';

class UserInfoSectionWidget extends GetView<UserController> {
  const UserInfoSectionWidget({super.key});

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
                  Icons.person,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Informações do Perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const UserInfoItemWidget(
              icon: Icons.account_circle,
              label: 'Nome',
              field: 'name',
            ),
            const SizedBox(height: 12),
            const UserInfoItemWidget(
              icon: Icons.email,
              label: 'Email',
              field: 'email',
            ),
            const SizedBox(height: 12),
            const UserInfoItemWidget(
              icon: Icons.admin_panel_settings,
              label: 'Tipo de usuário',
              field: 'role',
            ),
            const SizedBox(height: 12),
            const UserInfoItemWidget(
              icon: Icons.calendar_today,
              label: 'Membro desde',
              field: 'createdAt',
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String field;

  const UserInfoItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              GetBuilder<UserController>(
                builder: (controller) {
                  String value = '';
                  switch (field) {
                    case 'name':
                      value = controller.state?.name ?? '-';
                      break;
                    case 'email':
                      value = controller.state?.email ?? '-';
                      break;
                    case 'role':
                      value = controller.userRole;
                      break;
                    case 'createdAt':
                      value = controller.formattedCreatedAt;
                      break;
                  }
                  
                  return Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
} 