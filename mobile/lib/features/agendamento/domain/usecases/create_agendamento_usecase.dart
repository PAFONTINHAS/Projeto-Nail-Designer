import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/domain/repository/agendamento_repository.dart';

class CreateAgendamentoUsecase {

  final AgendamentoRepository repository;

  CreateAgendamentoUsecase(this.repository);

  Future<void> call(AgendamentoEntity agendamento) async{


    return await repository.createAgendamento(agendamento);

  }
}