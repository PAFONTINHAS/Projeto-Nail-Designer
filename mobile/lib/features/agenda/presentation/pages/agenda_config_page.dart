import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/agenda/presentation/widgets/time_picker_widget.dart';
import 'package:mobile/features/agenda/presentation/widgets/date_selector_widget.dart';
import 'package:mobile/features/agenda/presentation/handlers/agenda_actions_handler.dart';
import 'package:mobile/features/agenda/presentation/controllers/agenda_controller.dart';

final logger = Logger();
class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {

@override
Widget build(BuildContext context) {
  final controller = context.watch<ConfiguracoesController>();

  return Scaffold(
    backgroundColor: const Color(0xFFF8F9FA), // Fundo levemente acinzentado para destacar os cards
    appBar: AppBar(
      title: const Text("Configurações de Agenda", style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // SEÇÃO 1: STATUS DA AGENDA
          _buildStatusCard(controller),
          const SizedBox(height: 20),

          // SEÇÃO 2: DIAS E HORÁRIOS
          _buildCard(
            title: "Horários de Atendimento",
            icon: Icons.access_time_filled,
            child: Column(
              children: [
                const DateSelectorWidget(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TimePickerTileWidget(
                        label: "Início",
                        time: controller.horarioInicio,
                        onTap: () => _selectTime(context, true),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TimePickerTileWidget(
                        label: "Fim",
                        time: controller.horarioFim,
                        onTap: () => _selectTime(context, false),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SEÇÃO 3: BLOQUEIO DE DATAS
          _buildCard(
            title: "Datas Bloqueadas",
            icon: Icons.event_busy,
            child: _buildDatasBloqueadasSection(context, controller),
          ),
          
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC489A),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () async => await AgendaActionsHandler.handleUpdateAgenda(context),
              child: const Text("SALVAR CONFIGURAÇÕES", style: TextStyle(color: Colors.white)),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}

// Card Genérico para as seções
Widget _buildCard({required String title, required IconData icon, required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFEC489A), size: 22),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
        const Divider(height: 30, thickness: 0.5),
        child,
      ],
    ),
  );
}

// Card de Status com o Switch
Widget _buildStatusCard(ConfiguracoesController controller) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: controller.agendaAtiva 
          ? [const Color(0xFFEC489A), Colors.pinkAccent] 
          : [Colors.grey, Colors.grey[400]!],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: SwitchListTile(
      value: controller.agendaAtiva,
      onChanged: (val) => controller.toggleAgendaAtiva(val),
      title: const Text("Agenda Online", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(
        controller.agendaAtiva ? "Clientes podem agendar agora" : "Agendamentos pausados no site",
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
      activeThumbColor: Colors.white,
    ),
  );
}

// Seção de Chips para Datas Bloqueadas
Widget _buildDatasBloqueadasSection(BuildContext context, ConfiguracoesController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (date != null) controller.addDataBloqueada(date);
        },
        icon: const Icon(Icons.add, size: 18),
        label: const Text("Adicionar Data"),
      ),
      const SizedBox(height: 15),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.datasBloqueadas.map((dateStr) {
          // Formata para BR apenas na exibição
          final parts = dateStr.split('-');
          final displayDate = "${parts[2]}/${parts[1]}/${parts[0]}";
          
          return Chip(
            label: Text(displayDate, style: const TextStyle(fontSize: 12)),
            backgroundColor: const Color(0xFFFFF0F6),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            deleteIcon: const Icon(Icons.cancel, size: 16, color: Color(0xFFEC489A)),
            onDeleted: () => controller.removeDataBloqueada(dateStr),
          );
        }).toList(),
      ),
    ],
  );
}


Future<void> _selectTime(BuildContext context, bool isInicio) async {
  final controller = context.read<ConfiguracoesController>();

  final String horaAtual = isInicio
      ? controller.horarioInicio
      : controller.horarioFim;

  final TimeOfDay initialTime = TimeOfDay(
    hour: int.parse(horaAtual.split(":")[0]),
    minute: int.parse(horaAtual.split(":")[1]),
  );

  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFEC489A), // cor dos ponteiros e seleção
            onPrimary: Colors.white,
            onSurface: Colors.black, // cor dos números
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    final String formattedTime =
        "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";

    if (isInicio) {
      controller.setHorarioInicio(formattedTime);
    } else {
      controller.setHorarioFim(formattedTime);
    }
  }
}
}


