import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/constants/route_constant.dart';
import '../../../core/models/register/register_request_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/register/register_repository.dart';
import '../login/login_controller.dart';

class RegisterController extends GetxController with StateMixin<UserModel> {
  final RegisterRepository _registerRepository;
  
  RegisterController(this._registerRepository);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.empty());
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  String? validateName(String? name) {
    return Validatorless.multiple([
      Validatorless.required('Nome é obrigatório'),
      Validatorless.min(2, 'Nome deve ter pelo menos 2 caracteres'),
    ])(name);
  }

  String? validateEmail(String? email) {
    return Validatorless.multiple([
      Validatorless.required('Email é obrigatório'),
      Validatorless.email('Digite um email válido'),
    ])(email);
  }

  String? validatePassword(String? password) {
    return Validatorless.multiple([
      Validatorless.required('Senha é obrigatória'),
      Validatorless.min(6, 'Senha deve ter pelo menos 6 caracteres'),
    ])(password);
  }

  String? validateConfirmPassword(String? confirmPassword) {
    return Validatorless.multiple([
      Validatorless.required('Confirmação de senha é obrigatória'),
      Validatorless.compare(passwordController, 'Senhas não coincidem'),
    ])(confirmPassword);
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    change(null, status: RxStatus.loading());

    try {
      final request = RegisterRequestModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final response = await _registerRepository.register(request);

      if (response.success && response.data != null) {
        change(response.data, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.error(response.message));
      }
    } catch (e) {
      change(null, status: RxStatus.error('Erro de conexão. Tente novamente.'));
    }
  }

  void navigateToLoginWithData(BuildContext context) {
    if (status.isSuccess) {
      // Preenche os dados no LoginController se estiver registrado
      if (Get.isRegistered<LoginController>()) {
        final loginController = Get.find<LoginController>();
        loginController.emailController.text = emailController.text;
        loginController.passwordController.text = passwordController.text;
      }
      
      GoRouter.of(context).go(AppRoutes.login);
    }
  }

  void navigateToLogin(BuildContext context) {
    GoRouter.of(context).go(AppRoutes.login);
  }
} 