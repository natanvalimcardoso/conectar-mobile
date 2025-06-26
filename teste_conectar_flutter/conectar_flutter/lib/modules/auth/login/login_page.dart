import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/image_constant.dart';
import '../../../core/helpers/snackbars/snackbar_helper.dart';
import '../../../core/widgets/inputs/custom_input_widget.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWeb = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 400 : double.infinity,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: isWeb ? 0 : 60),
                  
                  Image.asset(
                    ImageConstant.conectarLogo,
                    height: isWeb ? 80 : 60,
                    fit: BoxFit.contain,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                  
                  SizedBox(height: isWeb ? 40 : 60),
                  
                  Container(
                    padding: EdgeInsets.all(isWeb ? 32 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomInputWidget(
                          hintText: 'Email',
                          controller: controller.emailController,
                          validator: controller.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        CustomInputWidget(
                          hintText: 'Senha',
                          controller: controller.passwordController,
                          validator: controller.validatePassword,
                          isPasswordField: true,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.login();
                              
                              if (!context.mounted) return;
                              
                              if (controller.status.isSuccess) {
                                SnackbarHelper.showSuccess( 
                                  title: 'Sucesso',
                                  subtitle: 'Login realizado com sucesso!',
                                );
                                controller.navigateToHome(context);
                              } else if (controller.status.isError) {
                                SnackbarHelper.showError(
                                  title: 'Erro',
                                  subtitle: controller.status.errorMessage ?? 'Erro desconhecido',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isWeb ? 0 : 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}