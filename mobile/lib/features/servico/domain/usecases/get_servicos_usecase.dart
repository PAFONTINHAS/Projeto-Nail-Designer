import 'package:mobile/features/servico/domain/entities/servico.dart';
import 'package:mobile/features/servico/domain/repository/servico_repository.dart';

class GetServicosUsecase {

  ServicoRepository repository;

  GetServicosUsecase({required this.repository});

  Future<List<Servico>> call() async{
    return repository.getServicos();
  }
}