import 'package:mobile/features/configuracoes/domain/entities/agenda.dart';
import 'package:mobile/features/configuracoes/domain/repository/configuracoes_repository.dart';

class UpdateAgendaUsecase {

  ConfiguracoesRepository repository;

  UpdateAgendaUsecase(this.repository);
  

  Future<void> call(Agenda agenda) async{

    return await repository.updateAgenda(agenda);

  }

}