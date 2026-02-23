import 'package:flutter/material.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_controller.dart';
import 'package:mobile/features/home/presentation/widgets/agendamento_card_widget.dart';
import 'package:provider/provider.dart';

class AgendamentosAtrasadosPage extends StatelessWidget {
  const AgendamentosAtrasadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,

      child: Scaffold(
        backgroundColor: const Color(
          0xFFF8F9FA,
        ), // Fundo levemente cinza para destacar os cards
        appBar: AppBar(
          title: const Text(
            "Pendências Passadas",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Selector<AgendamentoController, List<AgendamentoEntity>>(
          selector: (_, ctrl) => ctrl.agendamentosAtrasados,
          builder: (context, atrasados, _) {
            if (atrasados.isEmpty) {
              return _buildEmptyState();
            }

            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Espaço extra no fim para o botão
                  itemCount: atrasados.length + 1, // +1 para o cabeçalho
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildHeader(atrasados.length);

                    final agendamento = atrasados[index - 1];
                    return AgendamentoCard(agendamento: agendamento);
                  },
                ),

                // Botão Flutuante Estendido no Rodapé
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: _buildBulkActionButton(context, atrasados),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

Widget _buildHeader(int count) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Você tem $count agendamentos que já passaram. Organize-os para manter seu relatório atualizado!",
              style: TextStyle(color: Colors.amber.shade900, fontSize: 13),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildBulkActionButton(BuildContext context, List<AgendamentoEntity> atrasados) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 8,
      shadowColor: Colors.green.withOpacity(0.4),
    ),
    icon: const Icon(Icons.done_all),
    label: const Text(
      "FINALIZAR TUDO",
      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
    ),
    onPressed: () async{
      final controller = context.read<AgendamentoController>();

      for(final atrasado in atrasados){
        await controller.atualizarStatus(atrasado.id, "finalizado");
      }

      if(!context.mounted) return;

      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${atrasados.length} atendimentos finalizados com sucesso! 💅"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      // Chame sua função de lote aqui
    },
  );
}

Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline, size: 80, color: Colors.green.shade200),
        const SizedBox(height: 16),
        const Text(
          "Tudo em dia!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        const Text("Nenhuma pendência encontrada."),
      ],
    ),
  );
}
}