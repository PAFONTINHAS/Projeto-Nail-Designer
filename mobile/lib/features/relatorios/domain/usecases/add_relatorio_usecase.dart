import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:mobile/features/relatorios/domain/repository/relatorios_repository.dart';

class AddRelatorioUsecase {

  final RelatoriosRepository repository;

  AddRelatorioUsecase(this.repository);

  Future<void> call(RelatorioMensal relatorio){
    return repository.addRelatorio(relatorio);
  }
}