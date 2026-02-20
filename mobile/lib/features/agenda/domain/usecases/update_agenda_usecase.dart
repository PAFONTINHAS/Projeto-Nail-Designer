import 'package:mobile/features/agenda/domain/entities/agenda.dart';
import 'package:mobile/features/agenda/domain/repository/agenda_repository.dart';

class UpdateAgendaUsecase {

  ConfiguracoesRepository repository;

  UpdateAgendaUsecase(this.repository);
  

  Future<void> call(Agenda agenda) async{

    return await repository.updateAgenda(agenda);

  }

}