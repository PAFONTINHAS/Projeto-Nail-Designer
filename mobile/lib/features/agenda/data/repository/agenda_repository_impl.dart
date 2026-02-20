import 'package:mobile/features/agenda/domain/entities/agenda.dart';
import 'package:mobile/features/agenda/domain/repository/agenda_repository.dart';
import 'package:mobile/features/agenda/data/datasource/agenda_remote_datasource.dart';

class ConfiguracoesRepositoryImpl implements ConfiguracoesRepository {

  final ConfiguracoesRemoteDatasource remoteDatasource;

  ConfiguracoesRepositoryImpl(this.remoteDatasource);
  @override
  Future<void> updateAgenda(Agenda agenda) async{
    return await remoteDatasource.updateAgenda(agenda);
  }
  
  @override
  Future<Agenda?> getAgenda() async{
    return await remoteDatasource.getAgenda();
  }


}