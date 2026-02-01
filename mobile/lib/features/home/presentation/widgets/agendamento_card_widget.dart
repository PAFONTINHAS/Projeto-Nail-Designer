import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/servico/presentation/controllers/servico_controller.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_controller.dart';

class AgendamentoCard extends StatelessWidget {
  final AgendamentoEntity agendamento;

  const AgendamentoCard({super.key, required this.agendamento});

  // Função para abrir o WhatsApp com mensagem automática
  Future<void> _abrirWhatsApp() async {
    final numero = agendamento.contatoCliente.replaceAll(RegExp(r'[^0-9]'), '');
    final mensagem = "Olá ${agendamento.nomeCliente.split(' ').first}, aqui é a Natália do Studio de Nail Designer. Confirmado seu horário hoje às ${agendamento.data.hour}:${agendamento.data.minute.toString().padLeft(2, '0')}?";
    final uri = Uri.parse("https://wa.me/55$numero?text=${Uri.encodeComponent(mensagem)}");
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

@override
Widget build(BuildContext context) {
  final servicoController = context.read<ServicoController>();
  final servicos = servicoController.getServicosFromAgendamento(agendamento);

  return Card(
    margin: const EdgeInsets.only(bottom: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column( // Mudamos para Column para empilhar as informações e os botões
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeBadge(),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agendamento.nomeCliente,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: servicos.map((s) => _buildServiceTag(s.nome)).toList(),
                    ),
                  ],
                ),
              ),
              // Valor no canto superior direito
              Text(
                "R\$ ${agendamento.valorTotal.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),

          // SEÇÃO DE BOTÕES ABAIXO
          Row(
            children: [
              // Botão do WhatsApp (Secundário)
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: _abrirWhatsApp,
                  icon: const Icon(Icons.chat, color: Colors.green, size: 20),
                  tooltip: "Enviar mensagem",
                ),
              ),
              const SizedBox(width: 10),
              
              // Botão Finalizar (Principal)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _confirmarFinalizacao(context),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text(
                    "FINALIZAR ATENDIMENTO",
                    style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC489A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTimeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE7F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "${agendamento.data.hour}:${agendamento.data.minute.toString().padLeft(2, '0')}",
        style: const TextStyle(
          color: Color(0xFFEC489A),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildServiceTag(String nome) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        nome,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }

  void _confirmarFinalizacao(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Finalizar atendimento?"),
      content: Text("Deseja marcar o agendamento de ${agendamento.nomeCliente} como concluído?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<AgendamentoController>().atualizarStatus(agendamento.id, !agendamento.finalizado);
          },
          child: const Text("Confirmar"),
        ),
      ],
    ),
  );
}
}