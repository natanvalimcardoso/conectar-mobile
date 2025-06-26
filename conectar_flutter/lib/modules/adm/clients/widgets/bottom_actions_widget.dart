import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client_form_controller.dart';
import 'save_button_widget.dart';

class BottomActionsWidget extends GetView<ClientFormController> {
  const BottomActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.cancel(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF4CAF50)),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF4CAF50)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.clearForm(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.orange),
              ),
              child: const Text(
                'Limpar',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: SaveButtonWidget(),
          ),
        ],
      ),
    );
  }
} 