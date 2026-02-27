import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:mobile/features/relatorios/presentation/widgets/chart_card_widget.dart';
import 'package:mobile/features/relatorios/presentation/widgets/chart_legend_widget.dart';
import 'package:mobile/features/servico/presentation/controllers/servico_controller.dart';
import 'package:mobile/features/relatorios/presentation/controllers/relatorio_fields_controller.dart';

class IncomeDistributionWidget extends StatelessWidget {
  const IncomeDistributionWidget({super.key, this.relatorioMensal});

  final RelatorioMensal? relatorioMensal;
  @override
  Widget build(BuildContext context) {

    if(relatorioMensal != null){

      final controller = context.read<RelatorioFieldsController>();

      final distribuicao = relatorioMensal!.faturamentoPorCategoria;
      final secoes = controller.obterDadosGrafico(relatorioMensal!.faturamentoPorCategoria);

      return _buildIncomeDistributionCard(secoes, distribuicao);
    }

    return Selector<RelatorioFieldsController, Map<String, double>>(
      selector: (_, ctrl) => ctrl.calcularDistribuicaoPorCategoria(
        context.read<ServicoController>().servicos.values.toList(),
      ),
      builder: (context, distribuicao, _) {
        final relatorioCtrl = context.read<RelatorioFieldsController>();
        final secoes = relatorioCtrl.obterDadosGrafico(distribuicao);

        return _buildIncomeDistributionCard(secoes, distribuicao);
      },
    );

  }

  Widget _buildIncomeDistributionCard(List<PieChartSectionData> secoes, Map<String, double> distribuicao){
       
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const Text(
            "Distribuição de Receita",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          // O Gráfico
          SizedBox(height: 180, child: ChartCardWidget(secoes: secoes)),
          const SizedBox(height: 25),
          // As Legendas
          ChartLegendWidget(distribuicao: distribuicao),
        ],
      ),
    );
  }
}