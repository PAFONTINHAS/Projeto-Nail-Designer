import 'package:mobile/features/configuracoes/domain/entities/agenda.dart';
import 'package:mobile/features/configuracoes/domain/repository/configuracoes_repository.dart';

class GetAgendaUsecase {

  ConfiguracoesRepository repository;

  GetAgendaUsecase(this.repository);

  Future<Agenda?> call() async{
    
    return await repository.getAgenda();
  }
}