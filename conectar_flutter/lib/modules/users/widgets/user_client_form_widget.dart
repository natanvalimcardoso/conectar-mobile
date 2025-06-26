import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../user_client_form_controller.dart';
import '../../clients/widgets/informacoes_internas_tab_widget.dart';
import '../../clients/widgets/usuarios_tab_widget.dart';
import 'user_dados_cadastrais_widget.dart';
import 'user_bottom_actions_widget.dart';

class UserClientFormWidget extends GetView<UserClientFormController> {
  const UserClientFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              const UserDadosCadastraisWidget(),
              const InformacoesInternasTabWidget(),
              const UsuariosTabWidget(),
            ],
          ),
        ),
        const UserBottomActionsWidget(),
      ],
    );
  }
} 