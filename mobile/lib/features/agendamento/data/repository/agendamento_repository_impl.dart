import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/domain/repository/agendamento_repository.dart';
import 'package:mobile/features/agendamento/data/datasource/agendamento_remote_datasource.dart';

class AgendamentoRepositoryImpl implements AgendamentoRepository{

  final AgendamentoRemoteDatasource remoteDatasource;

  AgendamentoRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<List<AgendamentoEntity>> listenAgendamentos(){

    return remoteDatasource.listenAgendamentos();
  }

  @override
  Future<void> atualizarStatus(String id, String status) async{
    return await remoteDatasource.atualizarStatus(id, status);
  }

  @override
  Future<List<AgendamentoEntity>> getAgendamentosFromMonth(int year, int month) async{
    return await remoteDatasource.getAgendamentosFromMonth(year, month);
  }


  
} 