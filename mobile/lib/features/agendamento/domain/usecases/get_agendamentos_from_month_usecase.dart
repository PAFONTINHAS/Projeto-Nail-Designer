import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/domain/repository/agendamento_repository.dart';

class GetAgendamentosFromMonthUsecase {
  AgendamentoRepository repository;

  GetAgendamentosFromMonthUsecase(this.repository);

  Future<List<AgendamentoEntity>> call(int year, int month) async{

    return await repository.getAgendamentosFromMonth(year, month);

  }
}