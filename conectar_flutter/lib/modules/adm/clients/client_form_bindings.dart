import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'client_form_controller.dart';

class ClientFormBindings extends Bindings {
  @override
  void dependencies() {
    print('🔧 [ClientFormBindings] Inicializando dependencies...');
    
    // Remove todos os controllers relacionados que podem estar conflitando
    if (Get.isRegistered<ClientFormController>()) {
      print('🗑️ [ClientFormBindings] Removendo ClientFormController existente');
      Get.delete<ClientFormController>(force: true);
    }
    
    // Pega o clientId do GoRouter context
    // Como não temos acesso direto ao context aqui, vamos modificar a abordagem
    print('🆔 [ClientFormBindings] Tentando obter clientId...');
    
    Get.put<ClientFormController>(
      ClientFormController(clientId: null), // Será definido posteriormente
      permanent: false, // NÃO permanente para evitar conflitos
    );
    
    print('✅ [ClientFormBindings] ClientFormController criado com sucesso');
  }
} 