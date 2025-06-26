import 'package:go_router/go_router.dart';

import '../../modules/auth/login/login_bindings.dart';
import '../../modules/auth/login/login_page.dart';
import '../constants/route_constant.dart';
import '../network/storage_client.dart';



final GoRouter router = GoRouter(
  initialLocation: AppRoutes.login,
  redirect: (context, state) async {
    final hasToken = await StorageClient.hasToken();
    final isLoginPage = state.matchedLocation == AppRoutes.login;
    
    if (!hasToken && !isLoginPage) {
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
  ],
);

