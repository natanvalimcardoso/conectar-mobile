import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:validatorless/validatorless.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final pageTitle = 'Novo Cliente'.obs;

  @override
  void onInit() {
    super.onInit();
    print('🚀 [ClientFormController] Inicializando controller com clientId: $clientId');
    
    tabController = TabController(length: 3, vsync: this);
    isEditing.value = clientId != null;
    pageTitle.value = isEditing.value ? 'Editar Cliente' : 'Novo Cliente';
    
    print('✏️ [ClientFormController] Modo de edição: ${isEditing.value}');
    print('📄 [ClientFormController] Título da página: ${pageTitle.value}');
    
    if (isEditing.value && clientId != null) {
      print('🔄 [ClientFormController] Carregando dados do cliente...');
      _loadClientData();
    } else {
      print('📝 [ClientFormController] Modo de criação - formulário vazio');
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
    print('🔍 [ClientFormController] Carregando dados para clientId: $clientId');
    change(null, status: RxStatus.loading());
    
    // Simula uma chamada de API para carregar dados do cliente
    Future.delayed(const Duration(milliseconds: 500), () {
      // Mock de dados baseado no ID
      final mockClient = _getMockClient(clientId!);
      
      print('📋 [ClientFormController] Cliente encontrado: ${mockClient?.nomeNaFachada}');
      
      if (mockClient != null) {
        _fillFormWithClientData(mockClient);
        change(mockClient, status: RxStatus.success());
        print('✅ [ClientFormController] Dados carregados com sucesso');
      } else {
        print('❌ [ClientFormController] Cliente não encontrado para ID: $clientId');
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
        tags: ['Restaurante', 'Bistrô'],
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
        tags: ['Restaurante', 'Alimentação'],
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      '3': ClientModel(
        id: '3',
        razaoSocial: 'TOKEN TEST LTDA',
        nomeNaFachada: 'Geo Food',
        cnpj: '64.132.434/0001-61',
        status: 'Inativo',
        cep: '12345-678',
        rua: 'Rua do Comércio',
        numero: '456',
        bairro: 'Centro',
        cidade: 'Rio de Janeiro',
        estado: 'RJ',
        conectaPlus: false,
        tags: ['Delivery', 'Fast Food'],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      '4': ClientModel(
        id: '4',
        razaoSocial: 'SUPERMERCADO CENTRAL LTDA',
        nomeNaFachada: 'Super Central',
        cnpj: '88.999.777/0001-55',
        status: 'Ativo',
        cep: '54321-987',
        rua: 'Avenida Brasil',
        numero: '789',
        bairro: 'Copacabana',
        cidade: 'Rio de Janeiro',
        estado: 'RJ',
        conectaPlus: true,
        tags: ['Supermercado', 'Alimentação'],
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      '5': ClientModel(
        id: '5',
        razaoSocial: 'FARMÁCIA SAÚDE LTDA',
        nomeNaFachada: 'Farmácia Saúde Plus',
        cnpj: '22.333.444/0001-99',
        status: 'Ativo',
        cep: '87654-321',
        rua: 'Rua da Saúde',
        numero: '321',
        bairro: 'Vila Nova',
        cidade: 'Belo Horizonte',
        estado: 'MG',
        conectaPlus: true,
        tags: ['Farmácia', 'Saúde'],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
    };
    
    return mockClients[id];
  }

  void _fillFormWithClientData(ClientModel client) {
    print('📝 [ClientFormController] Preenchendo formulário com dados do cliente: ${client.nomeNaFachada}');
    
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
    tags.value = List<String>.from(client.tags); // Cria uma nova lista
    
    print('📝 [ClientFormController] Campos preenchidos:');
    print('   Nome na fachada: ${nomeNaFachadaController.text}');
    print('   CNPJ: ${cnpjController.text}');
    print('   Razão Social: ${razaoSocialController.text}');
    print('   Status: ${selectedStatus.value}');
    print('   Conecta Plus: ${conectaPlus.value}');
    print('   Tags: ${tags.value}');
    
    // Força uma atualização da interface
    update();
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
    // Tags não são obrigatórias, apenas validamos se foram informadas
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

    // Proteção contra duplo clique
    if (isLoading.value) {
      print('⚠️ [ClientForm] Salvamento já em andamento, ignorando...');
      return;
    }

    isLoading.value = true;
    
    try {
      print('🏷️ [ClientForm] Tags no formulário: ${tags.toList()}');
      
      // Simula uma chamada de API
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Gera um ID único mais robusto
      final clientId = this.clientId ?? '${DateTime.now().millisecondsSinceEpoch}_${nomeNaFachadaController.text.hashCode.abs()}';
      
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
        createdAt: state?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('🏷️ [ClientForm] Tags no cliente criado: ${clientData.tags}');

      // Adiciona o cliente à lista no ClientsController
      if (Get.isRegistered<ClientsController>()) {
        final clientsController = Get.find<ClientsController>();
        print('🔍 [ClientForm] ClientsController encontrado: ${clientsController.runtimeType}');
        
        if (isEditing.value) {
          print('✏️ [ClientForm] Atualizando cliente existente: ${clientData.nomeNaFachada}');
          clientsController.updateClient(clientData);
        } else {
          print('➕ [ClientForm] Adicionando novo cliente: ${clientData.nomeNaFachada}');
          clientsController.addClient(clientData);
        }
        
        print('📋 [ClientForm] Cliente processado com sucesso');
      } else {
        print('❌ [ClientForm] ClientsController não encontrado!');
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
        
        // Navega de volta para admin
        GoRouter.of(context).go(AppRoutes.admin);
        
        print('✅ [ClientForm] Navegação concluída com sucesso');
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