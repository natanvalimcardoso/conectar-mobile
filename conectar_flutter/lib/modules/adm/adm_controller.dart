import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_constant.dart';
import '../../core/network/storage_client.dart';
import '../../core/models/client_model.dart';
import '../auth/login/login_controller.dart';
import 'clients/clients_controller.dart';
import 'form/adm_form_controller.dart';
import 'clients/client_form_controller.dart';

class AdmController extends GetxController with GetSingleTickerProviderStateMixin {
  // Tab Controller principal
  late TabController mainTabController;
  
  // Controllers injetadas
  late ClientsController clientsController;
  late AdmFormController formController;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _setupTabController();
    _registerFunctions();
  }

  @override
  void onClose() {
    mainTabController.dispose();
    _disposeControllers();
    super.onClose();
  }

  void _initializeControllers() {
    // Remove controllers existentes para evitar conflitos
    if (Get.isRegistered<ClientsController>()) {
      Get.delete<ClientsController>(force: true);
    }
    if (Get.isRegistered<AdmFormController>()) {
      Get.delete<AdmFormController>(force: true);
    }
    // Remove ClientFormController que pode estar conflitando
    if (Get.isRegistered<ClientFormController>()) {
      print('🗑️ Removendo ClientFormController conflitante da aba');
      Get.delete<ClientFormController>(force: true);
    }
    
    // Cria novas instâncias permanentes de forma síncrona
    clientsController = Get.put(ClientsController(), permanent: true);
    formController = Get.put(AdmFormController(), permanent: true);
    
    print('🎯 ClientsController criado: ${Get.isRegistered<ClientsController>()}');
    print('🎯 AdmFormController criado: ${Get.isRegistered<AdmFormController>()}');
    print('🚫 ClientFormController removido: ${!Get.isRegistered<ClientFormController>()}');
  }

  void _setupTabController() {
    mainTabController = TabController(length: 2, vsync: this);
    
    // Registra o TabController para poder ser acessado por outros controllers
    Get.put<TabController>(mainTabController, tag: 'mainTab');
  }

  void _registerFunctions() {
    // Registra função para editar cliente
    Get.put<Function(ClientModel)>((ClientModel client) {
      editClient(client);
    }, tag: 'editClient');
    
    // Registra função para criar novo cliente
    Get.put<VoidCallback>(() {
      newClient();
    }, tag: 'newClient');
  }

  void _disposeControllers() {
    // NÃO remove controllers permanentes, apenas remove registros de funções
    print('🧹 Limpando registros de funções...');
    
    // Remove registros de funções
    try {
      Get.delete<Function(ClientModel)>(tag: 'editClient');
      Get.delete<VoidCallback>(tag: 'newClient');
      Get.delete<TabController>(tag: 'mainTab');
      print('✅ Registros de funções removidos');
    } catch (e) {
      print('⚠️ Erro ao remover registros: $e');
    }
    
    // Mantém controllers permanentes ativos para outras páginas
    print('📌 Controllers permanentes mantidos');
  }

  // Métodos de navegação entre abas
  void goToClientsTab() {
    mainTabController.animateTo(0);
  }

  void goToFormTab() {
    mainTabController.animateTo(1);
  }

  // Lógica para criar novo cliente
  void newClient() {
    formController.resetForm();
    goToFormTab();
  }

  // Lógica para editar cliente
  void editClient(ClientModel client) {
    formController.editClient(client);
    goToFormTab();
  }

  // Lógica de logout
  Future<void> logout(BuildContext context) async {
    try {
      await StorageClient.removeToken();
      
      if (Get.isRegistered<LoginController>()) {
        Get.find<LoginController>().clearForm();
      }
      
      if (context.mounted) {
        GoRouter.of(context).go(AppRoutes.login);
      }
    } catch (e) {
      if (context.mounted) {
        GoRouter.of(context).go(AppRoutes.login);
      }
    }
  }

  // Getters para acesso às controllers
  ClientsController get clients => clientsController;
  AdmFormController get form => formController;
  
  // Getter para verificar se está na aba do formulário
  bool get isFormTabActive => mainTabController.index == 1;
  
  // Getter para verificar se está na aba de clientes
  bool get isClientsTabActive => mainTabController.index == 0;
} 