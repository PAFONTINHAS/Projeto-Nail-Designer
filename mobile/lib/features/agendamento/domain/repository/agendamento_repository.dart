import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';

abstract class AgendamentoRepository {

  Stream<List<AgendamentoEntity>> listenAgendamentos();
  Future<void> atualizarStatus(String id, bool status);
  Future<List<AgendamentoEntity>> getAgendamentosFromMonth(int year, int month);
}