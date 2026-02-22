import 'package:logger/logger.dart';
import 'package:mobile/core/firebase/firebase_instances.dart';
import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:mobile/features/relatorios/data/models/relatorio_mensal_model.dart';
import 'package:mobile/features/relatorios/data/datasource/relatorios_remote_datasource.dart';

class RelatoriosRemoteDatasourceImpl implements RelatoriosRemoteDatasource {

  final _firestore = FirebaseInstances.firestore;
  final String collection = 'relatorios_mensais';

  @override
  Future<Map<String, RelatorioMensal>> getRelatoriosMensais() async{
    // final String mesId = "${agendamento.data.year}-${agendamento.data.month}";

    final snapshots = await _firestore.collection(collection).get();
    
    final Map<String, RelatorioMensal> relatorios = Map.fromEntries(
      snapshots.docs.map((doc) =>MapEntry(doc.id, RelatorioMensalModel.fromSnapshot(doc)))
    );

    return relatorios;
  }

  @override
  Future<void> addNewRelatorio(RelatorioMensal relatorio) async{

    try{
      await _firestore.collection(collection).doc(relatorio.id).set(relatorio.toMap());
    } catch(e){
      Logger().e("Erro ao atualizar relatorio: $e");
    }
  }

}