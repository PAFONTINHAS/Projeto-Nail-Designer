import 'package:flutter/material.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_controller.dart';
import 'package:provider/provider.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AgendamentoController, DateTime>(
      selector: (_, controller) => controller.dataVisualizada,
      builder: (context, dataVisualizada, _) {
        final DateTime hoje = DateTime.now();
        final bool ehHoje = dataVisualizada.day == hoje.day &&
            dataVisualizada.month == hoje.month &&
            dataVisualizada.year == hoje.year;

        final String diaMes = "${dataVisualizada.day.toString().padLeft(2, '0')}/${dataVisualizada.month.toString().padLeft(2, '0')}";

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone Principal (Cores suaves)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 60,
                  color: Colors.pinkAccent,
                ),
              ),
              const SizedBox(height: 24),
              
              // Título
              Text(
                ehHoje ? "Folga hoje? 🎉" : "Agenda livre!",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              // Subtítulo descritivo
              Text(
                ehHoje 
                    ? "Não há agendamentos para hoje. Aproveite para descansar ou organizar seus materiais! 💅" 
                    : "Nenhum horário marcado para o dia $diaMes até o momento.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // // Botão de ação (Opcional, mas muito útil)
              // OutlinedButton.icon(
              //   onPressed: () {
              //     // Aqui você chamaria a função de abrir o modal de novo agendamento
              //     // Ex: Navigator.pushNamed(context, '/novo-agendamento');
              //   },
              //   icon: const Icon(Icons.add),
              //   label: const Text("AGENDAR CLIENTE"),
              //   style: OutlinedButton.styleFrom(
              //     foregroundColor: Colors.pinkAccent,
              //     side: const BorderSide(color: Colors.pinkAccent),
              //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}