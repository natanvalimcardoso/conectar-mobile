import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/inputs/custom_input_widget.dart';
import '../client_form_controller.dart';
import 'status_dropdown_widget.dart';
import 'conecta_plus_checkbox_widget.dart';
import 'tags_section_widget.dart';

class DadosCadastraisWidget extends GetView<ClientFormController> {
  const DadosCadastraisWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.dadosCadastraisFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InformacoesCadastraisSection(),
            const SizedBox(height: 32),
            const EnderecoSection(),
            const SizedBox(height: 32),
            const StatusSection(),
            const SizedBox(height: 16),
            const ConectaPlusCheckboxWidget(),
            const SizedBox(height: 32),
            const TagsHeaderSection(),
            const SizedBox(height: 16),
            const TagsSectionWidget(),
          ],
        ),
      ),
    );
  }
}

class InformacoesCadastraisSection extends GetView<ClientFormController> {
  const InformacoesCadastraisSection({super.key});

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

class EnderecoSection extends GetView<ClientFormController> {
  const EnderecoSection({super.key});

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

class StatusSection extends StatelessWidget {
  const StatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        StatusDropdownWidget(),
      ],
    );
  }
}

class TagsHeaderSection extends StatelessWidget {
  const TagsHeaderSection({super.key});

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