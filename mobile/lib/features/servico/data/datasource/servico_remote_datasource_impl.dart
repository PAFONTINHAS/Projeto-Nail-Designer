import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/core/firebase/firebase_instances.dart';
import 'package:mobile/features/servico/data/datasource/servico_remote_datasource.dart';
import 'package:mobile/features/servico/data/model/servico_model.dart';
import 'package:mobile/features/servico/domain/entities/servico.dart';
import 'package:logger/logger.dart';

class ServicoRemoteDatasourceImpl implements ServicoRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseInstances.firestore;

  @override
  Future<Servico?> addServico(Servico servico) async {
    try {

      final docRef = _firestore.collection('servicos').doc();

      await docRef.set(servico.toMap());

      return servico.copyWith(id: docRef.id);
    
    } catch (e) {
      Logger().e("Erro ao adicionar serviço: $e");
      return null;
    }
  }

  @override
  Future<void> updateServico(Servico servico) async {
    try {
      
      await _firestore.collection('servicos').doc(servico.id).update(servico.toMap());

    } catch (e) {
      Logger().e("Erro ao adicionar serviço: $e");
    }
  }

  @override
  Future<List<Servico>> getServicos() async {
    try {
      final snapshot = await _firestore.collection('servicos').get();

      final List<Servico> servicos = snapshot.docs
          .map((doc) => ServicoModel.fromFirestore(doc))
          .toList();

      return servicos;
    } catch (e) {
      Logger().e("Erro ao pegar serviços: $e");

      return [];
    }
  }

  @override
  Future<void> deleteServico(String id) async {
    try {
      await _firestore.collection('servicos').doc(id).delete();

    } catch (e) {
      Logger().e("Erro ao pegar serviços: $e");
    }
  }



}
