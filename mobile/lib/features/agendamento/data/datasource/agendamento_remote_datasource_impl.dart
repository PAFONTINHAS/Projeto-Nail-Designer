import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/core/firebase/firebase_instances.dart';
import 'package:mobile/features/agendamento/data/model/agendamento_model.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/data/datasource/agendamento_remote_datasource.dart';

class AgendamentoRemoteDatasourceImpl implements AgendamentoRemoteDatasource{

  final FirebaseFirestore _firestore = FirebaseInstances.firestore;

  @override
  Stream<List<AgendamentoEntity>> listenAgendamentos(){

    final ontem = DateTime.now().subtract(Duration(days: 1));

    Query query = _firestore.collection('agendamentos').where('data', isGreaterThanOrEqualTo: Timestamp.fromDate(ontem));

    final agendamentos = query.snapshots().map((snapshot){

      return snapshot.docs.map((doc) => AgendamentoModel.fromFirestore(doc)).toList();
    });

    return agendamentos;
  }
  
}