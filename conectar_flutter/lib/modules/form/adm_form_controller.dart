import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../core/models/client_model.dart';
import '../clients/clients_controller.dart';

class AdmFormController extends GetxController with GetSingleTickerProviderStateMixin {
  // TabController
  late TabController tabController;

  // Form keys
  final dadosCadastraisFormKey = GlobalKey<FormState>();
  
  // Controllers dos dados cadastrais
  final nomeNaFachadaController = TextEditingController();
  final cnpjController = TextEditingController();
  final razaoSocialController = TextEditingController();
  
  // Controllers do endereço
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final complementoController = TextEditingController();
  
  // Formatadores
  final cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  
  final cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
  );
  
  // Status e outros campos
  final selectedStatus = 'Ativo'.obs;
  final conectaPlus = false.obs;
  final tags = <String>[].obs;
  
  final isEditing = false.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final pageTitle = 'Novo Cliente'.obs;
  final editingClientId = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    resetForm();
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

  void resetForm() {
    clearForm();
    isEditing.value = false;
    isLoading.value = false;
    isSaving.value = false;
    editingClientId.value = null;
    pageTitle.value = 'Novo Cliente';
  }

  void editClient(ClientModel client) {
    isEditing.value = true;
    editingClientId.value = client.id;
    pageTitle.value = 'Editar Cliente';
    _fillFormWithClientData(client);
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
    tags.value = client.tags;
  }

  // Validações usando apenas validatorless
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
    // Complemento não é obrigatório, remove a validação required
    if (value == null || value.trim().isEmpty) {
      return null; // Campo opcional
    }
    return Validatorless.multiple([
      Validatorless.min(2, 'Complemento deve ter pelo menos 2 caracteres'),
      Validatorless.max(50, 'Complemento deve ter no máximo 50 caracteres'),
    ])(value);
  }

  String? validateTag(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Tag é obrigatória'),
      Validatorless.min(2, 'Tag deve ter pelo menos 2 caracteres'),
      Validatorless.max(20, 'Tag deve ter no máximo 20 caracteres'),
    ])(value);
  }

  Future<void> saveClient(BuildContext context) async {
    if (!dadosCadastraisFormKey.currentState!.validate()) {
      return;
    }

    // Proteção tripla contra duplo clique
    if (isLoading.value || isSaving.value) {
      return;
    }

    // Marca as duas flags como true
    isLoading.value = true;
    isSaving.value = true;
    
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Gera um ID único mais robusto
      final clientId = editingClientId.value ?? '${DateTime.now().millisecondsSinceEpoch}_${nomeNaFachadaController.text.hashCode.abs()}';
      
      final clientData = ClientModel(
        id: clientId,
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
        tags: tags.toList(), // Garante que é uma nova lista
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Adiciona o cliente à lista no ClientsController
      if (Get.isRegistered<ClientsController>()) {
        final clientsController = Get.find<ClientsController>();
        
        if (isEditing.value) {
          clientsController.updateClient(clientData);
        } else {
          clientsController.addClient(clientData);
        }
      }

      // Mostra mensagem de sucesso
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing.value 
                ? 'Cliente atualizado com sucesso!' 
                : 'Cliente adicionado com sucesso!',
            ),
            backgroundColor: const Color(0xFF4CAF50),
            duration: const Duration(seconds: 2),
          ),
        );

        // Reseta o formulário
        resetForm();
        
        // Navega para a aba de clientes
        try {
          final mainTabController = Get.find<TabController>(tag: 'mainTab');
          mainTabController.animateTo(0); // Aba de clientes
        } catch (e) {
        }
      }
      
    } catch (e) {
      // Log do erro e mostra mensagem de erro
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar cliente. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Reseta ambas as flags
      isLoading.value = false;
      isSaving.value = false;
    }
  }

  void cancel(BuildContext context) {
    resetForm();
  }

  void clearForm() {
    nomeNaFachadaController.clear();
    cnpjController.clear();
    razaoSocialController.clear();
    cepController.clear();
    ruaController.clear();
    numeroController.clear();
    bairroController.clear();
    cidadeController.clear();
    estadoController.clear();
    complementoController.clear();
    selectedStatus.value = 'Ativo';
    conectaPlus.value = false;
    tags.clear();
  }

  // Métodos para gerenciar tags
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