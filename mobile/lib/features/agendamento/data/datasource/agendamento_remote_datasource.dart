import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';

abstract class AgendamentoRemoteDatasource {

  Stream<List<AgendamentoEntity>> listenAgendamentos();
}