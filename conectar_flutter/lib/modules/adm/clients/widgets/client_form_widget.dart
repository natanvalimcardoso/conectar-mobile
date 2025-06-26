import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client_form_controller.dart';
import 'informacoes_internas_tab_widget.dart';
import 'usuarios_tab_widget.dart';
import 'dados_cadastrais_widget.dart';
import 'bottom_actions_widget.dart';

class ClientFormWidget extends GetView<ClientFormController> {
  const ClientFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              const DadosCadastraisWidget(),
              const InformacoesInternasTabWidget(),
              const UsuariosTabWidget(),
            ],
          ),
        ),
        const BottomActionsWidget(),
      ],
    );
  }
} 