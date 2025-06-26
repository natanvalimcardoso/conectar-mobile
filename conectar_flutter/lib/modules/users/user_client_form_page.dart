import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_client_form_controller.dart';

import 'widgets/user_client_form_widget.dart';

class UserClientFormPage extends GetView<UserClientFormController> {
  const UserClientFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const UserAppBarWidget(),
      body: controller.obx(
        (client) => const UserClientFormWidget(),
        onLoading: const Center(child: CircularProgressIndicator()),
        onError: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erro: $error', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.cancel(context),
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
        onEmpty: const UserClientFormWidget(),
      ),
    );
  }
}

class UserAppBarWidget extends GetView<UserClientFormController> implements PreferredSizeWidget {
  const UserAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF4CAF50),
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Image.asset('assets/pngs/conectar.png', height: 24, color: Colors.white),
          const SizedBox(width: 12),
          const Spacer(),
          Obx(
            () => Text(
              controller.pageTitle.value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
        ],
      ),
      bottom: TabBar(
        controller: controller.tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(text: 'Dados Cadastrais'),
          Tab(text: 'Informações Internas'),
          Tab(text: 'Usuários'),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
} 