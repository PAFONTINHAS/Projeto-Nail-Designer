import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';

abstract class RelatoriosLocalDatasource {

  Future<void> clearLocalData(String location);
  Future<Map<String, RelatorioMensal>?> getRelatorios();
  Future<void> storeRelatorios(Map<String, RelatorioMensal> relatorios);
}