import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/relatorios/presentation/widgets/main_card_widget.dart';
import 'package:mobile/features/relatorios/presentation/widgets/mini_card_widget.dart';
import 'package:mobile/features/relatorios/presentation/widgets/month_picker_widget.dart';
import 'package:mobile/features/relatorios/presentation/widgets/insights_list_widget.dart';
import 'package:mobile/features/relatorios/presentation/widgets/empty_report_state_widget.dart';
import 'package:mobile/features/relatorios/presentation/widgets/income_distribution_widget.dart';
import 'package:mobile/features/relatorios/presentation/controllers/relatorio_fields_controller.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

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
                    builder: (context, value, child) => MonthPickerWidget(),
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

                    return MonthReportWidget(isPreviousMonth: isPreviousMonth);
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


class MonthReportWidget extends StatelessWidget {
  const MonthReportWidget({super.key, required this.isPreviousMonth});

  final bool isPreviousMonth;


  @override
  Widget build(BuildContext context) {
    final precoFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    final controller = context.read<RelatorioFieldsController>();
    final relatorioMensal = isPreviousMonth ? controller.relatorioExibido : null;
    final mesString = "${controller.mesReferencia.month.toString().padLeft(2, '0')}/${controller.mesReferencia.year}";
    
    if(relatorioMensal == null && isPreviousMonth) return EmptyReportStateWidget(mes: mesString);

    return Column(
      children: [

        MainCardWidget(relatorio: relatorioMensal),

        const SizedBox(height: 25),

        if(!isPreviousMonth) _buildMiniCards(precoFormatter),

        const SizedBox(height: 25),

        if(!isPreviousMonth && controller.qtdPendentes > 0) _buildPendingCard(controller.qtdPendentes),

        const SizedBox(height: 25),

        const Text(
          "Distribuição por Categoria",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 15),

        IncomeDistributionWidget(relatorioMensal:  relatorioMensal),

        const SizedBox(height: 25),

        InsightsListWidget(isPreviousMonth: isPreviousMonth, relatorioMensal: relatorioMensal),


      ],

    );
  }


  Widget _buildMiniCards(NumberFormat precoFormatter) {
    return Row(
      children: [
        Selector<RelatorioFieldsController, double>(
          selector: (_, controller) => controller.faturamentoRealizado,
          builder: (context, value, child) {
            return Expanded(
              child: MiniCardWidget(
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
              child: MiniCardWidget(
                title: "A Receber",
                value: precoFormatter.format(value),
                icon: Icons.timer,
                color: Colors.orange,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPendingCard(int quantity){
    return Container(
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
              "Você tem $quantity agendamentos passados ainda não finalizados.",
              style: const TextStyle(fontSize: 13, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}



