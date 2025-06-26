import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_controller.dart';
import 'widgets/user_profile_widget.dart';

class UserPage extends GetView<UserController> {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/pngs/conectar.png',
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            const Text(
              'Meu Perfil',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => controller.logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: controller.obx(
        (user) => const UserProfileWidget(),
        onLoading: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4CAF50),
          ),
        ),
        onError: (error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Erro ao carregar perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error ?? 'Erro desconhecido',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (error != null && (error.contains('Token inválido') || error.contains('login')))
                  ElevatedButton.icon(
                    onPressed: () => controller.logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.login),
                    label: const Text('Fazer Login'),
                  )
                else
                  ElevatedButton(
                    onPressed: controller.loadUserProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Tentar novamente'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}