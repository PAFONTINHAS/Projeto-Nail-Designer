import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';

abstract class AgendamentoRepository {

  Stream<List<AgendamentoEntity>> listenAgendamentos();
}