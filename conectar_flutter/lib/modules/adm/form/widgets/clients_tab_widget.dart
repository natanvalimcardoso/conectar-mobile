import 'package:flutter/material.dart';

import 'clients_filters_widget.dart';
import 'clients_list_widget.dart';

class ClientsTabWidget extends StatelessWidget {
  const ClientsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ClientsFiltersWidget(),
        Expanded(child: ClientsListWidget()),
      ],
    );
  }
} 