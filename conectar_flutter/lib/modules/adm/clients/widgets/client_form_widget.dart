import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/inputs/custom_input_widget.dart';
import '../client_form_controller.dart';
import 'informacoes_internas_tab_widget.dart';
import 'usuarios_tab_widget.dart';
import 'status_dropdown_widget.dart';
import 'conecta_plus_checkbox_widget.dart';
import 'save_button_widget.dart';

class ClientFormWidget extends GetView<ClientFormController> {
  const ClientFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              _buildDadosCadastraisWithObx(),
              const InformacoesInternasTabWidget(),
              const UsuariosTabWidget(),
            ],
          ),
        ),
        _buildBottomActionsWithObx(context),
      ],
    );
  }

  Widget _buildDadosCadastraisWithObx() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.dadosCadastraisFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações Cadastrais',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            CustomInputWidget(
              hintText: 'Nome na fachada',
              controller: controller.nomeNaFachadaController,
              validator: (value) => controller.validateRequired(value, 'Nome na fachada'),
            ),
            const SizedBox(height: 16),
            
            CustomInputWidget(
              hintText: 'CNPJ',
              controller: controller.cnpjController,
              validator: controller.validateCNPJ,
            ),
            const SizedBox(height: 16),
            
            CustomInputWidget(
              hintText: 'Razão Social',
              controller: controller.razaoSocialController,
              validator: (value) => controller.validateRequired(value, 'Razão Social'),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Endereço',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomInputWidget(
                    hintText: 'CEP',
                    controller: controller.cepController,
                    validator: controller.validateCEP,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: CustomInputWidget(
                    hintText: 'Rua',
                    controller: controller.ruaController,
                    validator: (value) => controller.validateRequired(value, 'Rua'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomInputWidget(
                    hintText: 'Número',
                    controller: controller.numeroController,
                    validator: (value) => controller.validateRequired(value, 'Número'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: CustomInputWidget(
                    hintText: 'Bairro',
                    controller: controller.bairroController,
                    validator: (value) => controller.validateRequired(value, 'Bairro'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomInputWidget(
                    hintText: 'Cidade',
                    controller: controller.cidadeController,
                    validator: (value) => controller.validateRequired(value, 'Cidade'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: CustomInputWidget(
                    hintText: 'Estado',
                    controller: controller.estadoController,
                    validator: (value) => controller.validateRequired(value, 'Estado'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            CustomInputWidget(
              hintText: 'Complemento (opcional)',
              controller: controller.complementoController,
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            const StatusDropdownWidget(),
            
            const SizedBox(height: 16),
            
            const ConectaPlusCheckboxWidget(),
            
            const SizedBox(height: 32),
            
            const Text(
              'Tags',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTagsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionsWithObx(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.cancel(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF4CAF50)),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF4CAF50)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.clearForm(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.orange),
              ),
              child: const Text(
                'Limpar',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: const SaveButtonWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    final tagController = TextEditingController();
    
    void addTag() {
      final newTag = tagController.text.trim();
      if (newTag.isNotEmpty) {
        controller.addTag(newTag);
        tagController.clear();
      }
    }
    
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo para adicionar nova tag
        Row(
          children: [
            Expanded(
              child: CustomInputWidget(
                hintText: 'Digite uma tag e pressione Enter',
                controller: tagController,
                onChanged: (value) {
                  // Adiciona tag quando pressiona Enter
                  if (value.endsWith('\n')) {
                    addTag();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: addTag,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              child: const Text('Adicionar'),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Lista de tags existentes
        if (controller.tags.isNotEmpty) ...[
          const Text(
            'Tags adicionadas:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.tags.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
                labelStyle: const TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w500,
                ),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 18,
                  color: Color(0xFF4CAF50),
                ),
                onDeleted: () => controller.removeTag(tag),
              );
            }).toList(),
          ),
        ] else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Text(
              'Nenhuma tag adicionada',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    ));
  }
} 