import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/home/presentation/widgets/empty_list_widget.dart';
import 'package:mobile/features/configuracoes/presentation/pages/config_page.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/home/presentation/widgets/agendamento_card_widget.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AgendamentoController>();
    final agendamentos = controller.agendamentosDataSelecionada;
    final String dataVisualizada = "${controller.dataVisualizada.day.toString().padLeft(2, '0')}/${controller.dataVisualizada.month.toString().padLeft(2, '0')}";
    final bool isToday = controller.dataVisualizada.day == DateTime.now().day;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Cinza bem clarinho de fundo
      appBar: AppBar(
        title: const Text(
          "Minha Agenda",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          // Botão de Calendário que você já tinha
          IconButton(
            onPressed: () {
               // Você pode abrir o datePicker aqui também se quiser
            },
            icon: const Icon(Icons.calendar_month, color: Color(0xFFEC489A)),
          ),
          // NOVO: Botão de Configurações
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfigPage()),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.grey),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Resumo do Dia
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC489A), Color(0xFFD63384)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isToday ? "Hoje" : dataVisualizada,

                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        "${agendamentos.length} Agendamentos",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isToday ? "Hoje" : dataVisualizada,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: controller.dataVisualizada,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      controller.setDataVisualizada(date);
                    }
                  },
                  icon: const Icon(Icons.edit_calendar, size: 20),
                  label: const Text("Mudar data"),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Próximos Clientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const AgendamentosListWidget(),
        ],
      ),
    );
  }
}

class AgendamentosListWidget extends StatelessWidget {
  const AgendamentosListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AgendamentoController, List<AgendamentoEntity>>(
      selector: (_, controller) => controller.agendamentosDataSelecionada,
      builder: (context, agendamentos, _) {
        return Expanded(
          child: agendamentos.isEmpty
              ? const EmptyListWidget()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: agendamentos.length,
                  itemBuilder: (context, index) {
                    final agendamento = agendamentos[index];
                    return AgendamentoCard(agendamento: agendamento);
                  },
                ),
        );
      },
    );
  }
}
