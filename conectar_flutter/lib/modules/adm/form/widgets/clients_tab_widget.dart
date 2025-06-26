import 'package:flutter/material.dart';

import 'clients_filters_widget.dart';
import 'clients_list_widget.dart';

class ClientsTabWidget extends StatelessWidget {
  const ClientsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          const ClientsFiltersWidget(),
          const Expanded(child: ClientsListWidget()),
        ],
      ),
    );
  }
} 