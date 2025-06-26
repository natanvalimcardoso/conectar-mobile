import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../user_client_form_controller.dart';

class UserTagsSectionWidget extends GetView<UserClientFormController> {
  const UserTagsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tags',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
                     Obx(
             () => Wrap(
               spacing: 8,
               runSpacing: 8,
               children: controller.tags.map(
                 (tag) => Chip(
                   label: Text(
                     tag,
                     style: const TextStyle(fontSize: 12),
                   ),
                   backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
                   side: const BorderSide(color: Color(0xFF4CAF50)),
                   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                 ),
               ).toList(),
             ),
           ),
           if (controller.tags.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Text(
                'Nenhuma tag cadastrada',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 