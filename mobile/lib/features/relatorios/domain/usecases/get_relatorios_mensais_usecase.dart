import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:mobile/features/relatorios/domain/repository/relatorios_repository.dart';
import 'package:mobile/features/relatorios/data/repository/relatorios_repository_impl.dart';

class GetRelatoriosMensaisUsecase {
  final RelatoriosRepository repository;

  GetRelatoriosMensaisUsecase(this.repository);

  Future<Map<String, RelatorioMensal>> call() async{

    return await repository.getRelatoriosMensais();
  } 
}