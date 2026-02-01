import 'package:mobile/features/agendamento/domain/repository/agendamento_repository.dart';

class AtualizarStatusUsecase {

  AgendamentoRepository repository;
  
  AtualizarStatusUsecase({required this.repository});

  Future<void> call(String id, bool status) async{
    return await repository.atualizarStatus(id, status);
  }
}