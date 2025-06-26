import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../adm_form_controller.dart';
import 'form_dados_cadastrais_widget.dart';

class FormContentWidget extends GetView<AdmFormController> {
  const FormContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller.tabController,
      children: [
        const FormDadosCadastraisWidget(),
        const Center(child: Text('Informações Internas')),
        const Center(child: Text('Usuários')),
      ],
    );
  }
} 