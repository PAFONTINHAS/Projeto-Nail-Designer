import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';

abstract class RelatoriosRepository {

  Future<Map<String, RelatorioMensal>> getRelatoriosMensais();
  Future<void> addRelatorio(RelatorioMensal relatorio);

}