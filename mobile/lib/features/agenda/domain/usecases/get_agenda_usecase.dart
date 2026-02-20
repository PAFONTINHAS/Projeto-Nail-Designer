import 'package:mobile/features/agenda/domain/entities/agenda.dart';
import 'package:mobile/features/agenda/domain/repository/agenda_repository.dart';

class GetAgendaUsecase {

  ConfiguracoesRepository repository;

  GetAgendaUsecase(this.repository);

  Future<Agenda?> call() async{
    
    return await repository.getAgenda();
  }
}