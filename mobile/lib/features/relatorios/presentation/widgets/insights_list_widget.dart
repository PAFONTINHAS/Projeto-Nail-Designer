import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:mobile/features/relatorios/presentation/controllers/relatorio_fields_controller.dart';
import 'package:mobile/features/relatorios/presentation/widgets/insight_row_widget.dart';
import 'package:provider/provider.dart';

class InsightsListWidget extends StatelessWidget {
  const InsightsListWidget({super.key, required this.isPreviousMonth, this.relatorioMensal});

  final bool isPreviousMonth;
  final RelatorioMensal? relatorioMensal;

  @override
  Widget build(BuildContext context) {
    final precoFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    
    return relatorioMensal != null 
      ? _buildStaticInsights(precoFormatter, relatorioMensal!)
      : _buidDynamicInsights(precoFormatter);
  }

  Widget _buidDynamicInsights(NumberFormat precoFormatter ){
    
    return Column(
      children: [

        Selector<RelatorioFieldsController, int>(
          selector: (_, controller) => controller.agendamentosFiltrados.length,
          builder: (context, value, child) => InsightRowWidget(
            label: "Atendimentos",
            value: "$value Atendimentos",
            icon: Icons.people,
          ),
        ),

        Selector<RelatorioFieldsController, int>(
          selector: (_, controller) => controller.clientesAtendidos,
          builder: (context, value, child) => InsightRowWidget(
            label: "Clientes",
            value: "$value Clientes",
            icon: Icons.people,
          ),
        ),


        Selector<RelatorioFieldsController, double>(
          selector: (_, controller) => controller.ticketMedio,
          builder: (context, value, child) => InsightRowWidget(
            label: "Ticket Médio",
            value: precoFormatter.format(value),
            icon: Icons.trending_up,
          ),
        ),

        Selector<RelatorioFieldsController, int>(
          selector: (_, controller) => controller.faltas,
          builder: (context, value, child) => InsightRowWidget(
            label: "Faltas",
            value: "$value faltas",
            icon: Icons.person_off,
          ),
        ),

        Selector<RelatorioFieldsController, int>(
          selector: (_, controller) => controller.cancelamentos,
          builder: (context, value, child) => InsightRowWidget(
            label: "Cancelamentos",
            value: "$value cancelamentos",
            icon: Icons.cancel,
          ),
        ),

        Selector<RelatorioFieldsController, double>(
          selector: (_, controller) => controller.valorPerdidoFaltas,
          builder: (context, value, child) => InsightRowWidget(
            label: "Valor total perdido",
            value: precoFormatter.format(value),
            icon: Icons.money_off,
          ),
        ),

      ],
    );

  }

  Widget _buildStaticInsights(NumberFormat precoFormatter, RelatorioMensal relatorio){
    return Column(
      children: [

        InsightRowWidget(
          label: "Atendimentos",
          value: "${relatorio.totalAtendimentos} Atendimentos",
          icon: Icons.people,
        ),
    
        InsightRowWidget(
          label: "Clientes",
          value: "${relatorio.clientesAtendidos} Clientes",
          icon: Icons.people,
        ),

        InsightRowWidget(
          label: "Ticket Médio",
          value: precoFormatter.format(relatorio.ticketMedio),
          icon: Icons.trending_up,
        ),

        InsightRowWidget(
            label: "Faltas",
            value: "${relatorio.totalFaltas} faltas",
            icon: Icons.person_off,
          ),
      
        InsightRowWidget(
          label: "Cancelamentos",
          value: "${relatorio.totalCancelamentos} cancelamentos",
          icon: Icons.cancel,
        ),
      
        InsightRowWidget(
          label: "Valor total perdido",
          value: precoFormatter.format(relatorio.valorPerdidoFaltas),
          icon: Icons.money_off,
        ),

      ],
    );
  }
}
