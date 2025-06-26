// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/constants/route_constant.dart';
import '../../../core/models/login/login_request_model.dart';
import '../../../core/models/login/login_response_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/network/storage_client.dart';
import '../../../core/repositories/login/login_repository.dart';

class LoginController extends GetxController with StateMixin<UserModel> {
  final LoginRepository _loginRepository;
  
  LoginController(this._loginRepository);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
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

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    change(null, status: RxStatus.loading());

    try {
      final request = LoginRequestModel(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final response = await _loginRepository.login(request);

      if (response.success && response.data != null) {
        await _handleSuccessLogin(response);
      } else {
        change(null, status: RxStatus.error(response.message));
      }
    } catch (e) {
      change(null, status: RxStatus.error('Erro de conexão. Tente novamente.'));
    }
  }

  Future<void> _handleSuccessLogin(LoginResponseModel response) async {
    try {
      await StorageClient.saveToken(response.data!.token);
      change(response.data!.user, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error('Erro ao salvar dados de login'));
    }
  }

  void navigateToHome(BuildContext context) {
    if (status.isSuccess) {
      GoRouter.of(context).go(AppRoutes.home);
    }
  }

}
