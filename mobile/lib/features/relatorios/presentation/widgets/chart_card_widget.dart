import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartCardWidget extends StatelessWidget {
  const ChartCardWidget({super.key, required this.secoes});
  final List<PieChartSectionData> secoes;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      child: secoes.isEmpty
          ? const Center(child: Text("Sem dados para exibir"))
          : PieChart(
              PieChartData(
                sectionsSpace: 2, // Espaço entre as fatias
                centerSpaceRadius: 40, // Tamanho do furo no meio
                sections: secoes,
                borderData: FlBorderData(show: false),
              ),
            ),
    );
  }
}