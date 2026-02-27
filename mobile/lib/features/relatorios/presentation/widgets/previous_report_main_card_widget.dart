import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:mobile/features/relatorios/presentation/widgets/tendency_badge_widget.dart';
import 'package:mobile/features/relatorios/presentation/controllers/relatorio_fields_controller.dart';

class PreviousReportMainCardWidget extends StatelessWidget {
  const PreviousReportMainCardWidget({super.key, required this.relatorio});

  final RelatorioMensal relatorio;

  @override
  Widget build(BuildContext context) {
    final precoFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC489A), Color(0xFFD63384)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC489A).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CAPTAÇÃO TOTAL DO MÊS",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            precoFormatter.format(relatorio.faturamentoRealizado),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Dentro do Column do _buildPrincipalCard
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              // O Badge de comparação aparece aqui
              Selector<RelatorioFieldsController, double>(
                selector: (_, ctrl) => ctrl.crescimentoComparativo,
                builder: (context, crescimento, _) => TendencyBadgeWidget(crescimento: crescimento),
              ),
            ],
          ),
        ],
      ),
    );
  }
}