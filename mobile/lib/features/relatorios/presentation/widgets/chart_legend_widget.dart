import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ChartLegendWidget  extends StatelessWidget {
  const ChartLegendWidget ({super.key, required this.distribuicao});
  final Map<String, double> distribuicao;
  @override
  Widget build(BuildContext context) {
    final precoFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    final cores = [
      Colors.pinkAccent,
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.orangeAccent,
    ];
    int corIndex = 0;

    return Wrap(
      // O Wrap faz os itens pularem para a linha de baixo se não couberem
      spacing: 20,
      runSpacing: 10,
      children: distribuicao.entries.map((entry) {
        final cor = cores[corIndex % cores.length];
        corIndex++;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  precoFormatter.format(entry.value),
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }
}