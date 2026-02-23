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
  
  final Map<String, Color> statusColors = {
    'agendado': Colors.blue.shade400,
    'finalizado': Colors.green.shade400,
    'falta': Colors.orange.shade400,
    'cancelado': Colors.red.shade400,
  };

  final Color statusColor = statusColors[agendamento.status] ?? Colors.grey;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect( // Garante que nada saia das bordas arredondadas
      borderRadius: BorderRadius.circular(20),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Indicador de Status Lateral
            Container(width: 6, color: Color(0xFFEC489A)),
            
            // Bloco de Data (Estilo Calendário)
            _buildDateBlock(Color(0xFFEC489A)),

            // Informações
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agendamento.nomeCliente,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: agendamento.servicos.map((id) {
                        final nome = servicoController.servicos[id]?.nome ?? "Serviço";
                        return _buildServiceTag(nome);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Ações
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_outlined, color: Colors.green, size: 20),
                  onPressed: _abrirWhatsApp,
                  tooltip: "WhatsApp",
                ),
                _buildPopupMenu(context),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDateBlock(Color color) {
  return Container(
    width: 65,
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${agendamento.data.day}/${agendamento.data.month.toString().padLeft(2, '0')}",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
        ),
        Text(
          "${agendamento.data.hour}:${agendamento.data.minute.toString().padLeft(2, '0')}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    ),
  );
}

Widget _buildPopupMenu(BuildContext context) {
  return PopupMenuButton<String>(
    icon: const Icon(Icons.more_vert, color: Colors.grey),
    onSelected: (String novoStatus) {
      // context.read<AgendamentoController>().atualizarStatus(agendamento.id, novoStatus);
      _confirmarStatus(context, novoStatus);
    },
    itemBuilder: (context) => [
      const PopupMenuItem(value: 'finalizado', child: _MenuOption(icon: Icons.check_circle, color: Colors.green, label: "Finalizar")),
      const PopupMenuItem(value: 'falta', child: _MenuOption(icon: Icons.person_off, color: Colors.orange, label: "Cliente Faltou")),
      const PopupMenuItem(value: 'cancelado', child: _MenuOption(icon: Icons.cancel, color: Colors.red, label: "Cancelar Horário")),
      // const PopupMenuItem(value: 'agendado', child: _MenuOption(icon: Icons.history, color: Colors.blue, label: "Reverter p/ Agendado")),
    ],
  );
}


  Widget _buildServiceTag(String nome) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Fundo cinza bem clarinho
        borderRadius: BorderRadius.circular(8),
        // Sem borda preta/escura aqui!
      ),
      child: Text(
        nome,
        style: TextStyle(
          fontSize: 11, 
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700, // Texto em cinza grafite
        ),
      ),
    );
  }

  

  void _confirmarStatus(BuildContext context, String status) {
    // Map de estilos para o Dialog
    final configs = {
      'finalizado': {'title': 'Finalizar?', 'icon': Icons.check_circle, 'color': Colors.green},
      'falta': {'title': 'Marcar Falta?', 'icon': Icons.person_off, 'color': Colors.orange},
      'cancelado': {'title': 'Cancelar?', 'icon': Icons.cancel, 'color': Colors.red},
      'agendado': {'title': 'Reverter?', 'icon': Icons.history, 'color': Colors.blue},
    }[status]!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            Icon(configs['icon'] as IconData, color: configs['color'] as Color, size: 48),
            const SizedBox(height: 16),
            Text(configs['title'] as String, textAlign: TextAlign.center),
          ],
        ),
        content: Text(
          "Deseja alterar o status de ${agendamento.nomeCliente} para ${status.toUpperCase()}?",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Voltar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: configs['color'] as Color,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.read<AgendamentoController>().atualizarStatus(agendamento.id, status);
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }
}

class _MenuOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _MenuOption({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}