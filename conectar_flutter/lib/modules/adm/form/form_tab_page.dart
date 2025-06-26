import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'adm_form_controller.dart';
import 'widgets/form_header_widget.dart';
import 'widgets/form_tabs_widget.dart';
import 'widgets/form_content_widget.dart';
import 'widgets/form_bottom_actions_widget.dart';

class FormTabPage extends GetView<AdmFormController> {
  const FormTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FormHeaderWidget(),
        const FormTabsWidget(),
        const Expanded(child: FormContentWidget()),
        const FormBottomActionsWidget(),
      ],
    );
  }
} 