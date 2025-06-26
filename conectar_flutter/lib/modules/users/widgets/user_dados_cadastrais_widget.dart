import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/inputs/custom_input_widget.dart';
import '../user_client_form_controller.dart';
import '../../clients/widgets/status_dropdown_widget.dart';
import 'user_conecta_plus_checkbox_widget.dart';
import 'user_tags_section_widget.dart';

class UserDadosCadastraisWidget extends GetView<UserClientFormController> {
  const UserDadosCadastraisWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.dadosCadastraisFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserInformacoesCadastraisSection(),
            const SizedBox(height: 32),
            const UserEnderecoSection(),
            const SizedBox(height: 32),
            const UserStatusSection(),
            const SizedBox(height: 16),
            const UserConectaPlusCheckboxWidget(),
            const SizedBox(height: 32),
            const UserTagsHeaderSection(),
            const SizedBox(height: 16),
            const UserTagsSectionWidget(),
          ],
        ),
      ),
    );
  }
}

class UserInformacoesCadastraisSection extends GetView<UserClientFormController> {
  const UserInformacoesCadastraisSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          validator: controller.validateNomeFachada,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 16),
        CustomInputWidget(
          hintText: 'CNPJ',
          controller: controller.cnpjController,
          validator: controller.validateCNPJ,
          keyboardType: TextInputType.number,
          inputFormatters: [controller.cnpjFormatter],
        ),
        const SizedBox(height: 16),
        CustomInputWidget(
          hintText: 'Razão Social',
          controller: controller.razaoSocialController,
          validator: controller.validateRazaoSocial,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}

class UserEnderecoSection extends GetView<UserClientFormController> {
  const UserEnderecoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                keyboardType: TextInputType.number,
                inputFormatters: [controller.cepFormatter],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: CustomInputWidget(
                hintText: 'Rua',
                controller: controller.ruaController,
                validator: controller.validateRua,
                keyboardType: TextInputType.streetAddress,
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
                validator: controller.validateNumero,
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomInputWidget(
                hintText: 'Bairro',
                controller: controller.bairroController,
                validator: controller.validateBairro,
                keyboardType: TextInputType.text,
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
                validator: controller.validateCidade,
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: CustomInputWidget(
                hintText: 'Estado',
                controller: controller.estadoController,
                validator: controller.validateEstado,
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomInputWidget(
          hintText: 'Complemento',
          controller: controller.complementoController,
          validator: controller.validateComplemento,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}

class UserStatusSection extends GetView<UserClientFormController> {
  const UserStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedStatus.value,
          decoration: const InputDecoration(
            labelText: 'Status do cliente',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
            DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
          ],
          onChanged: (value) {
            if (value != null) {
              controller.selectedStatus.value = value;
            }
          },
        )),
      ],
    );
  }
}

class UserTagsHeaderSection extends StatelessWidget {
  const UserTagsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Tags',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
} 