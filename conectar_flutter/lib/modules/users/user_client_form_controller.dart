import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:validatorless/validatorless.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../core/constants/route_constant.dart';
import '../../core/models/client_model.dart';
import '../../core/data/clients_mock_data.dart';
import 'user_clients_controller.dart';

class UserClientFormController extends GetxController with StateMixin<ClientModel>, GetSingleTickerProviderStateMixin {
  final String? clientId;
  
  UserClientFormController({this.clientId});

  late TabController tabController;

  final dadosCadastraisFormKey = GlobalKey<FormState>();
  
  final nomeNaFachadaController = TextEditingController();
  final cnpjController = TextEditingController();
  final razaoSocialController = TextEditingController();
  
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final complementoController = TextEditingController();
  
  final cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  
  final cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
  );
  
  final selectedStatus = 'Ativo'.obs;
  final conectaPlus = false.obs;
  final tags = <String>[].obs;
  
  final isLoading = false.obs;
  final pageTitle = 'Editar Cliente'.obs; // Sempre edição para usuários

  @override
  void onInit() {
    super.onInit();
    
    tabController = TabController(length: 3, vsync: this);
    
    if (clientId != null) {
      _loadClientData();
    } else {
      change(null, status: RxStatus.error('ID do cliente não fornecido'));
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    nomeNaFachadaController.dispose();
    cnpjController.dispose();
    razaoSocialController.dispose();
    cepController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    complementoController.dispose();
    super.onClose();
  }

  void _loadClientData() {
    change(null, status: RxStatus.loading());
    
    Future.delayed(const Duration(milliseconds: 500), () {
      final client = ClientsMockData.getClientById(clientId!);
      
      if (client != null) {
        _fillFormWithClientData(client);
        change(client, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.error('Cliente não encontrado'));
      }
    });
  }

  void _fillFormWithClientData(ClientModel client) {
    nomeNaFachadaController.text = client.nomeNaFachada;
    cnpjController.text = client.cnpj;
    razaoSocialController.text = client.razaoSocial;
    cepController.text = client.cep;
    ruaController.text = client.rua;
    numeroController.text = client.numero;
    bairroController.text = client.bairro;
    cidadeController.text = client.cidade;
    estadoController.text = client.estado;
    complementoController.text = client.complemento ?? '';
    selectedStatus.value = client.status;
    conectaPlus.value = client.conectaPlus;
    tags.value = List<String>.from(client.tags);
    
    update();
  }

  // Validações (iguais ao controller de admin)
  String? validateNomeFachada(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Nome na fachada é obrigatório'),
      Validatorless.min(2, 'Nome na fachada deve ter pelo menos 2 caracteres'),
      Validatorless.max(100, 'Nome na fachada deve ter no máximo 100 caracteres'),
    ])(value);
  }

  String? validateCNPJ(String? value) {
    return Validatorless.multiple([
      Validatorless.required('CNPJ é obrigatório'),
      Validatorless.cnpj('CNPJ inválido'),
    ])(value);
  }

  String? validateRazaoSocial(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Razão Social é obrigatória'),
      Validatorless.min(2, 'Razão Social deve ter pelo menos 2 caracteres'),
      Validatorless.max(150, 'Razão Social deve ter no máximo 150 caracteres'),
    ])(value);
  }

  String? validateCEP(String? value) {
    return Validatorless.multiple([
      Validatorless.required('CEP é obrigatório'),
      (String? val) {
        if (val == null) return null;
        final cleanValue = val.replaceAll(RegExp(r'[^0-9]'), '');
        if (cleanValue.length != 8) {
          return 'CEP deve ter 8 dígitos';
        }
        return null;
      },
    ])(value);
  }

  String? validateRua(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Rua é obrigatória'),
      Validatorless.min(5, 'Rua deve ter pelo menos 5 caracteres'),
      Validatorless.max(100, 'Rua deve ter no máximo 100 caracteres'),
    ])(value);
  }

  String? validateNumero(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Número é obrigatório'),
      Validatorless.max(10, 'Número deve ter no máximo 10 caracteres'),
    ])(value);
  }

  String? validateBairro(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Bairro é obrigatório'),
      Validatorless.min(2, 'Bairro deve ter pelo menos 2 caracteres'),
      Validatorless.max(50, 'Bairro deve ter no máximo 50 caracteres'),
    ])(value);
  }

  String? validateCidade(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Cidade é obrigatória'),
      Validatorless.min(2, 'Cidade deve ter pelo menos 2 caracteres'),
      Validatorless.max(50, 'Cidade deve ter no máximo 50 caracteres'),
    ])(value);
  }

  String? validateEstado(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Estado é obrigatório'),
      (String? val) {
        if (val == null) return null;
        if (val.length != 2) {
          return 'Estado deve ter exatamente 2 caracteres';
        }
        return null;
      },
    ])(value);
  }

  String? validateComplemento(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return Validatorless.multiple([
      Validatorless.min(2, 'Complemento deve ter pelo menos 2 caracteres'),
      Validatorless.max(50, 'Complemento deve ter no máximo 50 caracteres'),
    ])(value);
  }

  String? validateTag(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tag não pode estar vazia';
    }
    
    return Validatorless.multiple([
      Validatorless.min(2, 'Tag deve ter pelo menos 2 caracteres'),
      Validatorless.max(20, 'Tag deve ter no máximo 20 caracteres'),
    ])(value);
  }

  Future<void> saveClient(BuildContext context) async {
    if (!dadosCadastraisFormKey.currentState!.validate()) {
      return;
    }

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;
    
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final clientData = ClientModel(
        id: clientId!,
        razaoSocial: razaoSocialController.text.trim(),
        nomeNaFachada: nomeNaFachadaController.text.trim(),
        cnpj: cnpjController.text.trim(),
        status: selectedStatus.value,
        cep: cepController.text.trim(),
        rua: ruaController.text.trim(),
        numero: numeroController.text.trim(),
        bairro: bairroController.text.trim(),
        cidade: cidadeController.text.trim(),
        estado: estadoController.text.trim(),
        complemento: complementoController.text.trim(),
        conectaPlus: conectaPlus.value,
        tags: tags.toList(),
        createdAt: state?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Atualiza no mock global
      ClientsMockData.updateClient(clientData);

      // Atualiza no controller de usuários se estiver registrado
      if (Get.isRegistered<UserClientsController>()) {
        final userClientsController = Get.find<UserClientsController>();
        userClientsController.updateClient(clientData);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente atualizado com sucesso!'),
            backgroundColor: Color(0xFF4CAF50),
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        
        GoRouter.of(context).go(AppRoutes.user);
      }
      
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar cliente. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void cancel(BuildContext context) {
    GoRouter.of(context).go(AppRoutes.user);
  }

  void addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !tags.contains(trimmedTag)) {
      tags.add(trimmedTag);
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
  }

  bool hasTag(String tag) {
    return tags.contains(tag);
  }
} 