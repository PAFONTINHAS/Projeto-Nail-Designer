import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';

abstract class AgendamentoRemoteDatasource {

  Stream<List<AgendamentoEntity>> listenAgendamentos();
  Future<void> atualizarStatus(String id, String status);
  Future<List<AgendamentoEntity>> getAgendamentosFromMonth(int year, int month);
  
}