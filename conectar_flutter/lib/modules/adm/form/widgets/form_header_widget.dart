import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../adm_form_controller.dart';

class FormHeaderWidget extends GetView<AdmFormController> {
  const FormHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(
            Icons.person_add,
            color: Color(0xFF4CAF50),
            size: 24,
          ),
          const SizedBox(width: 12),
          Obx(() => Text(
            controller.pageTitle.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          )),
        ],
      ),
    );
  }
} 