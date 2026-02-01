import 'package:mobile/features/agendamento/data/datasource/agendamento_remote_datasource.dart';
import 'package:mobile/features/agendamento/data/datasource/agendamento_remote_datasource_impl.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/domain/repository/agendamento_repository.dart';

class AgendamentoRepositoryImpl implements AgendamentoRepository{

  final AgendamentoRemoteDatasource remoteDatasource;

  AgendamentoRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<List<AgendamentoEntity>> listenAgendamentos(){

    return remoteDatasource.listenAgendamentos();
  }
  
} 