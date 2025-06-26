import 'package:flutter/material.dart';

class InformacoesInternasTabWidget extends StatelessWidget {
  const InformacoesInternasTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Informações Internas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Esta aba será implementada em uma próxima versão',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
} 