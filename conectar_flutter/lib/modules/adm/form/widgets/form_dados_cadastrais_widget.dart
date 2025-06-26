import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../adm_form_controller.dart';
import 'form_tags_section_widget.dart';

class FormDadosCadastraisWidget extends GetView<AdmFormController> {
  const FormDadosCadastraisWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.dadosCadastraisFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormInformacoesCadastraisSection(),
            const SizedBox(height: 32),
            const FormEnderecoSection(),
            const SizedBox(height: 32),
            const FormStatusSection(),
            const SizedBox(height: 16),
            const FormConectaPlusSection(),
            const SizedBox(height: 32),
            const FormTagsHeaderSection(),
            const SizedBox(height: 16),
            const FormTagsSectionWidget(),
          ],
        ),
      ),
    );
  }
}

class FormInformacoesCadastraisSection extends GetView<AdmFormController> {
  const FormInformacoesCadastraisSection({super.key});

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
        TextFormField(
          controller: controller.nomeNaFachadaController,
          validator: controller.validateNomeFachada,
          decoration: const InputDecoration(
            labelText: 'Nome na fachada *',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.cnpjController,
          validator: controller.validateCNPJ,
          keyboardType: TextInputType.number,
          inputFormatters: [controller.cnpjFormatter],
          decoration: const InputDecoration(
            labelText: 'CNPJ *',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.razaoSocialController,
          validator: controller.validateRazaoSocial,
          decoration: const InputDecoration(
            labelText: 'Razão Social *',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class FormEnderecoSection extends GetView<AdmFormController> {
  const FormEnderecoSection({super.key});

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
              child: TextFormField(
                controller: controller.cepController,
                validator: controller.validateCEP,
                keyboardType: TextInputType.number,
                inputFormatters: [controller.cepFormatter],
                decoration: const InputDecoration(
                  labelText: 'CEP *',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: controller.ruaController,
                validator: controller.validateRua,
                decoration: const InputDecoration(
                  labelText: 'Rua *',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: controller.numeroController,
                validator: controller.validateNumero,
                decoration: const InputDecoration(
                  labelText: 'Número *',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: controller.bairroController,
                validator: controller.validateBairro,
                decoration: const InputDecoration(
                  labelText: 'Bairro *',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: controller.cidadeController,
                validator: controller.validateCidade,
                decoration: const InputDecoration(
                  labelText: 'Cidade *',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: controller.estadoController,
                validator: controller.validateEstado,
                decoration: const InputDecoration(
                  labelText: 'Estado *',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.complementoController,
          validator: controller.validateComplemento,
          decoration: const InputDecoration(
            labelText: 'Complemento',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class FormStatusSection extends GetView<AdmFormController> {
  const FormStatusSection({super.key});

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

class FormConectaPlusSection extends GetView<AdmFormController> {
  const FormConectaPlusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CheckboxListTile(
      title: const Text('Conecta Plus'),
      subtitle: const Text('Cliente possui serviço Conecta Plus'),
      value: controller.conectaPlus.value,
      onChanged: (value) {
        controller.conectaPlus.value = value ?? false;
      },
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color(0xFF4CAF50),
    ));
  }
}

class FormTagsHeaderSection extends StatelessWidget {
  const FormTagsHeaderSection({super.key});

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