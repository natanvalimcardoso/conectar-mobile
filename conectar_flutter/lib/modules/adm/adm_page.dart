import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_constant.dart';
import '../../core/network/storage_client.dart';
import '../auth/login/login_controller.dart';

class AdmPage extends StatelessWidget {
  const AdmPage({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await StorageClient.removeToken();
      
      // Limpa os dados do controller de login se existir
      if (Get.isRegistered<LoginController>()) {
        Get.find<LoginController>().clearForm();
      }
      
      if (context.mounted) {
        GoRouter.of(context).go(AppRoutes.login);
      }
    } catch (e) {
      // Se houver erro, ainda assim navega para login
      if (context.mounted) {
        GoRouter.of(context).go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 80,
                color: Color(0xFF4CAF50),
              ),
              SizedBox(height: 24),
              Text(
                'Bem-vindo ao Painel Administrativo!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Você está logado como administrador.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}