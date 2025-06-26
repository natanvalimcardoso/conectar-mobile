import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client_form_controller.dart';

class AppBarWidget extends GetView<ClientFormController> implements PreferredSizeWidget {
  const AppBarWidget({super.key});

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
          Spacer(),
          Obx(
            () => Text(
              controller.pageTitle.value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
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