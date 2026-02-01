import 'package:mobile/features/servico/domain/entities/servico_entity.dart';
import 'package:mobile/features/servico/domain/repository/servico_repository.dart';

class GetServicosUsecase {

  ServicoRepository repository;

  GetServicosUsecase({required this.repository});

  Future<List<ServicoEntity>> call() async{
    return repository.getServicos();
  }
}