import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/relatorios/presentation/widgets/tendency_badge_widget.dart';
import 'package:mobile/features/relatorios/presentation/controllers/relatorio_fields_controller.dart';

class MainCardWidget extends StatelessWidget {
  const MainCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RelatorioFieldsController, double>(
      selector: (_, controller) => controller.faturamentoTotalProjetado,
      builder: (context, value, child) {
        final precoFormatter = NumberFormat.currency(
          locale: 'pt_BR',
          symbol: 'R\$',
        );
        // final controller = context.watch<RelatorioFieldsController>();

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
                "PROJEÇÃO TOTAL DO MÊS",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                precoFormatter.format(value),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Dentro do Column do _buildPrincipalCard
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("PROJEÇÃO TOTAL", style: TextStyle(color: Colors.white70)),
                  
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
      },
    );
  }
}