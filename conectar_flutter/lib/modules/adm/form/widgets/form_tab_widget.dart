import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../adm_form_controller.dart';
import 'form_header_widget.dart';
import 'form_tabs_widget.dart';
import 'form_content_widget.dart';
import 'form_bottom_actions_widget.dart';

class FormTabWidget extends GetView<AdmFormController> {
  const FormTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          const FormHeaderWidget(),
          const FormTabsWidget(),
          const Expanded(child: FormContentWidget()),
          const FormBottomActionsWidget(),
        ],
      ),
    );
  }
} 