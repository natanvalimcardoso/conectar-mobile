import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_clients_controller.dart';
import 'widgets/user_clients_filters_widget.dart';
import 'widgets/user_clients_list_widget.dart';

class UserClientsPage extends GetView<UserClientsController> {
  const UserClientsPage({super.key});

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
              'Clientes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar',
          ),
        ],
      ),
      body: const Column(
        children: [
          UserClientsFiltersWidget(),
          Expanded(child: UserClientsListWidget()),
        ],
      ),
    );
  }
} 