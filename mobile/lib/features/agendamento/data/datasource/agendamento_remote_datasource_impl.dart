import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:mobile/core/firebase/firebase_instances.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';
import 'package:mobile/features/agendamento/data/model/agendamento_model.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/data/datasource/agendamento_remote_datasource.dart';

class AgendamentoRemoteDatasourceImpl implements AgendamentoRemoteDatasource{

  final FirebaseFirestore _firestore = FirebaseInstances.firestore;

  @override
  Stream<List<AgendamentoEntity>> listenAgendamentos(){

    final passado = DateTime.now().subtract(Duration(days: 30));

    Query query = _firestore.collection('agendamentos').where('data', isGreaterThanOrEqualTo: Timestamp.fromDate(passado));

    final agendamentos = query.snapshots().map((snapshot){

      return snapshot.docs.map((doc) => AgendamentoModel.fromFirestore(doc)).toList();
    });

    return agendamentos;
  }

  @override
  Future<void> atualizarStatus(String id, bool status) async{
    try{
      await _firestore.collection('agendamentos').doc(id).update({'finalizado': status});
    }catch(e){
      Logger().e("Erro ao atualizar status: $e");
    }
  }
  
}