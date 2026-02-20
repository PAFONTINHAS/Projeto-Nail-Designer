import 'package:logger/web.dart';
import 'package:mobile/core/firebase/firebase_instances.dart';
import 'package:mobile/features/agenda/data/datasource/agenda_remote_datasource.dart';
import 'package:mobile/features/agenda/data/models/agenda_model.dart';
import 'package:mobile/features/agenda/domain/entities/agenda.dart';

class ConfiguracoesRemoteDatasourceImpl implements ConfiguracoesRemoteDatasource{

  final _firestore = FirebaseInstances.firestore;
  final String collection = "configuracoes";
  final String agendaDoc = "agenda";
  final logger = Logger();

  @override
  Future<Agenda?> getAgenda() async{

    try{
      final doc = await _firestore.collection(collection).doc(agendaDoc).get();

      return AgendaModel.fromSnapshot(doc);
    } catch(e, s){

      logger.e("Erro ao pegar agenda: $e, stack: $s");
      
      return null;
    }
  }

  @override
  Future<void> updateAgenda(Agenda agenda) async{
    try{
      await _firestore.collection(collection).doc(agendaDoc).update(agenda.toMap());
    } catch(e, s){
      logger.e("Erro ao pegar agenda: $e, stack: $s");
    }
  }





}