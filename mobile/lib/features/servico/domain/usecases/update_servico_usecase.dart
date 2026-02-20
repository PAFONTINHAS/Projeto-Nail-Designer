import 'package:mobile/features/servico/domain/entities/servico.dart';
import 'package:mobile/features/servico/domain/repository/servico_repository.dart';

class UpdateServicoUsecase {

  final ServicoRepository repository;

  UpdateServicoUsecase(this.repository);

  Future<void> call(Servico servico) async{

    return await repository.updateServico(servico);

  }
}