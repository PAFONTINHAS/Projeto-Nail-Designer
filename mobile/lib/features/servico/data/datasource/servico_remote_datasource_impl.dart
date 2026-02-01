import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/core/firebase/firebase_instances.dart';
import 'package:mobile/features/servico/data/datasource/servico_remote_datasource.dart';
import 'package:mobile/features/servico/data/model/servico_model.dart';
import 'package:mobile/features/servico/domain/entities/servico_entity.dart';
import 'package:logger/logger.dart';

class ServicoRemoteDatasourceImpl implements ServicoRemoteDatasource{

  final FirebaseFirestore _firestore = FirebaseInstances.firestore;

  @override
  Future<List<ServicoEntity>> getServicos() async{


    try{
      
      final snapshot = await _firestore.collection('servicos').get();

      final List<ServicoEntity> servicos = snapshot.docs.map((doc) => ServicoModel.fromFirestore(doc)).toList();


      return servicos;
    } catch(e){

      Logger().e("Erro ao pegar serviços: $e");

      return [];
    }


  }
  
}