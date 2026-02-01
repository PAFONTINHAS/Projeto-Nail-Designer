import 'package:flutter/material.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_controller.dart';
import 'package:provider/provider.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Selector<AgendamentoController, DateTime>(
      selector: (_, controller) => controller.dataVisualizada,
      builder: (context, dataVisualizada, _){

        String titulo = "Nenhum agendamento para hoje. Que tal tirar um chochilo? 🥱";


        final DateTime hoje = DateTime.now();
        final bool ehHoje = dataVisualizada.day == hoje.day &&  dataVisualizada.month == hoje.month && dataVisualizada.year == hoje.year;

        final String diaVisualizado = dataVisualizada.day.toString().padLeft(2, '0');
        final String mesVisualizado = dataVisualizada.month.toString().padLeft(2, '0');

        if(!ehHoje){
          titulo = "Nenhum agendamento para o dia $diaVisualizado/$mesVisualizado";
        }

        return Center(child: Text(titulo));
      },
    );
  }
}
