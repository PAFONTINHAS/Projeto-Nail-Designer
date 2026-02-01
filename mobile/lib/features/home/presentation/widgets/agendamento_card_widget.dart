import 'package:flutter/material.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/servico/presentation/controllers/servico_controller.dart';
import 'package:provider/provider.dart';

class AgendamentoCard extends StatelessWidget {
  const AgendamentoCard({super.key, required this.agendamento});

  final AgendamentoEntity agendamento;

  @override
  Widget build(BuildContext context) {
    final servicoController = context.read<ServicoController>();

    final servicos = servicoController.getServicosFromAgendamento(agendamento);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          // Hora em destaque
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE7F3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "${agendamento.data.hour.toString().padLeft(2, '0')}:${agendamento.data.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(
                color: Color(0xFFEC489A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Detalhes
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agendamento.nomeCliente,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                ...servicos.map((servico) {
                  return Text(
                    servico.nome,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  );
                }),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}