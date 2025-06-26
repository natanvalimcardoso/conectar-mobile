import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/image_constant.dart';
import '../../../core/widgets/inputs/custom_input_widget.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

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
            constraints: BoxConstraints(maxWidth: isWeb ? 400 : double.infinity),
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
                        const Text(
                          'Criar Conta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),

                        const SizedBox(height: 24),

                        CustomInputWidget(
                          hintText: 'Nome completo',
                          controller: controller.nameController,
                          validator: controller.validateName,
                          keyboardType: TextInputType.text,
                        ),

                        const SizedBox(height: 16),

                        CustomInputWidget(
                          hintText: 'Email',
                          controller: controller.emailController,
                          validator: controller.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),

                        CustomInputWidget(
                          hintText: 'Senha',
                          controller: controller.passwordController,
                          validator: controller.validatePassword,
                          isPasswordField: true,
                        ),

                        const SizedBox(height: 16),

                        CustomInputWidget(
                          hintText: 'Confirmar senha',
                          controller: controller.confirmPasswordController,
                          validator: controller.validateConfirmPassword,
                          isPasswordField: true,
                        ),

                        const SizedBox(height: 32),

                        controller.obx(
                          (state) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.navigateToLoginWithData(context);
                            });

                            return SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Redirecionando...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          onLoading: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                disabledBackgroundColor:
                                    const Color(0xFF4CAF50).withOpacity(0.7),
                              ),
                              child: const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          onError: (error) => Column(
                            children: [
                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () => controller.register(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('Tentar Novamente', style: TextStyle(color: Colors.white),),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                error ?? 'Ocorreu um erro!',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          onEmpty: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => controller.register(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Criar Conta',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () => controller.navigateToLogin(context),
                          child: const Text(
                            'Já tem uma conta? Fazer login',
                            style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w500),
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
