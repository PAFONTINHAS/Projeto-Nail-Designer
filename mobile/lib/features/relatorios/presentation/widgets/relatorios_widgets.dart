
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/relatorios/presentation/controllers/relatorio_fields_controller.dart';

class MonthPicker extends StatelessWidget {
  const MonthPicker({super.key});

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

class ChartCard extends StatelessWidget {
  const ChartCard({super.key, required this.secoes});
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

class MiniCard extends StatelessWidget {
  const MiniCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
        return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!), // Borda bem sutil
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class InsightRow extends StatelessWidget {
  const InsightRow({super.key, required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
        return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400], size: 22),
          const SizedBox(width: 15),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFEC489A), // Rosa do Studio para destacar o dado
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}


class TendencyBadge extends StatelessWidget {
  const TendencyBadge({super.key, required this.crescimento});

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

class PreviousReportMainCard extends StatelessWidget {
  const PreviousReportMainCard({super.key, required this.relatorio});

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
                builder: (context, crescimento, _) =>
                    TendencyBadge(crescimento: crescimento),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmptyReportState extends StatelessWidget {
  final String mes;
  const EmptyReportState({super.key, required this.mes});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Icon(Icons.auto_awesome_motion_outlined, 
             size: 80, color: Colors.grey[300]),
        const SizedBox(height: 20),
        Text(
          "Sem registros em $mes",
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: Colors.grey[600]
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Não encontramos agendamentos ou relatórios fechados para este período.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ),
      ],
    );
  }
}

class MainCard extends StatelessWidget {
  const MainCard({super.key});

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
                    builder: (context, crescimento, _) => TendencyBadge(crescimento: crescimento),
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


class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key, required this.distribuicao});
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