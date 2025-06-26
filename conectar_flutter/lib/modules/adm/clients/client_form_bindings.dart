import 'package:get/get.dart';

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
    
    // Cria um novo controller de forma síncrona
    final clientId = Get.parameters['id'];
    print('🆕 [ClientFormBindings] Criando ClientFormController com ID: $clientId');
    
    Get.put<ClientFormController>(
      ClientFormController(clientId: clientId),
      permanent: false, // NÃO permanente para evitar conflitos
    );
    
    print('✅ [ClientFormBindings] ClientFormController criado com sucesso');
  }
} 