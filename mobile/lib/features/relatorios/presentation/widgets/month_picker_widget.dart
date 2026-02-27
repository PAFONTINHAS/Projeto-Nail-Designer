import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/relatorios/presentation/controllers/relatorio_fields_controller.dart';

class MonthPickerWidget extends StatelessWidget {
  const MonthPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final meses = [
      "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
      "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ];

    final controller = context.read<RelatorioFieldsController>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Color(0xFFEC489A)),
            onPressed: () => controller.changeMonth(-1),
          ),
          Text(
            "${meses[controller.mesReferencia.month - 1]} ${controller.mesReferencia.year}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xFFEC489A)),
            onPressed: () => controller.changeMonth(1),
          ),
        ],
      ),
    );
  }
}