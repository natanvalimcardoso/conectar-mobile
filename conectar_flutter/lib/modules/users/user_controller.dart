/// Controller responsável pelo gerenciamento do perfil do usuário.
/// 
/// Funcionalidades implementadas:
/// - Carregamento automático das informações do usuário
/// - Edição do nome do usuário
/// - Alteração da senha do usuário
/// - Logout seguro
/// - Estados reativos com obs
/// - Validações de formulário
/// - Tratamento de erros
/// 
/// Widgets utilizados:
/// - UserProfileWidget: Widget principal da tela
/// - UserInfoSectionWidget: Mostra informações básicas (nome, email, data de criação)
/// - UserNameSectionWidget: Permite editar o nome
/// - UserPasswordSectionWidget: Permite alterar a senha
/// 
/// API endpoints (mocks temporários incluídos):
/// - GET /users/profile: Obter dados do usuário
/// - PATCH /users/profile: Atualizar dados do usuário

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/constants/route_constant.dart';
import '../../core/models/user_model.dart';
import '../../core/network/storage_client.dart';
import '../../core/repositories/user/user_repository.dart';
import '../auth/login/login_controller.dart';

class UserController extends GetxController with StateMixin<UserModel> {
  final UserRepository _userRepository;
  
  UserController(this._userRepository);

  // Form controllers
  final nameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form keys
  final profileFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  // Observable states
  final isEditingName = false.obs;
  final isEditingPassword = false.obs;
  final isLoadingProfile = false.obs;
  final isLoadingPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Pequeno delay para garantir que o token está disponível
    Future.delayed(const Duration(milliseconds: 100), () {
      loadUserProfile();
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> loadUserProfile() async {
    change(null, status: RxStatus.loading());
    
    try {
      // Debug: verifica se tem token antes de fazer a chamada
      final hasToken = await StorageClient.hasToken();
      final token = await StorageClient.getToken();
      
      final user = await _userRepository.getUserProfile();
      nameController.text = user.name;
      change(user, status: RxStatus.success());
    } catch (e) {
      final errorMessage = e.toString();
      
      // Verifica se é erro de autenticação
      if (errorMessage.contains('Token inválido') || 
          errorMessage.contains('Sessão expirada') || 
          errorMessage.contains('Acesso negado')) {
        
        // Remove token inválido
        await StorageClient.removeToken();
        
        // Limpa controller de login se existir
        if (Get.isRegistered<LoginController>()) {
          Get.find<LoginController>().clearForm();
        }
        
        change(null, status: RxStatus.error('Token inválido. Faça login novamente.'));
      } else {
        change(null, status: RxStatus.error(errorMessage));
      }
    }
  }

  void toggleEditName() {
    if (isEditingName.value) {
      // Cancela edição - restaura nome original
      nameController.text = state?.name ?? '';
    }
    isEditingName.value = !isEditingName.value;
    update(['editingName']);
  }

  void toggleEditPassword() {
    if (isEditingPassword.value) {
      // Cancela edição - limpa campos
      clearPasswordFields();
    }
    isEditingPassword.value = !isEditingPassword.value;
    update(['editingPassword']);
  }

  void clearPasswordFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> updateUserName(BuildContext context) async {
    if (!profileFormKey.currentState!.validate()) return;
    if (isLoadingProfile.value) return;

    isLoadingProfile.value = true;
    
    try {
      final updatedUser = await _userRepository.updateUserProfile(
        userId: state!.id,
        name: nameController.text.trim(),
      );
      
      change(updatedUser, status: RxStatus.success());
      isEditingName.value = false;
      update(['editingName']);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nome atualizado com sucesso!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar nome: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isLoadingProfile.value = false;
      update(['loadingProfile']);
    }
  }

  Future<void> updateUserPassword(BuildContext context) async {
    if (!passwordFormKey.currentState!.validate()) return;
    if (isLoadingPassword.value) return;

    isLoadingPassword.value = true;
    update(['loadingPassword']);
    
    try {
      final updatedUser = await _userRepository.updateUserProfile(
        userId: state!.id,
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );
      
      change(updatedUser, status: RxStatus.success());
      isEditingPassword.value = false;
      clearPasswordFields();
      update(['editingPassword']);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha atualizada com sucesso!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar senha: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isLoadingPassword.value = false;
      update(['loadingPassword']);
    }
  }

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

  // Validations
  String? validateName(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Nome é obrigatório'),
      Validatorless.min(2, 'Nome deve ter pelo menos 2 caracteres'),
      Validatorless.max(100, 'Nome deve ter no máximo 100 caracteres'),
    ])(value);
  }

  String? validateCurrentPassword(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Senha atual é obrigatória'),
      Validatorless.min(6, 'Senha deve ter pelo menos 6 caracteres'),
    ])(value);
  }

  String? validateNewPassword(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Nova senha é obrigatória'),
      Validatorless.min(6, 'Senha deve ter pelo menos 6 caracteres'),
    ])(value);
  }

  String? validateConfirmPassword(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Confirmação de senha é obrigatória'),
      Validatorless.compare(newPasswordController, 'Senhas não coincidem'),
    ])(value);
  }

  // Getters
  String get formattedCreatedAt {
    if (state?.createdAt == null) return '';
    final date = state!.createdAt;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String get userRole {
    if (state?.role == null) return '';
    switch (state!.role.toLowerCase()) {
      case 'admin':
        return 'Administrador';
      case 'user':
        return 'Usuário';
      default:
        return state!.role;
    }
  }
} 