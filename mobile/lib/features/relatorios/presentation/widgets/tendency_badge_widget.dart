import 'package:flutter/material.dart';

class TendencyBadgeWidget extends StatelessWidget {
  const TendencyBadgeWidget({super.key, required this.crescimento});

  final double crescimento;

  @override
  Widget build(BuildContext context) {

    final isPositivo = crescimento >= 0;
    final cor = isPositivo ? Colors.greenAccent : Colors.orangeAccent;
    final icone = isPositivo ? Icons.trending_up : Icons.trending_down;
    final porcentagem = (crescimento * 100).abs().toStringAsFixed(0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: cor, size: 16),
          const SizedBox(width: 4),
          Text(
            "$porcentagem% vs mês ant.",
            style: TextStyle(
              color: cor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}