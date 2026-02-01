import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/domain/repository/agendamento_repository.dart';

class ListenAgendamentosUsecase {

  AgendamentoRepository repository;

  ListenAgendamentosUsecase({required this.repository});

  Stream<List<AgendamentoEntity>> call(){
    return repository.listenAgendamentos();
  }
}