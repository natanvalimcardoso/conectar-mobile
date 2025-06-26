import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'adm_controller.dart';
import 'form/widgets/clients_tab_widget.dart';
import 'form/widgets/form_tab_widget.dart';

class AdmPage extends GetView<AdmController> {
  const AdmPage({super.key});

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
              'Conectar',
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
        bottom: TabBar(
          controller: controller.mainTabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'Clientes'),
            Tab(text: 'Formulário'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.mainTabController,
        children: const [
          ClientsTabWidget(),
          FormTabWidget(),
        ],
      ),
    );
  }
}