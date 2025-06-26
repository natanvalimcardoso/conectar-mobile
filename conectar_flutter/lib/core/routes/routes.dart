import 'package:go_router/go_router.dart';

import '../../modules/adm/adm_page.dart';
import '../../modules/adm/adm_bindings.dart';
import '../../modules/adm/clients/client_form_page.dart';
import '../../modules/adm/clients/client_form_bindings.dart';
import '../../modules/auth/login/login_bindings.dart';
import '../../modules/auth/login/login_page.dart';
import '../../modules/auth/register/register_bindings.dart';
import '../../modules/auth/register/register_page.dart';
import '../../modules/users/user_page.dart';
import '../constants/route_constant.dart';
import '../network/storage_client.dart';



final GoRouter router = GoRouter(
  initialLocation: AppRoutes.login,
  redirect: (context, state) async {
    final hasToken = await StorageClient.hasToken();
    final isLoginPage = state.matchedLocation == AppRoutes.login;
    final isRegisterPage = state.matchedLocation == AppRoutes.register;

    if (!hasToken && !isLoginPage && !isRegisterPage) {
      return AppRoutes.login;
    }

    
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        LoginBindings().dependencies();
        return const LoginPage();
      },
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) {
        RegisterBindings().dependencies();
        return const RegisterPage();
      },
    ),
    GoRoute(
      path: AppRoutes.user,
      builder: (context, state) {
        return const UserPage();
      },
    ),
    GoRoute(
      path: AppRoutes.admin,
      builder: (context, state) {
        AdmBindings().dependencies();
        return const AdmPage();
      },
      routes: [
        GoRoute(
          path: 'clients/new',
          builder: (context, state) {
            ClientFormBindings().dependencies();
            return const ClientFormPage();
          },
        ),
        GoRoute(
          path: 'clients/edit/:id',
          builder: (context, state) {
            ClientFormBindings().dependencies();
            return const ClientFormPage();
          },
        ),
      ],
    ),
  ],
);

