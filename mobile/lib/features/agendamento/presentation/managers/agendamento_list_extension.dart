import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';

extension AgendamentoListExtension on List<AgendamentoEntity>{

  List<AgendamentoEntity> getFinishedAgendamnetos(){
    return where((agendamento) => agendamento.finalizado).toList();
  }

  double getTotalReceived() {
    double finalValue = 0.00;

    for(final agendamento in this){

      finalValue += agendamento.valorTotal;
    }

    return finalValue;
  }


}