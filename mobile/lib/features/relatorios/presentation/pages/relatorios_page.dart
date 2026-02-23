import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/relatorios/presentation/widgets/relatorios_widgets.dart';
import 'package:mobile/features/servico/presentation/controllers/servico_controller.dart';
import 'package:mobile/features/relatorios/presentation/controllers/relatorio_fields_controller.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  // relatorios_page.dart

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      left: false,
      top: false,
      right: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled){
            return [
              SliverAppBar(
                title: const Text(
                  "Performance e Lucro",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                pinned: true, // Isso mantém a AppBar fixa
                elevation: 0,
                forceElevated: innerBoxIsScrolled,
                // O segredo está aqui: o PreferredSize no bottom
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(80),
                  child: Selector<RelatorioFieldsController, DateTime>(
                    selector: (_, controller) => controller.mesReferencia,
                    builder: (context, value, child) => MonthPicker(),
                  ),
                ),
              ),
            ];
          },

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Selector<RelatorioFieldsController, DateTime>(
                  selector: (_, controller) => controller.mesReferencia,
                  builder: (context, value, child) {
                    final today = DateTime.now();
                    final isPreviousMonth =
                        (value.month < today.month && value.year == today.year) ||
                        (value.month == today.month && value.year < today.year) ||
                        (value.month < today.month && value.year < today.year)  ||
                        (value.month > today.month && value.year < today.year);

                    return isPreviousMonth
                        ? PreviousMonthReport()
                        : CurrentMonthReport();
                  },
                ),
              ],
            ),
          ),
        )
        
    
      ),
    );
  }
}


class CurrentMonthReport extends StatelessWidget {
  const CurrentMonthReport({super.key});

  @override
  Widget build(BuildContext context) {
    final precoFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    final controller = context.read<RelatorioFieldsController>();
    return Column(
      children: [
        MainCard(),
        const SizedBox(height: 25),

        Row(
          children: [
            Selector<RelatorioFieldsController, double>(
              selector: (_, controller) => controller.faturamentoRealizado,
              builder: (context, value, child) {
                return Expanded(
                  child: MiniCard(
                    title: "Realizado",
                    value: precoFormatter.format(value),
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                );
              },
            ),

            const SizedBox(width: 15),

            Selector<RelatorioFieldsController, double>(
              selector: (_, controller) => controller.faturamentoPrevisto,
              builder: (context, value, child) {
                return Expanded(
                  child: MiniCard(
                    title: "A Receber",
                    value: precoFormatter.format(value),
                    icon: Icons.timer,
                    color: Colors.orange,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 25),

        if(controller.qtdPendentes > 0)
          Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.pending_actions, color: Colors.amber, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Você tem ${controller.qtdPendentes} agendamentos passados ainda não finalizados.",
                    style: const TextStyle(fontSize: 13, color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 25),


        // 3. GRÁFICOS (Visão Visual)
        const Text(
          "Distribuição por Categoria",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        // Dentro da Column na RelatoriosPage
        Selector<RelatorioFieldsController, Map<String, double>>(
          selector: (_, ctrl) => ctrl.calcularDistribuicaoPorCategoria(
            context.read<ServicoController>().servicos.values.toList(),
          ),
          builder: (context, distribuicao, _) {
            final relatorioCtrl = context.read<RelatorioFieldsController>();
            final secoes = relatorioCtrl.obterDadosGrafico(distribuicao);

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
                  SizedBox(height: 180, child: ChartCard(secoes: secoes)),
                  const SizedBox(height: 25),
                  // As Legendas
                  ChartLegend(distribuicao: distribuicao),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 25),

        // 4. INSIGHTS RÁPIDOS
        Selector<RelatorioFieldsController, int>(
          selector: (_, controller) => controller.agendamentosFiltrados.length,
          builder: (context, value, child) => InsightRow(
            label: "Atendimentos",
            value: "$value Atendimentos",
            icon: Icons.people,
          ),
        ),

        Selector<RelatorioFieldsController, int>(
          selector: (_, controller) => controller.clientesAtendidos,
          builder: (context, value, child) => InsightRow(
            label: "Clientes",
            value: "$value Clientes",
            icon: Icons.people,
          ),
        ),


        Selector<RelatorioFieldsController, double>(
          selector: (_, controller) => controller.ticketMedio,
          builder: (context, value, child) => InsightRow(
            label: "Ticket Médio",
            value: precoFormatter.format(value),
            icon: Icons.trending_up,
          ),
        ),

        Selector<RelatorioFieldsController, int>(
          selector: (_, controller) => controller.faltas,
          builder: (context, value, child) => InsightRow(
            label: "Faltas",
            value: "$value faltas",
            icon: Icons.person_off,
          ),
        ),

        Selector<RelatorioFieldsController, int>(
          selector: (_, controller) => controller.cancelamentos,
          builder: (context, value, child) => InsightRow(
            label: "Cancelamentos",
            value: "$value cancelamentos",
            icon: Icons.cancel,
          ),
        ),

        Selector<RelatorioFieldsController, double>(
          selector: (_, controller) => controller.valorPerdidoFaltas,
          builder: (context, value, child) => InsightRow(
            label: "Valor total perdido",
            value: precoFormatter.format(value),
            icon: Icons.cancel,
          ),
        ),
      ],
    );
  }
}

class PreviousMonthReport extends StatelessWidget {
  const PreviousMonthReport({super.key});
  @override
  Widget build(BuildContext context) {
    final precoFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    final controller = context.read<RelatorioFieldsController>();
    final relatorio = controller.relatorioExibido;

    final mesString = "${controller.mesReferencia.month.toString().padLeft(2, '0')}/${controller.mesReferencia.year}";
    if(relatorio == null) return EmptyReportState(mes: mesString);

    final distribuicao = relatorio.faturamentoPorCategoria;
    final secoes = controller.obterDadosGrafico(relatorio.faturamentoPorCategoria);

    return Column(
      children: [

        PreviousReportMainCard(relatorio: relatorio),
        const SizedBox(height: 25),
        const SizedBox(height: 25),

        // 3. GRÁFICOS (Visão Visual)
        const Text(
          "Distribuição por Categoria",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        Container(
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
              SizedBox(height: 180, child: ChartCard(secoes: secoes)),
              const SizedBox(height: 25),
              // As Legendas
              ChartLegend(distribuicao: distribuicao),
            ],
          ),
        ),

        const SizedBox(height: 25),

    
        InsightRow(
          label: "Atendimentos",
          value: "${relatorio.totalAtendimentos} Atendimentos",
          icon: Icons.people,
        ),
    
        InsightRow(
          label: "Clientes",
          value: "${relatorio.clientesAtendidos} Clientes",
          icon: Icons.people,
        ),

        InsightRow(
          label: "Ticket Médio",
          value: precoFormatter.format(relatorio.ticketMedio),
          icon: Icons.trending_up,
        ),

        InsightRow(
            label: "Faltas",
            value: "${relatorio.totalFaltas} faltas",
            icon: Icons.person_off,
          ),
      
        InsightRow(
          label: "Cancelamentos",
          value: "${relatorio.totalCancelamentos} cancelamentos",
          icon: Icons.cancel,
        ),
      
        InsightRow(
          label: "Valor total perdido",
          value: precoFormatter.format(relatorio.valorPerdidoFaltas),
          icon: Icons.cancel,
        ),
      ],  
    );
  }
}
