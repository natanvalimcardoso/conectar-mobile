import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/constants/route_constant.dart';
import '../../../core/models/client_model.dart';
import 'clients_controller.dart';

class ClientFormController extends GetxController with StateMixin<ClientModel>, GetSingleTickerProviderStateMixin {
  final String? clientId;
  
  ClientFormController({this.clientId});

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
  
  // Status e outros campos
  final selectedStatus = 'Ativo'.obs;
  final conectaPlus = false.obs;
  final tags = <String>[].obs;
  
  final isEditing = false.obs;
  final isLoading = false.obs;
  final pageTitle = 'Novo Cliente'.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    isEditing.value = clientId != null;
    pageTitle.value = isEditing.value ? 'Editar Cliente' : 'Novo Cliente';
    
    if (isEditing.value) {
      _loadClientData();
    } else {
      change(null, status: RxStatus.empty());
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
    
    // Simula uma chamada de API para carregar dados do cliente
    Future.delayed(const Duration(milliseconds: 500), () {
      // Mock de dados baseado no ID
      final mockClient = _getMockClient(clientId!);
      
      if (mockClient != null) {
        _fillFormWithClientData(mockClient);
        change(mockClient, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.error('Cliente não encontrado'));
      }
    });
  }

  ClientModel? _getMockClient(String id) {
    final mockClients = {
      '1': ClientModel(
        id: '1',
        razaoSocial: 'TOKEN TEST LTDA',
        nomeNaFachada: 'JOANINHA BISTRÔ',
        cnpj: '71.567.504/0001-74',
        status: 'Inativo',
        cep: '01310-100',
        rua: 'Avenida Paulista',
        numero: '1000',
        bairro: 'Bela Vista',
        cidade: 'São Paulo',
        estado: 'SP',
        conectaPlus: false,
        tags: [],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      '2': ClientModel(
        id: '2',
        razaoSocial: 'RESTAURANTE BOA VISTA',
        nomeNaFachada: 'RESTAURANTE BOA VISTA',
        cnpj: '71.673.090/0001-77',
        status: 'Inativo',
        cep: '04567-890',
        rua: 'Rua das Flores',
        numero: '123',
        bairro: 'Vila Madalena',
        cidade: 'São Paulo',
        estado: 'SP',
        conectaPlus: false,
        tags: [],
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    };
    
    return mockClients[id];
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

  // Validações
  String? validateRequired(String? value, String fieldName) {
    return Validatorless.required('$fieldName é obrigatório')(value);
  }

  String? validateCNPJ(String? value) {
    return Validatorless.multiple([
      Validatorless.required('CNPJ é obrigatório'),
      (value) {
        if (value != null && value.isNotEmpty) {
          // Validação básica de formato CNPJ
          final cleanCnpj = value.replaceAll(RegExp(r'[^\d]'), '');
          if (cleanCnpj.length != 14) {
            return 'CNPJ deve ter 14 dígitos';
          }
        }
        return null;
      },
    ])(value);
  }

  String? validateCEP(String? value) {
    return Validatorless.multiple([
      Validatorless.required('CEP é obrigatório'),
      (value) {
        if (value != null && value.isNotEmpty) {
          final cleanCep = value.replaceAll(RegExp(r'[^\d]'), '');
          if (cleanCep.length != 8) {
            return 'CEP deve ter 8 dígitos';
          }
        }
        return null;
      },
    ])(value);
  }

  Future<void> saveClient(BuildContext context) async {
    if (!dadosCadastraisFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    
    try {
      // Simula uma chamada de API
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final clientData = ClientModel(
        id: clientId ?? DateTime.now().millisecondsSinceEpoch.toString(),
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
        complemento: complementoController.text.trim().isEmpty 
            ? null 
            : complementoController.text.trim(),
        conectaPlus: conectaPlus.value,
        tags: tags,
        createdAt: state?.createdAt ?? DateTime.now(),
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

        // Para novos clientes, limpa apenas os campos principais mantendo endereço
        if (!isEditing.value) {
          nomeNaFachadaController.clear();
          cnpjController.clear();
          razaoSocialController.clear();
          // Mantém endereço para facilitar cadastro de clientes na mesma região
        }

        // Aguarda um pouco antes de navegar para mostrar o SnackBar
        await Future.delayed(const Duration(milliseconds: 500));
        
        GoRouter.of(context).go(AppRoutes.admin);
      }
      
    } catch (e) {
      // Log do erro e mostra mensagem de erro
      print('Erro ao salvar cliente: $e');
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
    GoRouter.of(context).go(AppRoutes.admin);
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