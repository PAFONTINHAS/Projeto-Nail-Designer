import 'package:mobile/features/servico/domain/entities/servico.dart';
import 'package:mobile/features/servico/domain/repository/servico_repository.dart';

class AddServicoUsecase {
  
  final ServicoRepository repository;

  AddServicoUsecase(this.repository);

  Future<Servico?> call(Servico servico) async{
    return await repository.addServico(servico);
  }
}