import 'package:mobile/features/relatorios/data/datasource/relatorios_local_datasource.dart';
import 'package:mobile/features/relatorios/data/datasource/relatorios_remote_datasource.dart';
import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:mobile/features/relatorios/domain/repository/relatorios_repository.dart';

class RelatoriosRepositoryImpl implements RelatoriosRepository {

  final RelatoriosLocalDatasource localDatasource;
  final RelatoriosRemoteDatasource remoteDatasource;

  RelatoriosRepositoryImpl({required this.localDatasource, required this.remoteDatasource});

  @override
  Future<Map<String, RelatorioMensal>> getRelatoriosMensais() async{

    await localDatasource.clearLocalData('cache_relatorios_mensais');
    
    final localRelatorios = await localDatasource.getRelatorios();

    if(localRelatorios != null) return localRelatorios;

    final remoteRelatorios = await remoteDatasource.getRelatoriosMensais();

    await localDatasource.storeRelatorios(remoteRelatorios);

    return remoteRelatorios;

  }




  
}