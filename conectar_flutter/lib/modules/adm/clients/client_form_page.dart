import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'client_form_controller.dart';
import 'widgets/app_bar_widget.dart';
import 'widgets/client_form_widget.dart';

class ClientFormPage extends GetView<ClientFormController> {
  const ClientFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const AppBarWidget(),
      body: controller.obx(
        (client) => const ClientFormWidget(),
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
        onEmpty: const ClientFormWidget(),
      ),
    );
  }
}
