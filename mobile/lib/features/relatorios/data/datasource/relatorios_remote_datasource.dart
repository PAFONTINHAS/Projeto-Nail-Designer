import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';

abstract class RelatoriosRemoteDatasource {

  Future<Map<String, RelatorioMensal>> getRelatoriosMensais();
  Future<void> addNewRelatorio(RelatorioMensal relatorio);

}