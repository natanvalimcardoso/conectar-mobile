import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../adm_form_controller.dart';

class FormHeaderWidget extends GetView<AdmFormController> {
  const FormHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_add,
            color: Color(0xFF4CAF50),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => Text(
              controller.pageTitle.value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            )),
          ),
        ],
      ),
    );
  }
} 