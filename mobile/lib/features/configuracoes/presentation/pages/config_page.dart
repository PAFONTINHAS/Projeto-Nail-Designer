import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile/features/configuracoes/presentation/controllers/configuracoes_controller.dart';
import 'package:mobile/features/configuracoes/presentation/handlers/agenda_actions_handler.dart';
import 'package:provider/provider.dart';

final logger = Logger();
class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfiguracoesController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Configurações da Agenda")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: "Dias de Atendimento"),
            const SizedBox(height: 10),
            const DiasSelector(),
            const SizedBox(height: 30),
            SectionTitle(title: "Horário de Trabalho"),

            Selector<ConfiguracoesController, String>(
              selector: (_, controller) => controller.horarioInicio,
              builder: (context, value, child) => TimePickerTile(
                label: "Início",
                time: value,
                onTap: () async => await _selectTime(context, true),
              ),
            ),

            Selector<ConfiguracoesController, String>(
              selector: (_, controller) => controller.horarioFim,
              builder: (context, value, child) => TimePickerTile(
                label: "Fim",
                time: value,
                onTap: () async => await _selectTime(context, false),
              ),
            ),
            
            const SizedBox(height: 40),
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
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isInicio) async{

    final controller = context.read<ConfiguracoesController>();
    

    final String horaAtual = isInicio? controller.horarioInicio : controller.horarioFim;  

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

    if(picked != null){
      final String formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";

      if (isInicio) {
        controller.setHorarioInicio(formattedTime);
      } else {
        controller.setHorarioFim(formattedTime);
      }
    }
  }


}


class TimePickerTile extends StatelessWidget {
  const TimePickerTile({super.key, required this.label, required this.time, required this.onTap});

  final String label;
  final String time;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFEC489A))),
      onTap: onTap
    );
  }

}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54));

  }
}

class DiasSelector extends StatefulWidget {
  const DiasSelector({super.key});

  @override
  State<DiasSelector> createState() => _DiasSelectorState();
}

class _DiasSelectorState extends State<DiasSelector> {
  @override
  Widget build(BuildContext context) {

    final List<String> diasSemana = ["D", "S", "T", "Q", "Q", "S", "S"];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Selector<ConfiguracoesController, List<int>>(
        selector: (_, controller) => controller.selecionados,
        builder: (context, selecionados, child) {
          final controller = context.read<ConfiguracoesController>();
          controller.orderDiasSelecionados();

          Logger().i("Dias selecionados:  $selecionados");
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final isSelected = selecionados.contains(index);
              return GestureDetector(
                onTap: () {
                  isSelected
                      ? controller.removeDiaSelecionado(index)
                      : controller.addDiaSelecionado(index); // selecionados.remove(index) : selecionados.add(index);
                },
                child: CircleAvatar(
                  backgroundColor: isSelected
                      ? const Color(0xFFEC489A)
                      : Colors.grey[200],
                  child: Text(
                    diasSemana[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
      
    );
  }
}