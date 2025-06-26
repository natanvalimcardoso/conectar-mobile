import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../adm_form_controller.dart';

class FormTabsWidget extends GetView<AdmFormController> {
  const FormTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF4CAF50),
      child: TabBar(
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
} 