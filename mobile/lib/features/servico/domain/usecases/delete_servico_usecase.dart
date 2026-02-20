import 'package:mobile/features/servico/domain/repository/servico_repository.dart';

class DeleteServicoUsecase {

  final ServicoRepository repository;

  DeleteServicoUsecase(this.repository);

  Future<void> call(String id) async{

    return await repository.deleteServico(id);

  }
}